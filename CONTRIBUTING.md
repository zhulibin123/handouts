# Welcome to a SESYNC Training Event

This document explains how to contribute work to your own GitHub repository, while keeping a link to the SESYNC-ci/handouts repo for any updates. So you get the right instructions, choose how you created your own copy of the repository?

- [I *forked* SESYNC-ci/handouts on GitHub.](#github-fork)
- [I made a local clone of SESYNC-ci/handouts.](#local-clone)
- [I *imported* SESYNC-ci/handouts on GitHub.](#github-import)

## GitHub Fork

By forking from SESYNC-ci/handouts on GitHub, you have effectively become the owner of a mirror of the handouts repository. You have full control over this copy, to clone, push, and add collaborators. Once you have created a local clone, for example, you'll be able to push commits up to your repository with a simple `git push`.

Your fork remains linked to the original repository, which you can use to update your repository with changes made by the instructor on SESYNC-ci/handouts if necessaryy. Issue a '[pull request](https://help.github.com/articles/about-pull-requests/)' directly from GitHub with the 'base fork' set to your fork and the 'head fork' set to SESYNC-ci/handouts (i.e. the reverse of the default settings for a new pull request). Then merge your pull request.

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

## GitHub Import

Since we began using [git-lfs] on sesync-ci/handouts, you probably won't be able to use the GitHub importer to duplicate the repository.
