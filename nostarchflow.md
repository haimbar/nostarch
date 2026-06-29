## Data Science book development flow

The reasons we keep two repositories are:
1. NoStarch would not want to make the repo public after the book comes out.
2. OverLeaf doesn't support our LaTeX runcode package which is essential for reproducibility.
3. We want the repo not only to be public, but also to be updated regularly with exercises and projects.

According to their documentation and the discussions we've had, the way NoStarch want to work during the editing phase is that we only put chapters on OverLeaf when they are ready for their editing. They don't want to have initial drafts. So, because of that it is convenient for us to work on our own repo (which will end up being public), and pass files to their repo when a chapter is ready for their review. The challenge is to keep the two repos synchronised.
The workflow below describes how we can do it. It is written under the assumption that while a chapter is in rough draft mode, we have it only on our repo. Once it's copied to the OverLeaf repo, we move on to another chapter, while NoStarch make their changes and suggestions to the current chapter. When they are done, we pull their version (to our local OverLeaf repo) and synchronize it with our own repo.

Comment: the reasons we do not use symbolic links are:
1. OverLeaf does not seem to work well with symlinks.
2. Several files are created on-the-fly, and it becomes cumbersome to manage a large number of links.

Instead, we're using rsync, as described below. In the description below '**nostarch**' is our repo (https://github.com/haimbar/nostarch) and '**OverLeaf**' is their repo (https://www.overleaf.com/project/62d8236139638c60adaa065c).

#### Phase 1: working on a draft of a chapter

During this phase we only work on the nostarch repo. To compile the book and run all the R scripts which are used to produce the output, we run
```make build```

If anything in the pdf suggest that the LaTeX compilation had trouble we can run
```make clean```
As the name suggests, it cleans temporary files created by runcode.  (We could also consider removing the files created by xelatex such as *.aux, *.bbl, *.idx, *. Log, *.mw, *.tbc, *.toc).

There is an option to stop the runcode server, in case we see that code is not produced in the right places or there are execution errors in the output. This option also does the make clean option.
```make stopserver```

#### Phase 2: passing the chapter to NoStarch for editing

When we are done with our draft, we first rebuild everything from scratch so the cache is up to date:
```
make stopserver
make build
```

Then we use `make_overleaf.py` to prepare a self-contained copy for OverLeaf. This script:
1. Creates a `tmpoverleaf/` folder (git-ignored) with all necessary files.
2. **Inlines** every `\inlnR` and `\includeOutput` call by replacing it with the cached output from `generated/`. This avoids the zero-bytes-in-output bug that occurs on OverLeaf when the talk2stat server is not running.
3. Compiles the PDF locally to verify it works.
4. Rsyncs `tmpoverleaf/` to the local OverLeaf repo (excluding `.git` and compiled artefacts).

To do a dry run first (see what would be transferred without writing anything):
```
python3 make_overleaf.py --dry-run ~/Documents/GitHub/62d8236139638c60adaa065c/
```

If the dry run looks good, run without `--dry-run`:
```
python3 make_overleaf.py ~/Documents/GitHub/62d8236139638c60adaa065c/
```

Equivalently via make:
```
make overleaf DEST=~/Documents/GitHub/62d8236139638c60adaa065c/
```

Finally, push the changes to OverLeaf's git remote. OverLeaf requires a personal git authentication token (not your password). Generate one at https://www.overleaf.com/user/settings under **Git Integration**, then configure the remote once:
```
cd ~/Documents/GitHub/62d8236139638c60adaa065c
git remote set-url origin https://git:<YOUR_TOKEN>@git.overleaf.com/62d8236139638c60adaa065c
```

Then commit and push:
```
git add -A
git commit -m "sync from local project"
git push origin master
```

Note: OverLeaf only accepts the `master` branch and does not allow force pushes. If the push is rejected because the remote is ahead, pull first:
```
git pull --no-rebase --allow-unrelated-histories -X ours origin master
git push origin master
```

#### Phase 3: updating our repo with NoStarch edits

When the NoStarch editors finish making their changes, they will push the latest version to the OverLeaf repo, so now this repo is ahead of our nostarch repo (but only for chapters which went through the second phase.) To synchronize our repo, we first check which files changed. We do it with the following from the parent directory of both local repos (for example, cd /Users/haim/Documents/GitHub):
```
rsync -crv --dry-run --exclude={'uconn-pcs','.git','tmp','proposal','styfiles','.DS_Store','fonts','.gitignore','ForceCache','Makefile*','R.config','Rdebug.txt','nohup.out','ToDo.md','talk2stat.log','serverPIDR.txt'} OverLeaf/ nostarch/
```
This will only show us a list of the files that were changed by the editors. If we're satisfied that there are no problems, we can run it without the 'dry-run' option.

Note that the c option is used to identify changed files based on checksum (rather than mod-time and size), the r option is used to perform the sync recursively, and the v option is for 'verbose'.

Then, we can git add/commit/push to our nostarch repo and now the chapters which have been reviewed by NoStarch are synchronized. The chapters that are still in draft mode are still only on our own repo (until we perform Phase 2).

#### Phase 4: updating the NoStarch repo with our edits

After incorporating NoStarch's comments and making further changes, pushing back to OverLeaf is the same as Phase 2:
```
make stopserver
make build
python3 make_overleaf.py ~/Documents/GitHub/62d8236139638c60adaa065c/
cd ~/Documents/GitHub/62d8236139638c60adaa065c
git add -A
git commit -m "sync from local project"
git push origin master
```

