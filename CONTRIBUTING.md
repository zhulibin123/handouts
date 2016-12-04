# Welcome to a SESYNC Training Event

Once you have cloned this repository, why not create your own GitHub repo to share your work?

First, let's make sure you keep the original version of this repository "upstream", so you can pull down any changes made by your instructor. From a shell opened within your local clone, enter:

    git remote rename origin upstream

Next, create a repository on GitHub to use as the new "origin". While logged in to GitHub, use the "+" icon in the upper right to create a repository. Give it a name but leave the repo empty -- don't even check the box to add a README.

Finally, link your remote GitHub repository to your local clone by adding the remote as "origin" using the URL copied from the green "Clone or download" button. From a shell opened within your local clone, enter:

    git remote add origin <URL>
    git branch -u origin/master
	
After making commits, you can push them to your repo. The first time you do this, you'll need an extra argument:

    git push -u origin master
    
Subsequently a simple `git push` will work. To merge changes from upstream, you can enter:

    git pull upstream master
   
You are now able to commit and push any changes you make locally to your own repo on GitHub, while also merging any changes your instructor makes upstream.
