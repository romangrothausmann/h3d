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
## generate Fig.1

#### Done:
## create raw stack (containing unregistered slices)
## create aligned stack (containing registered slices)
## rep, smROISBS, md, rsi, mask aligned stack



SHELL:= /bin/bash
GVmake=$(MAKE) #any line with $(MAKE) gets exectued even with -n, GVmake should merely be used for makefile-visualization to avoid its execution with -n

SPACE := $(eval) $(eval)
base_ = $(subst $(SPACE),_,$(filter-out $(lastword $(subst _, ,$1)),$(subst _, ,$1)))
base. = $(subst $(SPACE),.,$(filter-out $(lastword $(subst ., ,$1)),$(subst ., ,$1)))


SUBMODDIR?=../../submodules/

### setting default paths of internal programs
ITK?=$(SUBMODDIR)/ITK-CLIs/
VTK?=$(SUBMODDIR)/VTK-CLIs/

### setting default paths of external programs
BF?=/opt/bio-format_CLIs/
IJ?=/opt/fiji/Fiji.app/



export PATH:= $(ITK)/build:$(PATH)
export PATH:= $(VTK)/build:$(PATH)
export PATH:= $(BF):$(PATH)
export PATH:= $(IJ):$(PATH)


EXECUTABLES = file-series_reader_SDI tile subimage_extract paste_image std-mean_ROI_SBS median resample-iso hull mask-negated mask bin slice
EXECUTABLES+= hull
EXECUTABLES+= bfconvert
EXECUTABLES+= ImageJ-linux64
EXECUTABLES+= gnuplot
EXECUTABLES+= parallel


K:= $(foreach exec,$(EXECUTABLES),\
	$(if $(shell PATH=$(PATH) which $(exec)),some string,$(error "No $(exec) in PATH")))


## run IM tools without setting cration and modification date (or -strip) to avoid changes in PNGs that are not visual: http://stackoverflow.com/questions/13577280/getting-imagemagick-convert-to-not-write-out-extra-info
## some bug now needs even more default options: http://unix.stackexchange.com/questions/255252/create-the-same-png-with-imagemagick-2-times-binaries-differ#255256
convertIM:= convert -define png:exclude-chunks=date,time +set date:create +set date:modify
mogrifyIM:= mogrify -define png:exclude-chunks=date,time +set date:create +set date:modify

BASENAME = h3d


w=12000
h=12000
s=8

MR3006g_OT1slices= $(shell seq -f %03.0f 1 140)
MR3006g_OT2slices= $(shell seq -f %03.0f 1 203)
# MR3006g_OT3slices= $(shell seq -f %03.0f 1 201) # ignore OT3 as it was not used due to folds
MR3006g_OT1slices:= $(MR3006g_OT1slices:%=MR3006g_OT1_s%.png)
MR3006g_OT2slices:= $(MR3006g_OT2slices:%=MR3006g_OT2_s%.png)
MR3006g_OT3slices:= $(MR3006g_OT3slices:%=MR3006g_OT3_s%.png)

XMLS= $(shell seq -f %03.0f 1 343)
XMLS:= $(XMLS:%=XMLs/f%.xml)

REPIMGs= 048 100 101 230 231 260 261
REPIMGs:= $(REPIMGs:%=../../manual/correction/rIMG_s%.mha)

## 256g / 24 ~ 10g
BFmem=10g


.PHONY : all clean


all : $(BASENAME).mha
all : MR3006g_OT2_b+64.svg MR3006g_OT2_s088_RGB_b+10.png MR3006g_OT2_s088_tra_b+10.png $(BASENAME)_OT2_s088_b+03.png # fig_slideOV


clean :
	@-rm -v MR3006g_OT*
	@-rm -v $(BASENAME).mha*
	@-rm -vr {src,tra,XMLs}


% :: %.gz
	unpigz -v -- $<

%.gz : %
	pigz -v -- $< 



%.tif : ../../base/%.tif # converted with CZItoTIFFBatchConverter.exe as long as JPEG XR (in CZIs) is not supported: https://github.com/openmicroscopy/bioformats/pull/1014
	ln -sf $< $@

%.txt : ../../manual/processing/%.txt # marked slice centers on 8-bin TIFFs exported with export_multipointset.ijm
	ln -sf $< $@

XMLs/%.xml : ../../manual/processing/XMLs/%.xml | XMLs/ # bound to 12000x12000 as src!
	ln -sf ../$< $@

src/ XMLs/ :
	mkdir -p $@

%.png : %_RGB.png
	 $(convertIM) $< -set colorspace Gray -separate -average $@ # should match default Fiji conversion: https://imagej.nih.gov/ij/docs/menus/image.html#type

$(addprefix src/,$(MR3006g_OT1slices) $(MR3006g_OT2slices) $(MR3006g_OT3slices)) : src/% : % | src/
	ln -s ../$< $@

$(subst .png,%tif,$(addprefix tra/,$(MR3006g_OT1slices) $(MR3006g_OT2slices) $(MR3006g_OT3slices))) : $(addprefix src/,$(MR3006g_OT1slices) $(MR3006g_OT2slices) $(MR3006g_OT3slices)) $(XMLS) # instead of reg/%.tif %src to force single execution
	mkdir -p tra/
	ImageJ-linux64 --memory=250g --allow-multiple --headless $(SUBMODDIR)/ij/traVS.py src/ tra/ XMLs/ # src and XMLs may have different base names, only number and sorting have to match
	mmv "tra/*.png.tif" "tra/#1.tif"
	@test -f $@ # fiji errors are not returned as return value

tra/%.png : tra/%.tif
	touch $@.stime
	subimage_extract $< $@ 1  4896 4243  9192  9888 # orig. GUI interaction

$(BASENAME)_raw.mha : $(addprefix tra/,$(MR3006g_OT1slices) $(MR3006g_OT2slices) $(MR3006g_OT3slices))
	touch $@.stime
	file-series_reader_SDI $@ $^

$(BASENAME)_raw_rep.mha : $(BASENAME)_raw.mha $(REPIMGs)
	touch $@.stime
	cp -v $< $@
	for f in $(filter-out $<,$^) ; do \
		paste_image $$f $@ $@ 0 ; \
	done
	change_header $@ $@ 0 0.11 0.11 1.0 # essential for e.g. rsi!

%_smROISBS.mha : %.mha
	touch $@.stime
	std-mean_ROI_SBS $< $@  1800 4000 0  4000 3300 343

%_md+3+3+0.mha : %.mha
	touch $@.stime
	median $< $@ 0 3 3 0

%_rsi+1.mha : %.mha
	touch $@.stime
	resample-iso $< $@ 0 1 # 0.11;0.11;1.0 => 0.331662; resample-iso specific for 

hu%_02.vtp hu%_02.mha : ../../manual/processing/mask-seg.mha
## move all sides slidly further in (~2-3µm) normal directions: 1.: +x; 2.: -x; 3.: -y; 4.: +y
	touch $@.stime
	hull hull_02.vtp 0 0  $<  hull_02.mha  0 \
		820       574.062  -34                1.2191     -0.140661  -0.536829398293234  \
		37        655.467  315.587743993803   -0.912432  0.0870706  -0.399858  \
		-61.0851  224      -32.7672328973014  0.051673   -0.924611  -0.377391  \
		-67.1372  974      -34.2000006437302  0.214026   0.905051   -0.367525  \
		0         0        0                  0          0          -1         \
		0         0        342.332            0          0          1

%-seg.mha : %.mha ../../manual/processing/mask-seg.mha
	touch $@.stime
	mask-negated $^ $@ 0

%_mask.mha : %.mha hull_02-seg.mha
	touch $@.stime
	mask $^ $@ 0

$(BASENAME).mha : $(BASENAME)_raw_rep_smROISBS_md+3+3+0_rsi+1_mask.mha # mask should be after rsi
	ln -sf $< $@

# MR3006g_OT1.png : %.png : %.tif ## as tile cannot stream (so far) insufficient RAM without binning
MR3006g_OT1_b+64.png MR3006g_OT2_b+64.png : %_b+64.png : %.tif
	BF_MAX_MEM=$(BFmem) bfconvert -no-upgrade -overwrite -tilex 16384 -tiley 16384  $< $*_T%m.tif # 170187/8 == 21273.375 : 16384/64 == 256 ; 21248/64 == 332
	parallel --eta -j24 -u 'bin {} {.}_b64.tif 0 64  2>/dev/null'  ::: $*_T*.tif
	if [ "$*" == "MR3006g_OT1" ] ; then # MF ifeq does not work as $* is not yet available then \
		tile $*_T0_b64.tif $@ 1 11 6 `ls -1 $*_T*_b64.tif | sort -V` # arg1 is only for header specs! \
	fi
	if [ "$*" == "MR3006g_OT2" ] ; then \
		tile $*_T0_b64.tif $@ 1 17 7 `ls -1 $*_T*_b64.tif | sort -V` # arg1 is only for header specs! \
	fi
	$(mogrifyIM) -fill white -opaque black $@ # replace black conversion artefacts with white
#	rm  $*_T*.tif  $*_T*_b64.tif

%_b+64.svg : %_b+64.png %.txt
	gnuplot -e " datafiles= '$^'; outfile= '$@'; xmax= `identify -format '%w' $<`; ymax= `identify -format '%h' $<` " $(SUBMODDIR)/gnuplot/imgOV.gp
	sed -i 's/gp_image_01.png/$</g' $@
	rm gp_image_01.png

$(BASENAME)_OT2_s088.png : $(BASENAME).mha
	slice $< $@ 1 2 688 # (140+88)/0.331662 ~ 688

%_b+10.png : %.png
	bin $< $@ 1 10

%_b+03.png : %.png
	bin $< $@ 1 3

MR3006g_OT1_s140_tra.png : tra/MR3006g_OT1_s140.png
MR3006g_OT2_s088_tra.png : tra/MR3006g_OT2_s088.png
MR3006g_OT1_s140_tra.png MR3006g_OT2_s088_tra.png : %_tra.png :
	cp $< $@


.SECONDARY: # prevent removal of any intermediate files


.SECONDEXPANSION:

%_RGB.png : $$(call base_,%).txt $$(call base_,%).tif
	@echo "process $+ to $*"
	touch $@.stime
	$(eval pos= $(subst $(basename $<),,$*))
	$(eval pos= $(subst _s,,$(pos)))
	$(eval crop= $(shell awk 'BEGIN{ln="$(pos)"; gsub ("^0*", "", ln)} NR==ln{printf("%d,%d,$(w),$(h)", $$1*$(s)-($(w)/2) < 0 ? 0 : $$1*$(s)-($(w)/2), $$2*$(s)-($(h)/2) < 0 ? 0 : $$2*$(s)-($(h)/2) )}' $<)) # stripping leading zeros is essential!!! http://stackoverflow.com/questions/15515911/strip-leading-zeros-in-awk-program
#	@echo awk 'BEGIN{ln="$(pos)"; gsub ("^0*", "", ln)} NR==ln{printf("%d,%d,$(w),$(h)", $$1*$(s)-($(w)/2) < 0 ? 0 : $$1*$(s)-($(w)/2), $$2*$(s)-($(h)/2) < 0 ? 0 : $$2*$(s)-($(h)/2) )}' $<
	BF_MAX_MEM=$(BFmem) bfconvert -no-upgrade -overwrite -crop $(crop) $(lastword $^) $@

MR3006g_OT1.mha MR3006g_OT2.mha MR3006g_OT3.mha : %.mha : $$($$*slices) # NIIs differenciate properly between RGB and generic vector but cannot be streamed
	touch $@.stime
	file-series_reader_SDI $@ $^

