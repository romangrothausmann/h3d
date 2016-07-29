
### proxy for wget to get raw-files
export HTTPSproxy?=""


### setting default paths of external libraries
ITKLIB?=/opt/itk-4.9.1/lib/cmake/ITK-4.9
VTKLIB?=/opt/vtk-7.0.0/lib/cmake/vtk-7.0

### setting default paths of external programs
BLENDER?=/opt/blender-2.76b
PV?=/opt/paraview-4.4.0
## 64-bit enabled octave:
OCTAVE?=/opt/octave-4.0.0
BF?=/opt/bio-format_CLIs/
MAKE2GV?=/opt/makefile2graph

## vglrun < 2.4 might need +xcb parameter
export VGLRUN?=vglrun

## path to submodules
export SUBDIR = $(realpath submodules)

### setting default paths of internal programs for PATH
ITK?=$(SUBDIR)/ITK-CLIs/
VTK?=$(SUBDIR)/VTK-CLIs/
ITKVTK?=$(SUBDIR)/ITKVTK-CLIs/


SHELL:= /bin/bash
GVmake=$(MAKE) #any line with $(MAKE) gets exectued even with -n, GVmake should merely be used for makefile-visualization to avoid its execution with -n


export PATH:= $(ITK)/build:$(PATH)
export PATH:= $(VTK)/build:$(PATH)
export PATH:= $(ITKVTK)/build:$(PATH)
export PATH:= $(BLENDER):$(PATH)
export PATH:= $(PV)/bin:$(PATH)
export PATH:= $(OCTAVE)/bin:$(PATH)
export PATH:= $(BF):$(PATH)
export PATH:= $(MAKE2GV)/bin:$(PATH)


### check existance of external programs
## http://stackoverflow.com/questions/5618615/check-if-a-program-exists-from-a-makefile#25668869
ITKEXE = add add_const analyse_labels distance_map_signed_maurer_f32 erode-dilate_dm_f32 subimage_extract fast-marching_f32 file_converter keepNobj label_connected_components label_uncertainty_float mask mask-negated max mean min-path_seg_f32 open_bin_para open_label-shape open_parabolic_f32 paste_image resample slice thresh-glob toUInt16 toUInt8 watershed_morph file-series_reader_SDI tile subimage_mask std-mean_ROI_SBS median resample-iso bin change_header
VTKEXE = analyse_S+V decimate-QC discrete_marching-cubes hull largest_mesh-part probe-surf2vrml ribbon_FrenetSerret threshold vtk2vtp vtp2pvtp
ITKVTKEXE = straighten
EXECUTABLES+= blender
EXECUTABLES+= pvpython
EXECUTABLES+= octave
EXECUTABLES+= gnuplot
EXECUTABLES+= bfconvert
EXECUTABLES+= make2graph
EXECUTABLES+= $(VGLRUN)

K:= $(foreach exec,$(EXECUTABLES),\
	$(if $(shell PATH=$(PATH) which $(exec)),some string,$(error "No $(exec) in PATH")))



SPACE := $(eval) $(eval)
base_ = $(subst $(SPACE),_,$(filter-out $(lastword $(subst _, ,$1)),$(subst _, ,$1)))
base. = $(subst $(SPACE),.,$(filter-out $(lastword $(subst ., ,$1)),$(subst ., ,$1)))



SUBDIRS:= processing/slides2stack/ processing/ana/ processing/low_upp-bounds/ manual/slices/ manual/VR/ manual/SRV/ manual/VE/


.PHONY: all clean $(SUBDIRS) base/


all : intTools.done
all : $(SUBDIRS) article/latex/images/ article/latex/tables/ stime.lst # video

clean :
	$(MAKE) -C $(SUBDIRS) clean


## build internal tools
## only build those listed above e.g. ITKEXE
## run with unlimited -j because all involved programms are single threaded, needs spedific rules (intTools.mk) because multiple goals are processed serially ("in turn") even with -j: https://savannah.gnu.org/support/?107274
.PHONY: intTools # make sure intTools is always executed (even if intTools.done already exists)
intTools :
	git submodule update --init --recursive # http://stackoverflow.com/questions/3796927/how-to-git-clone-including-submodules#4438292
	$(MAKE) \
		ITKLIB=$(ITKLIB) ITKEXE='$(ITKEXE)' \
		VTKLIB=$(VTKLIB) VTKEXE='$(VTKEXE)' \
		ITKVTKEXE='$(ITKVTKEXE)' \
		-j24 -f intTools.mk # unlimited -j overridden by -j6 from build.sh?
	INTTOOLS="$(ITKEXE) $(VTKEXE) $(ITKVTKEXE)"; \
		PATH=$(PATH); \
		for i in $$INTTOOLS; do if test -z `which $$i`; then echo "Error, No $$i in PATH!" 1>&2; exit 125; fi; done

intTools.done : intTools
	touch intTools.done


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
%slices.done %ana.done %luBounds.done %VR.done %SRV.done %VE.done : %slides2stack/slides.done # this way rule will only be executed once for all listed *.done
	/usr/bin/time -v -o processing/timing \
	   $(MAKE) -C processing/ all # uses its own .SERIAL
	touch processing/compressing.stime
	find processing/ -size +10G -name "*.mha"  | xargs pigz -v -f # just to save disc space, subsequent make-calls will unpack needed files (pigz used because of 4GB bug in ITK/VTK's MetaIO: https://issues.itk.org/jira/browse/ITK-3321)
	touch processing/compressing

# endif


processing/slides2stack/ : base/

manual/slices/ : processing/slices.done

processing/ana/ : processing/ana.done

processing/low_upp-bounds/ : processing/luBounds.done

manual/VR/ : processing/VR.done

manual/SRV/ : processing/SRV.done

manual/VE/ : processing/VE.done

article/latex/images/ article/latex/tables/ : $(SUBDIRS) # do article stuff after SUBDIRS


.PHONY: video
video : processing/ana/ processing/low_upp-bounds/ manual/slices/ manual/VR/ manual/SRV/ manual/VE/ # deps just to ensure video is executed afterwards
	/usr/bin/time -v -o $@timing \
	   $(MAKE) -C manual/VE/  video


$(SUBDIRS) : intTools.done
$(SUBDIRS) article/latex/images/ article/latex/tables/ base/ :
	/usr/bin/time -v -o $@timing \
	   $(MAKE) -C $@


stime.lst : | $(SUBDIRS)
	for i in `find -name '*.stime'`; do \
	    printf "%s\t%s\t%s\n" \
		`ls -lgG --time-style='+%s %N' $$i | awk '{printf ("%d", ($$4 + $$5/1e9)*1e3)}'` \
		` ( ls -lgG --time-style='+%s %N' $${i%.stime} || ls -lgG --time-style='+%s %N' $${i%.stime}.gz ) | awk '{printf ("%d", ($$4 + $$5/1e9)*1e3)}'` \
		$${i%.stime} ; \
	done > $@


all.%.Make.mp4 : stime.lst all.gv
	ln -sf $(addprefix ../../,$^) $(SUBDIR)/aniMakefileSVG/
	$(MAKE) -C $(SUBDIR)/aniMakefileSVG/  $@
	mv $(SUBDIR)/aniMakefileSVG/$@ .


.SERIAL : manual/VE/ # multiple blender runs
.SERIAL : processing/low_upp-bounds/ # label_uncertainty_float



## below a rule with "make", a very special case for NOT using $(MAKE) or +make
### lines that contain "$(MAKE)" even in a comment get exectued even with -n|--dry-run !!!
%.gv : % Makefile $(MAKEFILES) # put % to get executed after target has been made to avoid make2graph error due to missing files; http://www.gnu.org/software/make/manual/make.html#MAKEFILES-Variable
	$(GVmake) -Bnd $* | make2graph > $@ # DO NOT PUT a comment with make-var here

#prevent removal of any intermediate files http://stackoverflow.com/questions/5426934/why-this-makefile-removes-my-goal https://www.gnu.org/software/make/manual/html_node/Chained-Rules.html
#.SECONDARY: # $(SRV_G)_[xyz]@[0-9]*.png #not working
.PRECIOUS:  %.gv



.SECONDEXPANSION: # https://www.gnu.org/software/make/manual/html_node/Secondary-Expansion.html

%.svg : $$(call base.,%).gv # %.svg : $(suffix $*).gv does not work, needs SECONDEXPANSION
	$(eval pos= $(subst $(basename $+),,$*))
	$(eval pos= $(subst .,,$(pos)))

	$(pos) -Tsvg -o $@ $<
