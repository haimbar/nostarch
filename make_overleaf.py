#!/usr/bin/env python3
"""
make_overleaf.py

Prepares a self-contained LaTeX project copy for Overleaf, where the
talk2stat server cannot run and generated/ files would be zero bytes.

Strategy: copy all necessary files to tmpoverleaf/, then replace every
\\includeOutput{label} and \\inlnR{code}[label] call with the cached
content from generated/label.tex so no code execution is needed.

Usage:
    python3 make_overleaf.py [--dry-run] [overleaf_path]

    overleaf_path  optional path to rsync to, e.g.:
                   ~/Documents/GitHub/62d8236139638c60adaa065c/
    --dry-run      show what rsync would transfer without writing anything
"""

import argparse
import os
import shutil
import subprocess
import sys
from pathlib import Path

# ── Paths ──────────────────────────────────────────────────────────────────────
PROJECT_DIR = Path(__file__).parent.resolve()
TMPOVERLEAF = PROJECT_DIR / "tmpoverleaf"
GENERATED_DIR = PROJECT_DIR / "generated"

# Individual files to copy
FILES_TO_COPY = [
    "sidsmain.tex",
    "book.bib",
    "nostarch.cls",
    "runcode.sty",
    "nshyper.sty",
    "R.config",
]

# Directories to copy wholesale
DIRS_TO_COPY = ["chapters", "images", "Code", "styfiles", "fonts"]

# ── LaTeX parsing helpers ──────────────────────────────────────────────────────


def find_closing_brace(text: str, pos: int) -> int:
    """Return index of the } matching the { at text[pos], or -1."""
    assert text[pos] == "{"
    depth = 0
    for i in range(pos, len(text)):
        if text[i] == "{":
            depth += 1
        elif text[i] == "}":
            depth -= 1
            if depth == 0:
                return i
    return -1


def read_optional_arg(text: str, pos: int) -> tuple:
    """If text[pos] == '[', consume and return (content, new_pos). Else (None, pos)."""
    if pos >= len(text) or text[pos] != "[":
        return None, pos
    end = text.find("]", pos + 1)
    if end == -1:
        return None, pos
    return text[pos + 1 : end], end + 1


# ── Cache reader ───────────────────────────────────────────────────────────────


def read_cached(label: str) -> str | None:
    """Return content of generated/label.tex.

    Returns None if the file doesn't exist.
    Returns '' if the file is effectively empty (≤1 byte).
    """
    path = GENERATED_DIR / (label + ".tex")
    if not path.exists():
        return None
    if path.stat().st_size <= 1:
        return ""
    return path.read_text(encoding="utf-8", errors="replace")


# ── Replacement builders ───────────────────────────────────────────────────────


def wrap_vbox(content: str) -> str:
    """Wrap plain-text content in a tcolorbox verbatim block."""
    return (
        "\\begin{tcolorbox}\n"
        "\\begin{verbatim}\n"
        + content.rstrip("\n")
        + "\n\\end{verbatim}\n"
        "\\end{tcolorbox}"
    )


# ── Per-command replacement functions ─────────────────────────────────────────


def try_include_output(text: str, i: int) -> tuple:
    """Try to consume \\includeOutput{label}[type] at position i.

    Returns (replacement, new_i) on success, or (None, i) if not matched.
    """
    cmd = "\\includeOutput{"
    if text[i : i + len(cmd)] != cmd:
        return None, i
    j = i + len(cmd) - 1  # points to '{'
    end_j = find_closing_brace(text, j)
    if end_j == -1:
        return None, i
    label = text[j + 1 : end_j]
    after = end_j + 1
    display_type, after = read_optional_arg(text, after)
    display_type = (display_type or "vbox").strip()

    cached = read_cached(label)
    if cached is None:
        # No cache — keep original command so the error box shows
        return text[i:after], after
    if not cached.strip():
        return "", after  # empty cache → produce nothing

    if display_type == "vbox":
        return wrap_vbox(cached), after
    else:
        return cached, after  # tex / inline: insert raw content


def try_inln(text: str, i: int) -> tuple:
    """Try to consume an \\inln* command at position i.

    Handles \\inlnR, \\inlnPython, \\inlnJulia, \\inlnMatLab.
    Returns (replacement, new_i) on success, or (None, i) if not matched.
    """
    n = len(text)
    for cmd in ("\\inlnR", "\\inlnPython", "\\inlnJulia", "\\inlnMatLab"):
        clen = len(cmd)
        if text[i : i + clen] != cmd:
            continue
        if i + clen >= n or text[i + clen] not in ("{", "["):
            continue

        j = i + clen
        # Optional pre-arg [opt] (first O{} in the xparse signature)
        _, j = read_optional_arg(text, j)
        # Mandatory {code}
        if j >= n or text[j] != "{":
            return None, i
        end_code = find_closing_brace(text, j)
        if end_code == -1:
            return None, i
        after = end_code + 1
        # [label]  [display_type]
        label, after = read_optional_arg(text, after)
        display_type, after = read_optional_arg(text, after)
        display_type = (display_type or "inline").strip()

        if not label:
            # Auto-numbered (no explicit label) — keep original
            return text[i:after], after

        cached = read_cached(label)
        if cached is None:
            return text[i:after], after  # no cache — keep original
        if not cached.strip():
            return "", after  # empty cache → produce nothing

        if display_type.startswith("vbox"):
            return wrap_vbox(cached), after
        else:
            return cached.strip(), after  # inline: bare text
    return None, i  # not an inln* command


# ── File transformer ───────────────────────────────────────────────────────────


def transform_tex(text: str) -> str:
    """Replace all \\includeOutput and \\inln* calls with cached content."""
    result: list[str] = []
    i = 0
    n = len(text)

    while i < n:
        ch = text[i]

        # Respect LaTeX line comments: copy % ... \n verbatim so that
        # commented-out commands like "% \includeOutput{...}" are not replaced.
        if ch == "%" and (i == 0 or text[i - 1] != "\\"):
            eol = text.find("\n", i)
            if eol == -1:
                result.append(text[i:])
                break
            result.append(text[i : eol + 1])
            i = eol + 1
            continue

        if ch != "\\":
            result.append(ch)
            i += 1
            continue

        repl, new_i = try_include_output(text, i)
        if repl is not None:
            result.append(repl)
            i = new_i
            continue

        repl, new_i = try_inln(text, i)
        if repl is not None:
            result.append(repl)
            i = new_i
            continue

        result.append(ch)
        i += 1

    return "".join(result)


def patch_sidsmain(text: str) -> str:
    """Replace the \\IfFileExists{ForceCache}{...}{...} block with
    the cache-only usepackage line so Overleaf always uses cached output."""
    marker = "\\IfFileExists{ForceCache}"
    idx = text.find(marker)
    if idx == -1:
        return text
    # Position just after the marker (after the closing } of {ForceCache})
    j = idx + len(marker)
    # Skip whitespace to reach the first brace group (cache version)
    while j < len(text) and text[j] in " \t\n":
        j += 1
    if j >= len(text) or text[j] != "{":
        return text
    end1 = find_closing_brace(text, j)
    if end1 == -1:
        return text
    cache_content = text[j + 1 : end1].strip()  # e.g. \usepackage[cache,listings]{runcode}
    # Skip whitespace to the second brace group (no-cache version)
    j2 = end1 + 1
    while j2 < len(text) and text[j2] in " \t\n":
        j2 += 1
    if j2 >= len(text) or text[j2] != "{":
        return text
    end2 = find_closing_brace(text, j2)
    if end2 == -1:
        return text
    return text[:idx] + cache_content + text[end2 + 1 :]


# ── Setup ──────────────────────────────────────────────────────────────────────


def setup_tmpoverleaf() -> None:
    """Create tmpoverleaf/ and populate it with all necessary files."""
    if TMPOVERLEAF.exists():
        shutil.rmtree(TMPOVERLEAF)
    TMPOVERLEAF.mkdir()

    # Copy generated/ directory (cache files)
    dest_gen = TMPOVERLEAF / "generated"
    dest_gen.mkdir()
    if GENERATED_DIR.exists():
        for item in GENERATED_DIR.iterdir():
            dest = dest_gen / item.name
            if item.is_dir():
                shutil.copytree(item, dest)
            else:
                shutil.copy2(item, dest)

    # Ensure ForceCache exists so runcode uses cache mode
    (TMPOVERLEAF / "ForceCache").touch()

    # Copy individual files
    for fname in FILES_TO_COPY:
        src = PROJECT_DIR / fname
        if src.exists():
            shutil.copy2(src, TMPOVERLEAF / fname)
        else:
            print(f"  [skip] {fname} not found")

    # Copy directories
    for dname in DIRS_TO_COPY:
        src = PROJECT_DIR / dname
        if src.exists():
            shutil.copytree(src, TMPOVERLEAF / dname)
        else:
            print(f"  [skip] {dname}/ not found")


# ── Transform ──────────────────────────────────────────────────────────────────


def transform_all_tex_files() -> None:
    """Inline cached outputs in sidsmain.tex and all chapter .tex files."""
    # sidsmain.tex: also patch the ForceCache conditional
    sidsmain = TMPOVERLEAF / "sidsmain.tex"
    if sidsmain.exists():
        text = sidsmain.read_text(encoding="utf-8")
        text = patch_sidsmain(text)
        text = transform_tex(text)
        sidsmain.write_text(text, encoding="utf-8")
        print("  sidsmain.tex")

    # Chapter files
    chapters_dir = TMPOVERLEAF / "chapters"
    if chapters_dir.exists():
        for tex_file in sorted(chapters_dir.glob("*.tex")):
            text = tex_file.read_text(encoding="utf-8")
            transformed = transform_tex(text)
            if transformed != text:
                tex_file.write_text(transformed, encoding="utf-8")
                print(f"  chapters/{tex_file.name}")


# ── Compilation ────────────────────────────────────────────────────────────────


def compile_pdf() -> bool:
    """Run xelatex + bibtex + makeindex + xelatex in tmpoverleaf/."""

    def run(*cmd: str, check_pdf: bool = False) -> bool:
        result = subprocess.run(
            list(cmd),
            cwd=TMPOVERLEAF,
            capture_output=True,
            text=True,
        )
        # For xelatex, success means a non-empty PDF was written — the exit
        # code is unreliable (non-zero on warnings like undefined references).
        if check_pdf:
            pdf = TMPOVERLEAF / "sidsmain.pdf"
            if pdf.exists() and pdf.stat().st_size > 0:
                return True
            print(f"  ERROR: {' '.join(cmd)} — no PDF produced")
            log_path = TMPOVERLEAF / "sidsmain.log"
            if log_path.exists():
                lines = log_path.read_text(errors="replace").splitlines()
                print("\n".join(lines[-80:]))
            return False
        if result.returncode != 0:
            print(f"  ERROR: {' '.join(cmd)}")
            return False
        return True

    steps = [
        (("xelatex", "-shell-escape", "-interaction=nonstopmode", "sidsmain.tex"), True),
        (("bibtex", "sidsmain"), False),
        (("makeindex", "sidsmain"), False),
        (("xelatex", "-shell-escape", "-interaction=nonstopmode", "sidsmain.tex"), True),
    ]
    for cmd, check_pdf in steps:
        print(f"  {' '.join(cmd)}")
        if not run(*cmd, check_pdf=check_pdf):
            return False

    pdf = TMPOVERLEAF / "sidsmain.pdf"
    print(f"  OK — {pdf} ({pdf.stat().st_size // 1024} KB)")
    return True


# ── Rsync ──────────────────────────────────────────────────────────────────────


def rsync_to_overleaf(overleaf_path: str, dry_run: bool = False) -> bool:
    dest = os.path.expanduser(overleaf_path).rstrip("/")
    if not os.path.isdir(dest):
        print(f"  ERROR: destination does not exist: {dest}")
        return False

    # Exclude .git and compiled artefacts — Overleaf compiles its own
    exclude = [
        ".git",
        "sidsmain.pdf",
        "*.aux", "*.log", "*.toc", "*.blg", "*.bbl",
        "*.idx", "*.ilg", "*.ind", "*.mw", "*.xdv", "*.tbc",
    ]
    cmd = ["rsync", "-av", "--delete"]
    if dry_run:
        cmd.append("--dry-run")
    for pat in exclude:
        cmd += ["--exclude", pat]
    cmd += [str(TMPOVERLEAF) + "/", dest + "/"]

    label = "(dry run) " if dry_run else ""
    print(f"  rsync {label}→ {dest}/")
    result = subprocess.run(cmd)
    return result.returncode == 0


# ── Main ───────────────────────────────────────────────────────────────────────


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Prepare a self-contained LaTeX copy for Overleaf."
    )
    parser.add_argument(
        "dest", nargs="?", metavar="OVERLEAF_PATH",
        help="Overleaf project directory to rsync to (optional).",
    )
    parser.add_argument(
        "--dry-run", action="store_true",
        help="Pass --dry-run to rsync: show what would be transferred without doing it.",
    )
    args = parser.parse_args()

    print("── Step 1: populate tmpoverleaf/ ─────────────────────────────────────")
    setup_tmpoverleaf()

    print("\n── Step 2: inline cached outputs ─────────────────────────────────────")
    transform_all_tex_files()

    print("\n── Step 3: compile PDF ───────────────────────────────────────────────")
    if not compile_pdf():
        sys.exit("Compilation failed — aborting.")

    if args.dest:
        print("\n── Step 4: rsync to Overleaf ─────────────────────────────────────────")
        if not rsync_to_overleaf(args.dest, dry_run=args.dry_run):
            sys.exit("rsync failed.")
    else:
        if args.dry_run:
            print("\n--dry-run has no effect without an OVERLEAF_PATH.")
        print(
            "\nNo Overleaf path supplied — skipping rsync.\n"
            f"To sync manually:\n"
            f"  rsync -av --delete {TMPOVERLEAF}/ <overleaf_path>/"
        )

    print("\nDone.")


if __name__ == "__main__":
    main()
