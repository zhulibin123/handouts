# Welcome to a SESYNC Training Event

This document explains how to contribute work to your own GitHub repository, while keeping a link to the SESYNC-ci/handouts repo for any updates. So you get the right instructions, choose how you created your own copy of the repository?

- [I *imported* SESYNC-ci/handouts on GitHub.](#github-import)
- [I made a local clone of SESYNC-ci/handouts.](#local-clone)
- [I *forked* SESYNC-ci/handouts on GitHub.](#github-fork)

## GitHub Import

The GitHub "import" feature creates a duplicate of the handouts repository under your username on GitHub. You have full control over this copy, to clone, push, and add collaborators. Once you have created a local clone, for example, you'll be able to push commits up to your GitHub repository with a simple `git push`. To create the local clone, copy the URL from the green "Clone or download" button, open a shell where you want to create a new folder, and enter:

    git clone <URL>

But it would also be good to set up a link to the original SESYNC-ci/handouts repository, so you can pull (i.e. download and merge) any changes or additions from the instructor. With the shell opened to anywhere within your local clone, enter:

    git remote add upstream https://github.com/sesync-ci/handouts.git
   
To merge changes from upstream, you can now enter the following anytime there are new commits to SESYNC-ci/handouts.

    git pull upstream master
   
Subsequently, a `git push` will publish those commits, along with any of your own, to your remote repository on GitHub.

## Local Clone

First, let's make sure you keep the original version of this repository "upstream", so you can pull (i.e. download and merge) any changes made by your instructor. From a shell opened within your local clone, enter:

    git remote rename origin upstream

Next, create a repository on GitHub to use as the new "origin". While logged in to GitHub, use the "+" icon in the upper right to create a new repository. Give it a name but leave the repo empty&mdash;don't even check the box to add a README. Finally, link your remote GitHub repository to your local clone by adding the remote as "origin" using the URL copied from the green "Clone or download" button. From a shell opened within your local clone, enter:

    git remote add origin <URL>
	
After making commits, you can push them to your repo. The first time you do this, you'll need an extra option:

    git push -u origin master
    
The `-u origin` option sets up the origin to sync with the "master" branch of your local clone. Subsequently a simple `git push` will suffice. To merge changes from upstream, you can enter:

    git pull upstream master
   
You are now able to commit and push any changes you make locally to your own repo on GitHub, while also merging any changes your instructor makes upstream.

## GitHub Fork

As the proud owner of a repository forked from SESYNC-ci/handouts on GitHub, you can easilly issue "pull requests" that ask the instructor to update the original SESYNC-ci/handouts repo with your commits. But that's not really something you're likely going to do. On the other hand, you may want to pull commits made by the instructor to your own repository, in case there are updates to a worksheet or data. You have two options:

1. Follow the [steps above](#github-import) as if you had imported (rather than forked) the original repo.
2. Issue and then merge a '[pull request](https://help.github.com/articles/about-pull-requests/)' directly from GitHub with the 'base fork' set to your fork and the 'head fork' set to SESYNC-ci/handouts (i.e. the reverse of the default settings for a new pull request).
