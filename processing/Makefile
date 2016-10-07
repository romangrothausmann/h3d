
#### Notes:
## $(BASENAME)_seg_B_obp+10+0_kNo+1 : represents main arteries
## $(BASENAME)_seg_B_obp+10+0_kNo+2 : represents main arteries and venes (A+V)


#### ToDo:
## remove hull_00 creation
## change h3d_seg_T+B+a.mha to be ordered T@1, B@2, a@3 => adjust thresholds accordingly!
## check which .SERIAL prereq. can be done with less mem-usg e.g. SDI or other filter, e.g. paste_image, erode-dilate_dm
## split _raw and _sws dmc

#### Done:
## link to slides2stack/hull_02.* instead of recreating

## Replaced A+B+T/T+B+A by T+B+a, A+B/B+A by B+a; T = tissue, B = blood, V = veine, A = artery, a = air

SHELL:= /bin/bash
GVmake=$(MAKE) #any line with $(MAKE) gets exectued even with -n, GVmake should merely be used for makefile-visualization to avoid its execution with -n


SUBMODDIR?=../submodules/

### setting default paths of internal programs
ITK?=$(SUBMODDIR)/ITK-CLIs/
VTK?=$(SUBMODDIR)/VTK-CLIs/

export PATH:= $(ITK)/build:$(PATH)
export PATH:= $(VTK)/build:$(PATH)


## git show 5fd0311de8d8c0:processing/Makefile | grep -oP 'ITKDIR\)/\K.*?(?= )' | sort -u | xargs
EXECUTABLES = add add_const distance_map_signed_maurer_f32 erode-dilate_dm_f32 subimage_extract fast-marching_f32 keepNobj label_connected_components mask mask-negated max mean min-path_seg_f32 open_bin_para open_label-shape open_parabolic_f32 paste_image resample thresh-glob toUInt16 toUInt8 watershed_morph label_overlap

## git show 5fd0311de8d8c0:processing/Makefile | grep -oP 'VTKDIR\)/\K.*?(?= )' | sort -u | xargs
EXECUTABLES+= decimate-QC discrete_marching-cubes hull largest_mesh-part probe-surf2vrml threshold vtk2vtp vtp2pvtp


K:= $(foreach exec,$(EXECUTABLES),\
	$(if $(shell PATH=$(PATH) which $(exec)),some string,$(error "No $(exec) in PATH")))



BASENAME = h3d

# DATE = ` date +"%y%m%d" `

# BASE = $(BASENAME)-$(DATE)_$(DIRSUFFIX)



serialF= $(BASENAME)_seg_Bt@1_ed+60.mha $(BASENAME)_seg_B_obp+10+0_kNo+2@1_ed+10.mha $(BASENAME)_seg_Arz@1_ed+30.mha $(BASENAME)_seg_B_ed+3_fm.mha $(BASENAME)_seg_Bt_fm.mha $(BASENAME)_seg_Arz_fm.mha $(BASENAME)_seg_B_obp+10+0_kNo+2@1_lcc-8b.mha $(BASENAME)_seg_B@1+mps+ROI900-ROI900.mha $(BASENAME)_seg_B_obp+10+0_kNo+2@1_op+500+0.mha $(BASENAME)_seg_B_obp+10+0.mha $(BASENAME)_seg_B_obp+10+0_kNo+2@1_op+500+0_MAX_seg_B@1+mps+ROI900-ROI900_mps+0-1+0.331662.vtk A+V+ACN-path_fm.mha $(BASENAME)_seg_B_ed+3.mha

preciousF=  $(serialF:%=%.gz)


SPACE := $(eval) $(eval)
base_ = $(subst $(SPACE),_,$(filter-out $(lastword $(subst _, ,$1)),$(subst _, ,$1)))
base. = $(subst $(SPACE),.,$(filter-out $(lastword $(subst ., ,$1)),$(subst ., ,$1)))

.PHONY : all clean gv

## deps on subdirs results, just as a check
all : $(BASENAME).mha # from slides2stack/
all : $(BASENAME)_seg_T+B+a.mha # from segmentation/

## local "targets" (of this MF)
all : $(BASENAME)_seg_B@a45_m+1_th+127@1_kNo+1+0+1_msg.lol # not in segmentation because a45 rules are here
all : slices.done # manual/slices/
all : ana.done # processing/ana/
all : luBounds.done # processing/low_upp-bounds/
all : VR.done # manual/VR/
all : SRV.done # manual/SRV/
all : VE.done # manual/VE/


.PHONY : optional
optional : demo-path.blend # base for cam-along-path ani, included in e.g. A2V.blend
optional : a-wsm+30.mha # as input to CnJ of ITKSnap to select labels for creation of ../manual/processing/h3d_seg_1+Bt+Arz-map.mha

clean :
	@-rm -v slices.done ana.done SRV.done
	@-rm -v $(BASENAME)_rsi+1+1.0.mha $(BASENAME)_hull_00.vtp $(BASENAME)_hull_00.mha
#	@-rm -v $(BASENAME).mha $(BASENAME)_seg_T+B+a.mha # not (yet) covered by make
	@-rm -v demo-path.vtp h3d_seg_Bt+Arz-fm.mha h3d_seg_B-fm.mha Bt.blend Arz.blend A.blend V.blend ACN-Arz_?.blend Arz_dec.blend
	@-rm -v $(BASENAME)_hull_02.vtp $(BASENAME)_hull_02.mha

gv : all.dot.svg all.fdp.svg all.neato.svg all.twopi.svg


slices.done : $(BASENAME).mha $(BASENAME)_seg_B+a.mha $(BASENAME)_rsi+1+1.0.mha $(BASENAME)_hull_00.vtp # manual/slices/
ana.done : $(BASENAME)_seg_T+B+a.mha h3d_hull_02-seg.mha # processing/ana/
luBounds.done : $(BASENAME).mha $(BASENAME)_seg_B+a.mha h3d_hull_02-seg.mha # processing/low_upp-bounds/
VR.done : $(BASENAME).mha # manual/VR/
SRV.done VE.done : A.blend V.blend Bt.blend Arz.blend Arz_dec.blend ACN-Arz.blend
SRV.done : demo-path.vtp h3d_seg_Bt+Arz-fm.mha h3d_seg_B-fm.mha # manual/SRV/
VE.done : ACN-Bt.blend A+V+ACN-path.blend A+V+ACN-path_dec.blend ACN-a45.blend # manual/VE/
slices.done ana.done luBounds.done VR.done SRV.done VE.done:
	touch $@


% :: %.gz # try decompress-first rule https://www.gnu.org/software/make/manual/html_node/Match_002dAnything-Rules.html#Match_002dAnything-Rules  https://www.gnu.org/software/make/manual/html_node/Double_002dColon.html#Double_002dColon
	unpigz -v -- $<

%.gz : %
	pigz -v -- $< 



$(BASENAME)_rsi+1+1.0.mha : $(BASENAME).mha
	touch $@.stime
	resample $< $@ 1 1 1.0 1.0 1.0

$(BASENAME)_hu%_00.vtp $(BASENAME)_hu%_00.mha : $(BASENAME).mha # % only to force single execution of rule ($@ will only contain one of the targets!): http://stackoverflow.com/questions/2973445/gnu-makefile-rule-generating-a-few-targets-from-a-single-source-file#3077254
## upper "lit" needs to be above 342.332 as voxelizer seems to voxelize only below!
	touch $@.stime
	hull $(BASENAME)_hull_00.vtp 0 0  $<  $(BASENAME)_hull_00.mha  0 \
		822.25    574.062  -34                1.2191     -0.140661  -0.536829398293234  \
		34.1557   655.467  315.587743993803   -0.912432  0.0870706  -0.399858  \
		-61.0851  221.929  -32.7672328973014  0.051673   -0.924611  -0.377391  \
		-67.1372  976.193  -34.2000006437302  0.214026   0.905051   -0.367525  \
		0         0        0                  0          0          -1         \
		0         0        342.332            0          0          1

$(BASENAME)_hull_02.% : slides2stack/hull_02.%
	ln -sf $< $@

$(BASENAME)_seg_B+a.mha : $(BASENAME)_seg_B@1.mha $(BASENAME)_seg_a@2.mha
	touch $@.stime
	add $^ $@ 0


%_lcc-8b.mha : %.mha
	touch $@.stime
	label_connected_components $< $@ 0 0
	toUInt8 $@ $@ 0

$(BASENAME)_seg_A@1.mha : $(BASENAME)_seg_B_obp+10+0_kNo+2@1_lcc-8b.mha
	touch $@.stime
	thresh-glob $< $@ 0 2 2 1

$(BASENAME)_seg_V@1.mha : $(BASENAME)_seg_B_obp+10+0_kNo+2@1_lcc-8b.mha
	touch $@.stime
	thresh-glob $< $@ 0 1 1 1


## BEGIN a@wsm+30.mha

%_th+127.mha : %.mha
	touch $@.stime
	thresh-glob $< $@  0 127 max

$(BASENAME)_seg_a_m+3_th+127_dmsm+0+0_wsm+30+1+0.mha : %_wsm+30+1+0.mha : %.mha
	touch $@.stime
	watershed_morph $< $@ 0 30 1 0 # fully connected in case spatial separation is desired in future but here no lines to avoid separation
	toUInt8 $@ $@ 1 # only contains around 183 labels

a-wsm+30.mha : $(BASENAME)_seg_a_m+3_th+127_dmsm+0+0_wsm+30+1+0.mha
	ln -s $< $@

a@wsm+30.mha : $(BASENAME)_seg_a_m+3_th+127_dmsm+0+0_wsm+30+1+0.mha $(BASENAME)_seg_a.mha
	touch $@.stime
	mask $^ $@ 0

## END a@wsm+30.mha

## BEGIN Bt and Arz

$(BASENAME)_seg_1+Bt+Arz-map.mha :  ../manual/processing/$(BASENAME)_seg_1+Bt+Arz-map.mha
# $(BASENAME)_seg_1+Bt+Arz-map.mha : $(BASENAME)_seg_a.mha  a-wsm+30.mha
#	$(VGLRUN) $(ITKSNAPDIR)/ITK-SNAP -g $< -s $(word 2 $^)  # use CnJ of ITKSnap v3.3.0+gdWS to select labels and save as: $(BASENAME)_seg_1+Bt+Arz-map.mha
	ln -sf $< $@

%_th+2+2.mha : %.mha
	touch $@.stime
	thresh-glob $< $@ 0 2 2

%_th+3+3.mha : %.mha
	touch $@.stime
	thresh-glob $< $@ 0 3 3

$(BASENAME)_seg_a@Bt-map.mha : $(BASENAME)_seg_a.mha $(BASENAME)_seg_1+Bt+Arz-map_th+2+2.mha
	touch $@.stime
	mask $^ $@ 0

$(BASENAME)_seg_Bt.mha : $(BASENAME)_seg_a@Bt-map_kNo+1@255.mha
	ln -s $< $@

$(BASENAME)_seg_a@Arz-map.mha : $(BASENAME)_seg_a.mha $(BASENAME)_seg_1+Bt+Arz-map_th+3+3.mha
	touch $@.stime
	mask $^ $@ 0

$(BASENAME)_seg_Arz.mha : $(BASENAME)_seg_a@Arz-map_kNo+1@255.mha
	ln -s $< $@

## END Bt and Arz

## BEGIN blood vessel profile speed map and path extraction in ROI900

%_mps+5.5+1+0.3.vtk %_mps+5.5+1+0.3_max-sphere.mha %_mps+5.5+1+0.3.txt : %.mha
	touch $@.stime
	min-path_seg_f32  $< $*_mps+5.5+1+0.3  0 5.5 1 10000 .3   p277.7 p548.6 p276.7   p466.7 p588.0 p126.0 | tee $*_mps+5.5+1+0.3.out

%_ed+100.mha : %.mha
	touch $@.stime
	erode-dilate_dm_f32 $< $@ 0 100 0

%_ed+300.mha : %.mha
	touch $@.stime
	erode-dilate_dm_f32 $< $@ 0 300 0

$(BASENAME)_seg_B@1+mps+ROI900.mha : $(BASENAME)_seg_B@1_ROI900.mha $(BASENAME)_seg_B_ROI900_mps+5.5+1+0.3_max-sphere_ed+100.mha
	touch $@.stime
	mask $^ $@ 1

$(BASENAME)_seg_B@1+mps+ROI900+d300.mha : $(BASENAME)_seg_B@1_ROI900.mha $(BASENAME)_seg_B_ROI900_mps+5.5+1+0.3_max-sphere_ed+300.mha
	touch $@.stime
	mask $^ $@ 1

## END blood vessel profile speed map and path extraction in ROI900


## BEGIN blood vessel profile speed map and path extraction

black.nii.gz : $(BASENAME).mha
	touch $@.stime
	thresh-glob $< $@ 1 0 max 0

$(BASENAME)_seg_B.mha : $(BASENAME)_seg_T+B+a.mha
	touch $@.stime
	thresh-glob $< $@ 0 1 1

$(BASENAME)_seg_B@1.mha : $(BASENAME)_seg_T+B+a.mha
	touch $@.stime
	thresh-glob $< $@ 0 1 1 1

%@1.mha : %.mha
	touch $@.stime
	thresh-glob $< $@ 0 1 max 1

%@255.mha : %.mha
	touch $@.stime
	thresh-glob $< $@ 0 1 max

%_obp+10+0.mha : %.mha
	touch $@.stime
	open_bin_para $< $@ 0 10 0

%_kNo+2@1.mha : %.mha
	touch $@.stime
	keepNobj $< $@ 0   1 0 2 0 0 NumberOfPixels

%_op+500+0.mha : %.mha
	touch $@.stime
	open_parabolic_f32 $< $@ 0 500 0

%_op+5.5+0.mha : %.mha
	touch $@.stime
	open_parabolic_f32 $< $@ 0 5.5 0

%_ROI900.mha : %.mha
	touch $@.stime
	subimage_extract $< $@ 0 661 1118 263  1000 1000 770

$(BASENAME)_seg_B@1+mps+ROI900-op-ROI900.mha : $(BASENAME)_seg_B@1+mps+ROI900_op+5.5+0.mha black.nii.gz
	touch $@.stime
	paste_image $^ $@ 0

$(BASENAME)_seg_B_obp+10+0_kNo+2@1_op+500+0_MAX_seg_B@1+mps+ROI900-ROI900.mha : $(BASENAME)_seg_B_obp+10+0_kNo+2@1_op+500+0.mha  $(BASENAME)_seg_B@1+mps+ROI900-op-ROI900.mha # op should be done on segments@255 to avoid parabola "clipping"
	touch $@.stime
	max $^ $@ 0


%_mps+0-1+0.331662.vtk %_mps+0-1+0.331662_max-sphere.mha %_mps+0-1+0.331662.txt : %.mha
	touch $@.stime
	min-path_seg_f32  $< $*_mps+0-1+0.331662  0 0 -1 10000 0.331662    p595 p826 p31    p439 p270 p317    p467.8 p587.9 p125.7  p476.8 p579.6 p124.1 | tee $*_mps+0-1+0.331662.out

%.vtp : %.vtk
	touch $@.stime
	vtk2vtp $< $@ 1

demo-path.vtp : $(BASENAME)_seg_B_obp+10+0_kNo+2@1_op+500+0_MAX_seg_B@1+mps+ROI900-ROI900_mps+0-1+0.331662.vtp
	ln -s $< $@

demo-path.txt : $(BASENAME)_seg_B_obp+10+0_kNo+2@1_op+500+0_MAX_seg_B@1+mps+ROI900-ROI900_mps+0-1+0.331662.txt
	awk '{print $$1, $$2, $$3, $$4, 1, $$6}' $< > $@ # replace path-number by bifurcation-number as expected by path2blend_ng.py

demo-path.blend : demo-path.txt
	blender -b   -P $(SUBDIR)/blender/scripts/path2blend_ng.py -- -i $< -o $@  | tee $(basename $@).out

demo-path.mha : $(BASENAME)_seg_B_obp+10+0_kNo+2@1_op+500+0_MAX_seg_B@1+mps+ROI900-ROI900_mps+0-1+0.331662_max-sphere.mha
	ln -s $< $@

## END blood vessel profile speed map and path extraction


## BEGIN fm map for LUT coloring of Bt+Arz

$(BASENAME)_seg_Bt+Arz_fm-seeds.mha : ../manual/processing/$(BASENAME)_seg_Bt+Arz_fm-seeds.mha
	ln -sf $< $@

%_fm.mha : $(BASENAME)_seg_Bt+Arz_fm-seeds.mha %.mha
	touch $@.stime
	fast-marching_f32 $^ $@ 0
	toUInt16 $@ $@ 0

%_add+1360.mha : %.mha
	touch $@.stime
	add_const $< $@ 0 +1360

$(BASENAME)_seg_Arz_fm+1360.mha : $(BASENAME)_seg_Arz_fm_add+1360.mha  $(BASENAME)_seg_Arz.mha
	touch $@.stime
	mask $^ $@ 0

$(BASENAME)_seg_Bt+Arz-fm.mha : $(BASENAME)_seg_Bt_fm.mha  $(BASENAME)_seg_Arz_fm+1360.mha
	touch $@.stime
	max $^ $@ 0

### END fm map for LUT coloring of Bt+Arz


### BEGIN fm map for LUT coloring of B

%_kNo+1@1.mha : %.mha
	touch $@.stime
	keepNobj $< $@ 0   1 0 1 0 0 NumberOfPixels

%_kNo+1@255.mha : %.mha
	touch $@.stime
	keepNobj $< $@ 0 255 0 1 0 0 NumberOfPixels

%_ed+3.mha : %.mha
	touch $@.stime
	erode-dilate_dm_f32 $< $@ 0 3 0

$(BASENAME)_seg_B_ed+3_fm.mha : $(BASENAME)_seg_B_obp+10+0_kNo+1@1.mha $(BASENAME)_seg_B_ed+3_kNo+1@255.mha
	touch $@.stime
	fast-marching_f32 $^ $@ 0
	toUInt16 $@ $@ 0

$(BASENAME)_seg_B_fm.mha : $(BASENAME)_seg_B_ed+3_fm.mha $(BASENAME)_seg_B.mha
	touch $@.stime
	mask $^ $@ 0

$(BASENAME)_seg_B_obp+10+0_kNo+1@1_ADD_B_fm.mha : $(BASENAME)_seg_B_fm.mha $(BASENAME)_seg_B_obp+10+0_kNo+1@1.mha # first input defines output type
	touch $@.stime
	add $^ $@ 0

$(BASENAME)_seg_B_obp+10+0_kNo+1@1_ADD_B_fm_ADD_seg_B@1.mha : $(BASENAME)_seg_B_obp+10+0_kNo+1@1_ADD_B_fm.mha $(BASENAME)_seg_B@1.mha # first input defines output type
	touch $@.stime
	add $^ $@ 0

### END fm map for LUT coloring of B


### BEGIN make the vene all blue

$(BASENAME)_seg_V@700.mha : $(BASENAME)_seg_V@1.mha
	touch $@.stime
	toUInt16 $< $@ 0
	thresh-glob $@ $@ 0 1 1 700 # works only if input can hold 700

$(BASENAME)_seg_B-fm.mha : $(BASENAME)_seg_B_obp+10+0_kNo+1@1_ADD_B_fm_ADD_seg_B@1.mha $(BASENAME)_seg_V@700.mha # first input defines output type
	touch $@.stime
	max $^ $@ 0

### END make the vene all blue


### BEGIN *.blend

%_rsi+0+1.0.mha : %.mha
	touch $@.stime
	resample $< $@ 1 0 1.0 1.0 1.0

%_add+1.mha : %.mha
	touch $@.stime
	add_const $< $@ 0 +1

%+seg.mha : %.mha ../manual/processing/mask+seg.mha
	touch $@.stime
	max $^ $@ 0

%-seg.mha : %.mha ../manual/processing/mask-seg.mha
	touch $@.stime
	mask-negated $^ $@ 0

$(BASENAME)_hull_02-seg.mha : slides2stack/hull_02-seg.mha
	ln -sf $< $@

%+mask.mha : %_add+1.mha $(BASENAME)_hull_02-seg.mha
	touch $@.stime
	mask $^ $@ 0

%_sws.vtp : %.mha
	touch $@.stime
	discrete_marching-cubes $< $(basename $<)  2 2 0
	rm $*_raw.vtp

%_th+0+0+1+1+1.vtp : %.vtp
	touch $@.stime
	threshold  $< $@  0 0 Scalars_ 1 1 1

%.stl : %.vtp
	vtp2stl  $^ $@ 1

%.stl.blend : %.stl
	blender -b   -P $(SUBDIR)/blender/scripts/stl2blend.py -- -i $< -o $@

### END *.blend


$(BASENAME)_seg_a.mha : $(BASENAME)_seg_T+B+a.mha
	touch $@.stime
	thresh-glob $< $@ 0 2 2

$(BASENAME)_seg_a@1.mha : $(BASENAME)_seg_T+B+a.mha
	touch $@.stime
	thresh-glob $< $@ 0 2 2 1

$(BASENAME)_seg_a@2.mha : $(BASENAME)_seg_T+B+a.mha
	touch $@.stime
	thresh-glob $< $@ 0 2 2 2


### BEGIN Bt.blend

$(BASENAME)_seg_Bt@1+mask.mha : $(BASENAME)_seg_Bt@1_add+1.mha h3d_hull_02-seg+seg.mha
	touch $@.stime
	mask $^ $@ 0

Bt.stl : $(BASENAME)_seg_Bt@1+mask_rsi+0+1.0_sws_th+0+0+1+1+1.stl # link to simple STL as this defines the mesh name in the *blend that objects link to
	ln -sf $< $@

Bt.blend : Bt.stl.blend
	ln -sf $< $@

### END Bt.blend


### BEGIN Arz.blend

Arz.stl : $(BASENAME)_seg_Arz@1+mask_rsi+0+1.0_sws_th+0+0+1+1+1.stl # link to simple STL as this defines the mesh name in the *blend that objects link to
	ln -sf $< $@

Arz.blend : Arz.stl.blend
	ln -sf $< $@

### END Arz.blend



### BEGIN Arz_dec.blend

%_dec.vtp : %.vtp
	touch $@.stime
	decimate-QC $< $@ 0 64

Arz_dec.stl : $(BASENAME)_seg_Arz@1+mask_rsi+0+1.0_sws_th+0+0+1+1+1_dec.stl # link to simple STL as this defines the mesh name in the *blend that objects link to
	ln -sf $< $@

Arz_dec.blend : Arz_dec.stl.blend
	ln -sf $< $@

### END Arz_dec.blend



### BEGIN ACN-Arz_*.blend

%_m+1.mha : %.mha
	touch $@.stime
	mean $< $@ 0 +1

%_m+2.mha : %.mha
	touch $@.stime
	mean $< $@ 0 +2

%_m+3.mha : %.mha
	touch $@.stime
	mean $< $@ 0 +3

%_th+127@1.mha : %.mha
	touch $@.stime
	thresh-glob $< $@  0 127 max 1

%_ed+10.mha : %.mha
	touch $@.stime
	erode-dilate_dm_f32 $< $@ 0 10 0

%_ed+30.mha : %.mha
	touch $@.stime
	erode-dilate_dm_f32 $< $@ 0 30 0

$(BASENAME)_seg_B@Arz.mha : $(BASENAME)_seg_B@1.mha $(BASENAME)_seg_Arz@1_ed+30.mha
	touch $@.stime
	mask $^ $@ 0

$(BASENAME)_seg_B@Arz-A-V.mha : $(BASENAME)_seg_B@Arz.mha $(BASENAME)_seg_B_obp+10+0_kNo+2@1_ed+10.mha
	touch $@.stime
	mask-negated $^ $@ 0

ACN-Arz.vtp : $(BASENAME)_seg_B@Arz-A-V+mask_sws_th+0+0+1+1+1.vtp
	ln -sf $< $@

%.pvtp : %.vtp
	touch $@.stime
	vtp2pvtp $< $@ 0 4

ACN-Arz_0.vtp ACN-Arz_1.vtp ACN-Arz_2.vtp ACN-Arz_3.vtp : ACN-Arz.pvtp
#ACN-Arz_%.vtp : ACN-Arz.pvtp #does not work

ACN-Arz_%.blend : ACN-Arz_%.stl.blend
	ln -sf $< $@

.PHONY : ACN-Arz.blend
ACN-Arz.blend : ACN-Arz_0.blend ACN-Arz_1.blend ACN-Arz_2.blend ACN-Arz_3.blend

### END ACN-Arz_*.blend


### BEGIN A.blend

A.stl : $(BASENAME)_seg_A@1+mask_rsi+0+1.0_sws_th+0+0+1+1+1.stl # link to simple STL as this defines the mesh name in the *blend that objects link to
	ln -sf $< $@

A.blend : A.stl.blend
	ln -sf $< $@

### END V.blend


### BEGIN V.blend

V.stl : $(BASENAME)_seg_V@1+mask_rsi+0+1.0_sws_th+0+0+1+1+1.stl # link to simple STL as this defines the mesh name in the *blend that objects link to
	ln -sf $< $@

V.blend : V.stl.blend
	ln -sf $< $@

### END V.blend


### BEGIN ACN-Bt.blend

%_ed+60.mha : %.mha
	touch $@.stime
	erode-dilate_dm_f32 $< $@ 0 60 0

$(BASENAME)_seg_B@Bt.mha : $(BASENAME)_seg_B@1.mha $(BASENAME)_seg_Bt@1_ed+60.mha
	touch $@.stime
	mask $^ $@ 0

$(BASENAME)_seg_B@Bt-A-V.mha : $(BASENAME)_seg_B@Bt.mha $(BASENAME)_seg_B_obp+10+0_kNo+2@1_ed+10.mha
	touch $@.stime
	mask-negated $^ $@ 0

ACN-Bt.vtp : $(BASENAME)_seg_B@Bt-A-V+mask_sws_th+0+0+1+1+1.vtp
	ln -sf $< $@

ACN-Bt.blend : ACN-Bt.stl.blend
	ln -sf $< $@

### END ACN-Bt.blend


### BEGIN A+V+ACN-path.blend

## A+V+ACN.mha : ACN only around artery and veine (not connecting capillary)
A+V+ACN.mha : $(BASENAME)_seg_B.mha $(BASENAME)_seg_B_obp+10+0_kNo+2@1_ed+100.mha
	touch $@.stime
	mask $^ $@ 0

## A+V+path.mha : only artery, veine and connecting capillary
A+V+path.mha : $(BASENAME)_seg_B_obp+10+0_kNo+2@1.mha demo-path@1.mha
	touch $@.stime
	max $^ $@ 0

#%-ROI900.mha : %_ROI900.mha black.nii.gz
$(BASENAME)_seg_B@1+mps+ROI900-ROI900.mha : $(BASENAME)_seg_B@1+mps+ROI900.mha black.nii.gz
	touch $@.stime
	paste_image $^ $@ 0

# $(BASENAME)_seg_B+A+V+path.mha : $(BASENAME)_seg_B.mha A+V+path_ed+100.mha # A+V not smoothed
# 	touch $@.stime
# 	mask $^ $@ 0

$(BASENAME)_seg_B+A+V+path.mha : A+V+ACN_m+3_th+127@1.mha $(BASENAME)_seg_B@1+mps+ROI900-ROI900.mha # A+V smoothed
	touch $@.stime
	max $^ $@ 0

%_lmp.vtp : %.vtp
	touch $@.stime
	largest_mesh-part $< $@ 0

A+V+ACN-path.vtp : $(BASENAME)_seg_B+A+V+path@255_m+1_th+127@1+mask_sws_lmp_th+0+0+1+1+1.vtp #@255 for m+1
	ln -sf $< $@

A+V+ACN-path_fm.mha : $(BASENAME)_seg_B_obp+10+0_kNo+1@1.mha $(BASENAME)_seg_B+A+V+path_ed+3.mha
	touch $@.stime
	fast-marching_f32 $^ $@ 0
	toUInt16 $@ $@ 0

%.wrl : %.vtp  %_fm.mha
	touch $@.stime
	probe-surf2vrml  $^ $@  270 0 0

%.wrl.blend : %.wrl
	blender -b   -P $(SUBDIR)/blender/scripts/x3d2blend.py -- -i $< -o $@

A+V+ACN-path.blend : A+V+ACN-path.wrl.blend
	ln -sf $< $@

$(BASENAME)_seg_B+A+V+path_m+1_th+127@1+mask_sws_lmp_th+0+0+1+1+1_dec.vtp : %_dec.vtp : %.vtp
	touch $@.stime
	decimate-QC $< $@ 0 256

A+V+ACN-path_dec.vtp : $(BASENAME)_seg_B+A+V+path@255_m+1_th+127@1+mask_sws_lmp_th+0+0+1+1+1_dec.vtp # link to simple STL as this defines the mesh name in the *blend that objects link to
	ln -sf $< $@

A+V+ACN-path_dec.wrl : A+V+ACN-path_dec.vtp  A+V+ACN-path_fm.mha
	touch $@.stime
	probe-surf2vrml  $^ $@  270 0 0

A+V+ACN-path_dec.blend : A+V+ACN-path_dec.wrl.blend
	ln -sf $< $@

### END A+V+ACN-path.blend

### BEGIN ACN-a45.blend

%_dmsm+0+0.mha : %.mha
	touch $@.stime
	distance_map_signed_maurer_f32 $< $@ 1 0 0

$(BASENAME)_seg_a_ROI900_dmsm+0+0_wsm+15+1+0.mha : %_wsm+15+1+0.mha : %.mha
	touch $@.stime
	watershed_morph $< $@ 1 15 1 0
	toUInt8 $@ $@ 1 # only contains about 78 labels

%_ols.mha : %.mha
	touch $@.stime
	open_label-shape $< $@ 0 0 0 1 NumberOfPixelsOnBorder

# $(BASENAME)_seg_Alv-comp-cont.mha : $(BASENAME)_seg_a_ROI900_dmsm+0+0_wsm+15+1+0_ols.mha $(BASENAME)_seg_a@1_ROI900.mha 
# 	touch $@.stime
# 	mask $^ $@ 0

$(BASENAME)_seg_Alv.mha : $(BASENAME)_seg_a_ROI900_dmsm+0+0_wsm+15+1+0.mha $(BASENAME)_seg_a@1_ROI900.mha 
	touch $@.stime
	mask $^ $@ 0

$(BASENAME)_seg_a45.mha : $(BASENAME)_seg_Alv.mha
	touch $@.stime
	thresh-glob $< $@ 0 46 46 1

$(BASENAME)_seg_Alv_sws.vtp : $(BASENAME)_seg_Alv.mha
	touch $@.stime
	discrete_marching-cubes $< $(basename $<)  1 255 0
	rm $(BASENAME)_seg_Alv_raw.vtp

$(BASENAME)_seg_Alv.vtp : $(BASENAME)_seg_Alv_sws.vtp
	touch $@.stime
	threshold  $< $@  0 0 Scalars_ 0 0 0 # adjecency is stored as point data, AllScalars: 1 leads to gaps, 0 to "scars"

$(BASENAME)_seg_a45.vtp : $(BASENAME)_seg_Alv.vtp
	touch $@.stime
	threshold  $< $@  0 1 Scalars_ 46 46 1 # label is stored as cell data, AllScalars does not matter for cell data

%_ed+15+1.mha : %.mha
	touch $@.stime
	erode-dilate_dm_f32 $< $@ 0 15 1 # use image spacing, i.e. 15um

$(BASENAME)_seg_B@a45.mha : $(BASENAME)_seg_B_ROI900.mha $(BASENAME)_seg_a45_ed+15+1.mha
	touch $@.stime
	mask $^ $@ 0

%_kNo+1+0+1.mha : %.mha
	touch $@.stime
	keepNobj $< $@ 0 1 0 1 0 1 NumberOfPixels

### rule for manual creation of target
# $(BASENAME)_seg_B@a45_m+1_th+127@1_kNo+1+0+1_msg.mha : $(BASENAME)_seg_B@a45_m+1_th+127@1_kNo+1+0+1.mha
# 	$(VGLRUN) $(ITSNKAPDIR)/ITK-SNAP -g $(BASENAME)_ROI900.mha -s $< -S $@ # adaptive brush to add ery
### rule to use manual created target
$(BASENAME)_seg_B@a45_m+1_th+127@1_kNo+1+0+1_msg.mha : ../manual/correction/$(BASENAME)_seg_B@a45.mha # _ery09_th+1_fh+0_m+1_th+127_kNo+1.mha @1
	ln -sf $< $@

$(BASENAME)_seg_B@a45_msg.mha : $(BASENAME)_seg_B@a45_m+1_th+127@1_kNo+1+0+1_msg.mha
	ln -sf $< $@

%_msg.lol : %.mha %_msg.mha
	label_overlap $^ > $@

$(BASENAME)_seg_B@a45+mask.mha : $(BASENAME)_seg_B@a45_msg_add+1.mha $(BASENAME)_seg_a45_ed+60.mha
	touch $@.stime
	mask $^ $@ 0

ACN-a45.mha : $(BASENAME)_seg_B@a45+mask.mha
	ln -sf $< $@

ACN-a45.vtp : ACN-a45_sws_th+0+0+1+1+1.vtp
	ln -sf $< $@

ACN-a45_fm.mha : $(BASENAME)_seg_B_obp+10+0_kNo+1@1_ROI900.mha $(BASENAME)_seg_B@1+mps+ROI900+d300_ed+3.mha
	touch $@.stime
	fast-marching_f32 $^ $@ 0
	toUInt16 $@ $@ 0

# ACN-a45_fm.mha : A+V+ACN-path_fm.mha
# 	ln -sf $< $@

ACN-a45.blend : ACN-a45.wrl.blend
	ln -sf $< $@

### END ACN-a45.blend


## below a rule with "make", a very special case for NOT using $(MAKE) or +make
### lines that contain "$(MAKE)" even in a comment get exectued even with -n|--dry-run !!!
%.gv : % Makefile $(MAKEFILES) # put % to get executed after target has been made to avoid make2graph error due to missing files; http://www.gnu.org/software/make/manual/make.html#MAKEFILES-Variable
	$(GVmake) -Bnd $* | make2graph | sed 's/label=".*_\([^_\.]\+\)\.[^\.]*"/label="\1"/g' > $@ # DO NOT PUT a comment with make-var here

#prevent removal of any intermediate files http://stackoverflow.com/questions/5426934/why-this-makefile-removes-my-goal https://www.gnu.org/software/make/manual/html_node/Chained-Rules.html
#.SECONDARY: # $(SRV_G)_[xyz]@[0-9]*.png #not working
.PRECIOUS:  %.gv $(preciousF)


#prevent removal of any intermediate files http://stackoverflow.com/questions/5426934/why-this-makefile-removes-my-goal https://www.gnu.org/software/make/manual/html_node/Chained-Rules.html
.SECONDARY: 



.SERIAL : $(serialF) # for gnu-make compiled with patch from: http://savannah.gnu.org/patch/index.php?5108


.SECONDEXPANSION: # https://www.gnu.org/software/make/manual/html_node/Secondary-Expansion.html

%.svg : $$(call base.,%).gv # %.svg : $(suffix $*).gv does not work, needs SECONDEXPANSION
	$(eval pos= $(subst $(basename $+),,$*))
	$(eval pos= $(subst .,,$(pos)))

	$(pos) -Tsvg -o $@ $<
