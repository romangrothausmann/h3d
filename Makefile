

SHELL:= /bin/bash
GVmake=$(MAKE) #any line with $(MAKE) gets exectued even with -n, GVmake should merely be used for makefile-visualization to avoid its execution with -n

SPACE := $(eval) $(eval)
base_ = $(subst $(SPACE),_,$(filter-out $(lastword $(subst _, ,$1)),$(subst _, ,$1)))
base. = $(subst $(SPACE),.,$(filter-out $(lastword $(subst ., ,$1)),$(subst ., ,$1)))



SUBDIRS:= processing/ana/ processing/low_upp-bounds/ manual/slices/ manual/VR/ manual/SRV/ manual/VE/


.PHONY: all clean $(SUBDIRS)


all : $(SUBDIRS) # video

clean :
	$(MAKE) -C $(SUBDIRS) clean

# mJOBS = $(shell echo $(MAKEFLAGS) | grep -o j.*) # only works with = empty with :=
# ifeq ($(mJOBS),) # always true: executed before = is evaluated ???

# processing/% :
# 	echo $(MAKEFLAGS)
# 	echo $(mJOBS)
# 	$(MAKE) -C $(dir $@) $(notdir $@)

# else

# processing/%.done : # causes rule to execute as many times as there are *.done !!!
# %.done : | processing/ # as processing/ already exists this will never execute a recipe
#	touch $@
%slices.done %ana.done %luBounds.done %VR.done %SRV.done %VE.done : # this way rule will only be executed once for all listed *.done
	/usr/bin/time -v -o processing/timing \
	   $(MAKE) -C processing/ all # uses its own .SERIAL

# endif


manual/slices/ : processing/slices.done

processing/ana/ : processing/ana.done

processing/low_upp-bounds/ : processing/luBounds.done

manual/VR/ : processing/VR.done

manual/SRV/ : processing/SRV.done

manual/VE/ : processing/VE.done

.PHONY: video
video : processing/ana/ processing/low_upp-bounds/ manual/slices/ manual/VR/ manual/SRV/ manual/VE/ # deps just to ensure video is executed afterwards
	/usr/bin/time -v -o $@timing \
	   $(MAKE) -C manual/VE/  video


$(SUBDIRS) :
	/usr/bin/time -v -o $@timing \
	   $(MAKE) -C $@


.SERIAL : manual/VE/ # multiple blender runs
.SERIAL : processing/low_upp-bounds/ # label_uncertainty_float



## below a rule with "make", a very special case for NOT using $(MAKE) or +make
### lines that contain "$(MAKE)" even in a comment get exectued even with -n|--dry-run !!!
%.gv : % Makefile $(MAKEFILES) # put % to get executed after target has been made to avoid make2graph error due to missing files; http://www.gnu.org/software/make/manual/make.html#MAKEFILES-Variable
	$(GVmake) -Bnd $* | ~/programme/makefile2graph/make2graph | sed 's/label=".*_\([^_\.]\+\)\.[^\.]*"/label="\1"/g' > $@ # DO NOT PUT a comment with make-var here

#prevent removal of any intermediate files http://stackoverflow.com/questions/5426934/why-this-makefile-removes-my-goal https://www.gnu.org/software/make/manual/html_node/Chained-Rules.html
#.SECONDARY: # $(SRV_G)_[xyz]@[0-9]*.png #not working
.PRECIOUS:  %.gv



.SECONDEXPANSION: # https://www.gnu.org/software/make/manual/html_node/Secondary-Expansion.html

%.svg : $$(call base.,%).gv # %.svg : $(suffix $*).gv does not work, needs SECONDEXPANSION
	$(eval pos= $(subst $(basename $+),,$*))
	$(eval pos= $(subst .,,$(pos)))

	$(pos) -Tsvg -o $@ $<
