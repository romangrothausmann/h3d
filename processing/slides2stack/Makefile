#### Notes:
## use CZItoTIFFBatchConverter.exe to convert CZI to TIFF @ 1x and 8x
## load 8x TIFFs into fiji
## mark slice centers with "multi-point" tool
## export with export_multipointset.ijm from: http://imagejdocu.tudor.lu/doku.php?id=macro:multiple_points
### bfconvert can only load/save images up to 2GB, this is a Java limit:
### http://www.openmicroscopy.org/site/support/faq/bio-formats/i-see-an-outofmemory-or-negativearraysize-error-message-when-attempting-to-open-an-svs-or-jpeg-2000-file.-what-does-this-mean
### http://en.wikipedia.org/wiki/Criticism_of_Java#Large_arrays
## number of slices per slide hard-coded (see seq) therfore avoiding parallel
## bfconvert supports JPG, TIF, PNG ..., JPG lossy, TIF stores RGBA, PNG RGB => chose PNG


#### ToDo:
## create final stack (containing registered slices)

#### Done:
## create raw stack (containing unregistered slices)



SHELL:= /bin/bash
GVmake=$(MAKE) #any line with $(MAKE) gets exectued even with -n, GVmake should merely be used for makefile-visualization to avoid its execution with -n

SPACE := $(eval) $(eval)
base_ = $(subst $(SPACE),_,$(filter-out $(lastword $(subst _, ,$1)),$(subst _, ,$1)))
base. = $(subst $(SPACE),.,$(filter-out $(lastword $(subst ., ,$1)),$(subst ., ,$1)))


SUBMODDIR?=../../submodules/

### setting default paths of internal programs
ITK?=$(SUBMODDIR)/ITK-CLIs/

### setting default paths of external programs
BF?=/opt/bio-format_CLIs/



export PATH:= $(ITK)/build:$(PATH)
export PATH:= $(BF):$(PATH)


EXECUTABLES = file-series_reader_SDI tile
EXECUTABLES+= bfconvert


K:= $(foreach exec,$(EXECUTABLES),\
	$(if $(shell PATH=$(PATH) which $(exec)),some string,$(error "No $(exec) in PATH")))


BASENAME = h3d


w=2000
h=2000
s=8

MR3006g_OT1slices= $(shell seq -f %03.0f 1 140)
MR3006g_OT2slices= $(shell seq -f %03.0f 1 203)
MR3006g_OT3slices= $(shell seq -f %03.0f 1 201)
MR3006g_OT1slices:= $(MR3006g_OT1slices:%=MR3006g_OT1_s%.png)
MR3006g_OT2slices:= $(MR3006g_OT2slices:%=MR3006g_OT2_s%.png)
MR3006g_OT3slices:= $(MR3006g_OT3slices:%=MR3006g_OT3_s%.png)

## 256g / 24 ~ 10g
BFmem=10g


.PHONY : all clean


all : $(BASENAME)_raw.mha


clean :
	@-rm -v MR3006g_OT*
	@-rm -v $(BASENAME)_raw.mha


% :: %.gz
	unpigz -v -- $<

%.gz : %
	pigz -v -- $< 



%.tif : ../../base/%.tif # converted with CZItoTIFFBatchConverter.exe as long as JPEG XR (in CZIs) is not supported: https://github.com/openmicroscopy/bioformats/pull/1014
	ln -sf $< $@

%.txt : ../../manual/processing/%.txt # marked slice centers on 8-bin TIFFs exported with export_multipointset.ijm
	ln -sf $< $@

$(BASENAME)_raw.mha : MR3006g_OT1.nii MR3006g_OT2.nii MR3006g_OT3.nii # output MHA here, which is more easily loaded correctly in fiji
	touch $@.stime
	tile $< $@ 0 1 1 $(words $^) $^ # $< is only for header specs!


.SECONDARY: # prevent removal of any intermediate files


.SECONDEXPANSION:

%.png : $$(call base_,%).txt $$(call base_,%).tif
	@echo "process $+ to $*"
	touch $@.stime
	$(eval pos= $(subst $(basename $<),,$*))
	$(eval pos= $(subst _s,,$(pos)))
	$(eval crop= $(shell awk 'NR==$(pos){printf("%d,%d,$(w),$(h)",$$1*$(s)-($(w)/2),$$2*$(s)-($(h)/2))}' $<))
	BF_MAX_MEM=$(BFmem) bfconvert -no-upgrade -overwrite -crop $(crop) $(lastword $^) $@

%.nii : $$($$*slices) # NIIs differenciate properly between RGB and generic vector, MHAs not: http://www.itk.org/pipermail/insight-developers/2009-March/011990.html
	touch $@.stime
	$(eval NS=$(words $($*slices)))
	file-series_reader_SDI $*_s%03d.png $@ 1 $(NS) $(NS) # sadly does not accept a list as $$($$*slices)

