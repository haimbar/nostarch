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

When we are done with our draft, we have to build the pdf file from cache, so that when it is compiled by OverLeaf it will not need the runcode package.
Before we copy new chapters to OverLeaf, we have to run:
```
make stopserver
make build
make overleaf
```

That way, the copy they will get will be the latest (because we build from scratch) but will allow them to compile it without the talk2stat server (because make overleaf forces the compilation to run in the cache mode).

In principle, we will not have to change the main tex file unless we add a chapter. If all we did was to add a chapter, then we can copy the chapter's files to the OverLeaf repo, and then git add/commit/push the changes. At this point, the two repos should be synchronized.

#### Phase 3: updating our repo with NoStarch edits

When the NoStarch editors finish making their changes, they will push the latest version to the OverLeaf repo, so now this repo is ahead of our nostarch repo (but only for chapters which went through the second phase.) To synchronize our repo, we first check which files changed. We do it with the following from the parent directory of both local repos (for example, cd /Users/haim/Documents/GitHub):
```
rsync -crv --dry-run --exclude={'uconn-pcs','.git','tmp','proposal','styfiles','.DS_Store','fonts','.gitignore','ForceCache','Makefile*','R.config','Rdebug.txt','nohup.out','ToDo.md','talk2stat.log','serverPIDR.txt'} OverLeaf/ nostarch/
```
This will only show us a list of the files that were changed by the editors. If we're satisfied that there are no problems, we can run it without the 'dry-run' option.

Note that the c option is used to identify changed files based on checksum (rather than mod-time and size), the r option is used to perform the sync recursively, and the v option is for 'verbose'.

Then, we can git add/commit/push to our nostarch repo and now the chapters which have been reviewed by NoStarch are synchronized. The chapters that are still in draft mode are still only on our own repo (until we perform Phase 2).

#### Phase 4: updating the NoStarch repo with our edits

After we get the edits and comments from NoStarch and update our repor, we will still be able to make changes. This is essentially like phase 2, except for one thing: the files we've edited are not new to the OverLeaf repo. Identifying the changes manually is cumbersome, and using symlinks has issues (mentioned above), so we use rsync, but reverse the source and the destination. The dry-run version looks like this:
```
rsync -crv --dry-run --exclude={'uconn-pcs','.git','tmp','proposal','styfiles','.DS_Store','fonts','.gitignore','ForceCache','Makefile*','R.config','Rdebug.txt','nohup.out','ToDo.md','talk2stat.log','serverPIDR.txt'} nostarch/ OverLeaf/
```
Then, we can git add/commit/push the OverLeaf repo, and again the completed chapters are synchronized.

