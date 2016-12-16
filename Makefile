# assumption, lesson numbers are correct
# assumption, the generic worksheet name is 'worksheet'
# assumption, public key authentiation on github
# assumption, git is not tracking build/

GH := git@github.com:sesync-ci/
LESSONS := \
    basic-netlogo-lesson \
    netlogo-programming-lesson \
    basic-git-lesson \
    rnetlogo-lesson \
    gis-abm-lesson

.PHONY: all $(LESSONS)

all: $(LESSONS) # could give a recipe to commit and push, if bold
	rsync -au --delete build/data/ data/

$(LESSONS): %: | build/%
	git checkout master
	$(MAKE) -C $| course

build/%: | build
	git clone $(GH)$(@:build/%=%).git $@
	git -C $@ remote add upstream $(GH)lesson-style.git
	git -C $@ fetch upstream
	git -C $@ branch --track upstream upstream/master

build:
	mkdir -p build/data

# could have lessons put data into build/data, then let rsync take care of syncing to delete non-needed data
# no solution for worksheets though
# maybe that should be a `make clean` rule
