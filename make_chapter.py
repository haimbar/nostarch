#!/usr/bin/env python3
"""Prepare a temporary document and cache metadata for one book chapter."""

import hashlib
import re
import sys
from pathlib import Path


CHAPTERS = {
    1: "Rintro",
    2: "EDA",
    3: "probability",
    4: "llnclt",
    5: "hypothesis",
    6: "estimation",
    7: "datacollect",
    8: "regcorr",
    9: "nyccrashes",
    10: "ai",
}


def chapter_dependencies(number: int) -> list[Path]:
    chapter = Path("chapters") / f"{CHAPTERS[number]}.tex"
    dependencies = [chapter]
    text = chapter.read_text(encoding="utf-8")
    sources = sorted(
        source for source in set(re.findall(r"Code/[^{}]+\.R", text))
        if Path(source).exists()
    )
    dependencies.extend(Path(source) for source in sources)

    for source in sources:
        source_text = Path(source).read_text(encoding="utf-8")
        data_files = sorted(
            data_file
            for data_file in set(re.findall(r"Data/[A-Za-z0-9_./-]+", source_text))
            if Path(data_file).exists()
        )
        dependencies.extend(Path(data_file) for data_file in data_files)
    return dependencies


def dependency_hash(number: int) -> str:
    digest = hashlib.sha256()
    for path in chapter_dependencies(number):
        digest.update(str(path).encode())
        digest.update(path.read_bytes())
    return digest.hexdigest()


def cache_paths(number: int) -> tuple[Path, Path, Path]:
    cache_dir = Path("generated") / f"chapter_{number}"
    return cache_dir, cache_dir / "dependencies.sha256", cache_dir / "session.RData"


def cache_valid(number: int) -> bool:
    _, manifest, session = cache_paths(number)
    return session.exists() and manifest.exists() and manifest.read_text().strip() == dependency_hash(number)


def main() -> None:
    if len(sys.argv) < 2:
        raise SystemExit("usage: make_chapter.py [--prepare|--record|--cache-valid] CHAPTER")

    action = "prepare"
    arguments = sys.argv[1:]
    if arguments[0].startswith("--"):
        action = arguments.pop(0)[2:]
    arguments = [argument for argument in arguments if argument != "--force"]
    if len(arguments) != 1:
        raise SystemExit("usage: make_chapter.py [--prepare|--record|--cache-valid] CHAPTER")
    argument = arguments[0]
    if not argument.isdigit():
        raise SystemExit("CHAPTER must be a number from 1 to 10")

    number = int(argument)
    if number not in CHAPTERS:
        raise SystemExit(f"unknown chapter: {number}")

    cache_dir, manifest, session = cache_paths(number)
    if action == "cache-valid":
        raise SystemExit(0 if cache_valid(number) else 1)
    if action == "record":
        cache_dir.mkdir(parents=True, exist_ok=True)
        manifest.write_text(dependency_hash(number) + "\n", encoding="utf-8")
        return
    if action != "prepare":
        raise SystemExit(f"unknown action: {action}")

    source = Path("sidsmain.tex").read_text(encoding="utf-8")
    preamble, _ = source.split(r"\begin{document}", 1)
    force = "--force" in sys.argv or not cache_valid(number)
    if force:
        # A changed dependency requires re-executing the chapter in a fresh
        # session; otherwise the saved session supplies its chapter objects.
        preamble = r"\PassOptionsToPackage{run}{runcode}" + "\n" + preamble
    body = """\\begin{document}
\\mainmatter
\\setcounter{chapter}{%d}
\\input{chapters/%s}
\\end{document}
""" % (number - 1, CHAPTERS[number])

    output = Path("tmp") / f"chapter_{number}.tex"
    output.parent.mkdir(exist_ok=True)
    output.write_text(preamble + body, encoding="utf-8")
    restore_marker = Path("tmp") / f"chapter_{number}.restore"
    if cache_valid(number) and not force:
        restore_marker.touch()
    elif restore_marker.exists():
        restore_marker.unlink()


if __name__ == "__main__":
    main()
