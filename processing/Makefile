
#### Notes:
## $(BASENAME)_seg_B_obp+10+0_kNo+1 : represents main arteries
## $(BASENAME)_seg_B_obp+10+0_kNo+2 : represents main arteries and venes (A+V)


#### ToDo:

## Replace A+B+T by T+B+A as done in processing/low_upp-bounds/Makefile for %_T-mask.mha
## check which .SERIAL prereq. can be done with less mem-usg e.g. SDI or other filter, e.g. paste, erode-dilate_dm
## split _raw and _sws dmc

#### Done:


SHELL:= /bin/bash
GVmake=$(MAKE) #any line with $(MAKE) gets exectued even with -n, GVmake should merely be used for makefile-visualization to avoid its execution with -n


BASENAME = h3d

# DATE = ` date +"%y%m%d" `

# BASE = $(BASENAME)-$(DATE)_$(DIRSUFFIX)

ITKDIR = ~/itk/simple/build_itk4_iana0
ITKDIRWG = ~/itk/simple_without-git/build_itk4_iana0
VTKDIR = ~/vtk/simple/build_vtk6_iana0
VTKDIRWG = ~/vtk/simple_without_git/build_itk4_iana0


serialF= $(BASENAME)_seg_Bt@1_ed+60.mha $(BASENAME)_seg_B_obp+10+0_kNo+2@1_ed+10.mha $(BASENAME)_seg_Arz@1_ed+30.mha $(BASENAME)_seg_B_ed+3_fm.mha $(BASENAME)_seg_Bt_fm.mha $(BASENAME)_seg_Arz_fm.mha $(BASENAME)_seg_B_obp+10+0_kNo+2@1_lcc-8b.mha $(BASENAME)_seg_B@1+mps+ROI900-ROI900.mha $(BASENAME)_seg_B_obp+10+0_kNo+2@1_op+500+0.mha $(BASENAME)_seg_B_obp+10+0.mha $(BASENAME)_seg_B_obp+10+0_kNo+2@1_op+500+0_MAX_seg_B@1+mps+ROI900-ROI900_mps+0-1+0.331662.vtk A+V+ACN-path_fm.mha

preciousF=  $(serialF:%=%.gz)


SPACE := $(eval) $(eval)
base_ = $(subst $(SPACE),_,$(filter-out $(lastword $(subst _, ,$1)),$(subst _, ,$1)))
base. = $(subst $(SPACE),.,$(filter-out $(lastword $(subst ., ,$1)),$(subst ., ,$1)))

.PHONY : all clean gv


all : $(BASENAME).mha $(BASENAME)_seg_A+B.mha # main targets
all : slices.done # manual/slices/
all : ana.done # processing/ana/
all : SRV.done # manual/SRV/
all : VE.done # manual/VE/


clean :
	@-rm -v slices.done ana.done SRV.done
	@-rm -v $(BASENAME)_rsi+1+1.0.mha $(BASENAME)_hull_00.vtp $(BASENAME)_hull_00.mha
#	@-rm -v $(BASENAME).mha $(BASENAME)_seg_A+B.mha # not (yet) covered by make
#	@-rm -v $(BASENAME)_seg_A+B+T.mha # not (yet) covered by make
	@-rm -v demo-path.vtp h3d_seg_Bt+Arz-fm.mha h3d_seg_B-fm.mha Bt.blend Arz.blend A.blend V.blend ACN-Arz_?.blend Arz_dec.blend
	@-rm -v $(BASENAME)_hull_02.vtp $(BASENAME)_hull_02.mha

gv : all.dot.svg all.fdp.svg all.neato.svg all.twopi.svg


slices.done : $(BASENAME)_hull_00.vtp $(BASENAME)_rsi+1+1.0.mha # manual/slices/
ana.done : $(BASENAME)_seg_A+B+T.mha  # processing/ana/
SRV.done VE.done : A.blend V.blend Bt.blend Arz.blend Arz_dec.blend ACN-Arz.blend
SRV.done : demo-path.vtp h3d_seg_Bt+Arz-fm.mha h3d_seg_B-fm.mha # manual/SRV/
VE.done : ACN-Bt.blend A+V+ACN-path.blend ACN-a45.blend # manual/VE/
	touch $@


% :: %.gz # try decompress-first rule https://www.gnu.org/software/make/manual/html_node/Match_002dAnything-Rules.html#Match_002dAnything-Rules  https://www.gnu.org/software/make/manual/html_node/Double_002dColon.html#Double_002dColon
	unpigz -v -- $<

%.gz : %
	pigz -v -- $< 



$(BASENAME)_rsi+1+1.0.mha : $(BASENAME).mha
	$(ITKDIR)/resample $< $@ 1 1 1.0 1.0 1.0

$(BASENAME)_hu%_00.vtp $(BASENAME)_hu%_00.mha : $(BASENAME).mha # % only to force single execution of rule ($@ will only contain one of the targets!): http://stackoverflow.com/questions/2973445/gnu-makefile-rule-generating-a-few-targets-from-a-single-source-file#3077254
## upper "lit" needs to be above 342.332 as voxelizer seems to voxelize only below!
	$(VTKDIR)/hull $(BASENAME)_hull_00.vtp 0 0  $<  $(BASENAME)_hull_00.mha  0 \
		822.25    574.062  -34                1.2191     -0.140661  -0.536829398293234  \
		34.1557   655.467  315.587743993803   -0.912432  0.0870706  -0.399858  \
		-61.0851  221.929  -32.7672328973014  0.051673   -0.924611  -0.377391  \
		-67.1372  976.193  -34.2000006437302  0.214026   0.905051   -0.367525  \
		0         0        0                  0          0          -1         \
		0         0        342.332            0          0          1

$(BASENAME)_hu%_02.vtp $(BASENAME)_hu%_02.mha : $(BASENAME).mha 
## move all sides slidly further in (~2-3µm) normal directions: 1.: +x; 2.: -x; 3.: -y; 4.: +y
	$(VTKDIR)/hull $(BASENAME)_hull_02.vtp 0 0  $<  $(BASENAME)_hull_02.mha  0 \
		820       574.062  -34                1.2191     -0.140661  -0.536829398293234  \
		37        655.467  315.587743993803   -0.912432  0.0870706  -0.399858  \
		-61.0851  224      -32.7672328973014  0.051673   -0.924611  -0.377391  \
		-67.1372  974      -34.2000006437302  0.214026   0.905051   -0.367525  \
		0         0        0                  0          0          -1         \
		0         0        342.332            0          0          1


%_lcc-8b.mha : %.mha
	$(ITKDIR)/label_connected_components $< $@ 0 0
	$(ITKDIR)/toUInt8 $@ $@ 0

$(BASENAME)_seg_A@1.mha : $(BASENAME)_seg_B_obp+10+0_kNo+2@1_lcc-8b.mha
	$(ITKDIR)/thresh-glob $< $@ 0 2 2 1

$(BASENAME)_seg_V@1.mha : $(BASENAME)_seg_B_obp+10+0_kNo+2@1_lcc-8b.mha
	$(ITKDIR)/thresh-glob $< $@ 0 1 1 1

## BEGIN blood vessel profile speed map and path extraction in ROI900

%_mps+5.5+1+0.3.vtk %_mps+5.5+1+0.3_max-sphere.mha : %.mha
	$(ITKDIR)/min-path_seg_f32  $< $*_mps+5.5+1+0.3  0 5.5 1 10000 .3   p277.7 p548.6 p276.7   p466.7 p588.0 p126.0 | tee $*_mps+5.5+1+0.3.out

%_ed+100.mha : %.mha
	$(ITKDIR)/erode-dilate_dm_f32 $< $@ 0 100 0

$(BASENAME)_seg_B@1+mps+ROI900.mha : $(BASENAME)_seg_B@1_ROI900.mha $(BASENAME)_seg_B_ROI900_mps+5.5+1+0.3_max-sphere_ed+100.mha
	$(ITKDIR)/mask $^ $@ 1

## END blood vessel profile speed map and path extraction in ROI900


## BEGIN blood vessel profile speed map and path extraction

black.nii.gz : $(BASENAME).mha
	$(ITKDIR)/thresh-glob $< $@ 1 0 max 0

$(BASENAME)_seg_B.mha : $(BASENAME)_seg_A+B+T.mha
	$(ITKDIR)/thresh-glob $< $@ 0 1 1

$(BASENAME)_seg_B@1.mha : $(BASENAME)_seg_A+B+T.mha
	$(ITKDIR)/thresh-glob $< $@ 0 1 1 1

%@1.mha : %.mha
	$(ITKDIR)/thresh-glob $< $@ 0 1 max 1

%_obp+10+0.mha : %.mha
	$(ITKDIR)/open_bin_para $< $@ 0 10 0

%_kNo+2@1.mha : %.mha
	$(ITKDIRWG)/keep_N_objects_01 $< $@ 1 0 2 0 0 NumberOfPixels

%_op+500+0.mha : %.mha
	$(ITKDIR)/open_parabolic_f32 $< $@ 0 500 0

%_op+5.5+0.mha : %.mha
	$(ITKDIR)/open_parabolic_f32 $< $@ 0 5.5 0

%_ROI900.mha : %.mha
	$(ITKDIR)/extract_subimage $< $@  661 1118 263  1000 1000 770

#%-ROI900.mha : %_ROI900.mha black.nii.gz
$(BASENAME)_seg_B@1+mps+ROI900-ROI900.mha : $(BASENAME)_seg_B@1+mps+ROI900_op+5.5+0.mha black.nii.gz
	$(ITKDIR)/paste $^ $@ 0

$(BASENAME)_seg_B_obp+10+0_kNo+2@1_op+500+0_MAX_seg_B@1+mps+ROI900-ROI900.mha : $(BASENAME)_seg_B_obp+10+0_kNo+2@1_op+500+0.mha  $(BASENAME)_seg_B@1+mps+ROI900-ROI900.mha # op should be done on segments@255 to avoid parabola "clipping"
	$(ITKDIR)/max $^ $@ 0


%_mps+0-1+0.331662.vtk %_mps+0-1+0.331662_max-sphere.mha : %.mha
	$(ITKDIR)/min-path_seg_f32  $< $*_mps+0-1+0.331662  0 0 -1 10000 0.331662    p595 p826 p31    p439 p270 p317    p467.8 p587.9 p125.7  p476.8 p579.6 p124.1 | tee $*_mps+0-1+0.331662.out

%.vtp : %.vtk
	$(VTKDIR)/vtk2vtp $< $@ 1

demo-path.vtp : $(BASENAME)_seg_B_obp+10+0_kNo+2@1_op+500+0_MAX_seg_B@1+mps+ROI900-ROI900_mps+0-1+0.331662.vtp
	ln -s $< $@

demo-path.mha : $(BASENAME)_seg_B_obp+10+0_kNo+2@1_op+500+0_MAX_seg_B@1+mps+ROI900-ROI900_mps+0-1+0.331662_max-sphere.mha
	ln -s $< $@

## END blood vessel profile speed map and path extraction


## BEGIN fm map for LUT coloring of Bt+Arz

$(BASENAME)_seg_Bt.mha : ../manual/processing/$(BASENAME)_seg_Bt.mha
	ln -sf $< $@

$(BASENAME)_seg_Bt_mask.mha : ../manual/processing/$(BASENAME)_seg_Bt_mask.mha
	ln -sf $< $@

$(BASENAME)_seg_Arz.mha : ../manual/processing/$(BASENAME)_seg_Arz.mha
	ln -sf $< $@

$(BASENAME)_seg_Bt+Arz_fm-seeds.mha : ../manual/processing/$(BASENAME)_seg_Bt+Arz_fm-seeds.mha
	ln -sf $< $@

%_fm.mha : $(BASENAME)_seg_Bt+Arz_fm-seeds.mha %.mha
	$(ITKDIR)/fast-marching_f32 $^ $@ 0
	$(ITKDIR)/toUInt16 $@ $@ 0

%_add+1360.mha : %.mha
	$(ITKDIR)/add_const $< $@ 0 +1360

$(BASENAME)_seg_Arz_fm+1360.mha : $(BASENAME)_seg_Arz_fm_add+1360.mha  $(BASENAME)_seg_Arz.mha
	$(ITKDIR)/mask $^ $@ 0

$(BASENAME)_seg_Bt+Arz-fm.mha : $(BASENAME)_seg_Bt_fm.mha  $(BASENAME)_seg_Arz_fm+1360.mha
	$(ITKDIR)/max $^ $@ 0

### END fm map for LUT coloring of Bt+Arz


### BEGIN fm map for LUT coloring of B

%_kNo+1@1.mha : %.mha
	$(ITKDIRWG)/keep_N_objects_01 $< $@ 1 0 1 0 0 NumberOfPixels

%_kNo+1@255.mha : %.mha
	$(ITKDIRWG)/keep_N_objects_01 $< $@ 255 0 1 0 0 NumberOfPixels

%_ed+3.mha : %.mha
	$(ITKDIR)/erode-dilate_dm_f32 $< $@ 0 3 0

$(BASENAME)_seg_B_ed+3_fm.mha : $(BASENAME)_seg_B_obp+10+0_kNo+1@1.mha $(BASENAME)_seg_B_ed+3_kNo+1@255.mha
	$(ITKDIR)/fast-marching_f32 $^ $@ 0
	$(ITKDIR)/toUInt16 $@ $@ 0

$(BASENAME)_seg_B_fm.mha : $(BASENAME)_seg_B_ed+3_fm.mha $(BASENAME)_seg_B.mha
	$(ITKDIR)/mask $^ $@ 0

$(BASENAME)_seg_B_obp+10+0_kNo+1@1_ADD_B_fm.mha : $(BASENAME)_seg_B_fm.mha $(BASENAME)_seg_B_obp+10+0_kNo+1@1.mha # first input defines output type
	$(ITKDIR)/add $^ $@ 0

$(BASENAME)_seg_B_obp+10+0_kNo+1@1_ADD_B_fm_ADD_seg_B@1.mha : $(BASENAME)_seg_B_obp+10+0_kNo+1@1_ADD_B_fm.mha $(BASENAME)_seg_B@1.mha # first input defines output type
	$(ITKDIR)/add $^ $@ 0

### END fm map for LUT coloring of B


### BEGIN make the vene all blue

$(BASENAME)_seg_V@700.mha : $(BASENAME)_seg_V@1.mha
	$(ITKDIR)/toUInt16 $< $@ 0
	$(ITKDIR)/thresh-glob $@ $@ 0 1 1 700 # works only if input can hold 700

$(BASENAME)_seg_B-fm.mha : $(BASENAME)_seg_B_obp+10+0_kNo+1@1_ADD_B_fm_ADD_seg_B@1.mha $(BASENAME)_seg_V@700.mha # first input defines output type
	$(ITKDIR)/max $^ $@ 0

### END make the vene all blue


### BEGIN *.blend

%_rsi+0+1.0.mha : %.mha
	$(ITKDIR)/resample $< $@ 1 0 1.0 1.0 1.0

%_add+1.mha : %.mha
	$(ITKDIR)/add_const $< $@ 0 +1

%+seg.mha : %.mha ../manual/processing/mask+seg.mha
	$(ITKDIR)/max $^ $@ 0

%-seg.mha : %.mha ../manual/processing/mask-seg.mha
	$(ITKDIR)/mask-negated $^ $@ 0

%+mask.mha : %_add+1.mha h3d_hull_02-seg.mha
	$(ITKDIR)/mask $^ $@ 0

%_sws.vtp : %.mha
	$(VTKDIR)/discrete_marching-cubes $< $(basename $<)  2 2 0
	rm $*_raw.vtp

%_th+0+0+1+1+1.vtp : %.vtp
	$(VTKDIR)/threshold  $< $@  0 0 Scalars_ 1 1 1

%.stl : %.vtp
	~/vtk/simple/build_vtk6_iana0/vtp2stl  $^ $@ 1

%.stl.blend : %.stl
	~/programme/blender/blender -b   -P ~/blender/scripts/stl2blend.py -- -i $< -o $@

### END *.blend


$(BASENAME)_seg_a.mha : $(BASENAME)_seg_A+B+T.mha
	$(ITKDIR)/thresh-glob $< $@ 0 2 2

$(BASENAME)_seg_a@1.mha : $(BASENAME)_seg_A+B+T.mha
	$(ITKDIR)/thresh-glob $< $@ 0 2 2 1


### BEGIN Bt.blend

$(BASENAME)_seg_Bt@1+mask.mha : $(BASENAME)_seg_Bt@1_add+1.mha h3d_hull_02-seg+seg.mha
	$(ITKDIR)/mask $^ $@ 0

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
	$(VTKDIR)/decimate-QC $< $@ 0 64

Arz_dec.stl : $(BASENAME)_seg_Arz@1+mask_rsi+0+1.0_sws_th+0+0+1+1+1_dec.stl # link to simple STL as this defines the mesh name in the *blend that objects link to
	ln -sf $< $@

Arz_dec.blend : Arz_dec.stl.blend
	ln -sf $< $@

### END Arz_dec.blend



### BEGIN ACN-Arz_*.blend

%_m+1.mha : %.mha
	$(ITKDIRWG)/mean-BOX_01 $< $@ +1 0

%_m+3.mha : %.mha
	$(ITKDIRWG)/mean-BOX_01 $< $@ +3 0

%_th+127@1.mha : %.mha
	$(ITKDIR)/thresh-glob $< $@  0 127 max 1

%_ed+10.mha : %.mha
	$(ITKDIR)/erode-dilate_dm_f32 $< $@ 0 10 0

%_ed+30.mha : %.mha
	$(ITKDIR)/erode-dilate_dm_f32 $< $@ 0 30 0

$(BASENAME)_seg_B@Arz.mha : $(BASENAME)_seg_B@1.mha $(BASENAME)_seg_Arz@1_ed+30.mha
	$(ITKDIR)/mask $^ $@ 0

$(BASENAME)_seg_B@Arz-A-V.mha : $(BASENAME)_seg_B@Arz.mha $(BASENAME)_seg_B_obp+10+0_kNo+2@1_ed+10.mha
	$(ITKDIR)/mask-negated $^ $@ 0

ACN-Arz.vtp : $(BASENAME)_seg_B@Arz-A-V+mask_sws_th+0+0+1+1+1.vtp
	ln -sf $< $@

%.pvtp : %.vtp
	$(VTKDIR)/vtp2pvtp $< $@ 0 4

ACN-Arz_0.vtp ACN-Arz_1.vtp ACN-Arz_2.vtp ACN-Arz_3.vtp : ACN-Arz.pvtp
#ACN-Arz_%.vtp : ACN-Arz.pvtp #does not work

ACN-Arz_%.blend : ACN-Arz_%.stl.blend
	ln -sf $< $@

.PHONY : ACN-Arz.blend
ACN-Arz.blend : ACN-Arz_0.blend ACN-Arz_1.blend ACN-Arz_2.blend ACN-Arz_3.blend

### END ACN-Arz_*.blend


### BEGIN Arz_dec+0.blend
### END Arz_dec+0.blend


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
	$(ITKDIR)/erode-dilate_dm_f32 $< $@ 0 60 0

$(BASENAME)_seg_B@Bt.mha : $(BASENAME)_seg_B@1.mha $(BASENAME)_seg_Bt@1_ed+60.mha
	$(ITKDIR)/mask $^ $@ 0

$(BASENAME)_seg_B@Bt-A-V.mha : $(BASENAME)_seg_B@Bt.mha $(BASENAME)_seg_B_obp+10+0_kNo+2@1_ed+10.mha
	$(ITKDIR)/mask-negated $^ $@ 0

ACN-Bt.vtp : $(BASENAME)_seg_B@Bt-A-V+mask_sws_th+0+0+1+1+1.vtp
	ln -sf $< $@

ACN-Bt.blend : ACN-Bt.stl.blend
	ln -sf $< $@

### END ACN-Bt.blend


### BEGIN A+V+ACN-path.blend

A+V+path.mha : $(BASENAME)_seg_B_obp+10+0_kNo+2@1.mha demo-path@1.mha
	$(ITKDIR)/max $^ $@ 0

%_lmp.vtp : %.vtp
	$(VTKDIRWG)/largest_mesh-part_02 $< $@

$(BASENAME)_seg_B+A+V+path.mha : $(BASENAME)_seg_B.mha A+V+path_ed+100.mha # use B (@255) for m+1 or otherwise B@1
	$(ITKDIR)/mask $^ $@ 0

A+V+ACN-path.vtp : $(BASENAME)_seg_B+A+V+path_m+1_th+127@1+mask_sws_lmp_th+0+0+1+1+1.vtp
	ln -sf $< $@

A+V+ACN-path_fm.mha : $(BASENAME)_seg_B_obp+10+0_kNo+1@1.mha $(BASENAME)_seg_B+A+V+path_ed+3.mha
	$(ITKDIR)/fast-marching_f32 $^ $@ 0
	$(ITKDIR)/toUInt16 $@ $@ 0

%.wrl : %.vtp  %_fm.mha
	$(VTKDIR)/probe-surf2vrml  $^ $@  270 0 0

%.wrl.blend : %.wrl
	~/programme/blender/blender -b   -P ~/blender/scripts/x3d2blend.py -- -i $< -o $@

A+V+ACN-path.blend : A+V+ACN-path.wrl.blend
	ln -sf $< $@

### END A+V+ACN-path.blend

### BEGIN ACN-a45.blend

%_ed+15.mha : %.mha
	$(ITKDIR)/erode-dilate_dm_f32 $< $@ 0 15 0

%_ed+230.mha : %.mha
	$(ITKDIR)/erode-dilate_dm_f32 $< $@ 0 230 0

%_dmsm+0+0.mha : %.mha
	$(ITKDIR)/distance_map_signed_maurer_f32 $< $@ 1 0 0

%_wsm+15+1+0.mha : %.mha
	$(ITKDIR)/watershed_morph $< $@ 1 15 1 0
	$(ITKDIR)/toUInt8 $@ $@ 1

%_ols.mha : %.mha
	$(ITKDIRWG)/opening_by_label-shape_01 $< $@ 0 0 1 NumberOfPixelsOnBorder

$(BASENAME)_seg_Alv.mha : $(BASENAME)_seg_a_ROI900_dmsm+0+0_wsm+15+1+0_ols.mha $(BASENAME)_seg_a@1_ROI900.mha 
	$(ITKDIR)/mask $^ $@ 0

$(BASENAME)_seg_a45.mha : $(BASENAME)_seg_Alv.mha
	$(ITKDIR)/thresh-glob $< $@ 0 46 46 1

$(BASENAME)_seg_B@a45.mha : $(BASENAME)_seg_B@1_ROI900.mha $(BASENAME)_seg_a45_ed+15.mha
	$(ITKDIR)/mask $^ $@ 0

$(BASENAME)_seg_B@a45+mask.mha : $(BASENAME)_seg_B@a45_add+1.mha $(BASENAME)_seg_a45_ed+15.mha
	$(ITKDIR)/mask $^ $@ 0

ACN-a45.mha : $(BASENAME)_seg_B@a45+mask.mha
#ACN-a45.mha : ../manual/correction/ACN-a45.mha
	ln -sf $< $@

ACN-a45.vtp : ACN-a45_sws_th+0+0+1+1+1.vtp
	ln -sf $< $@

$(BASENAME)_seg_B+A+V+path+d230.mha : $(BASENAME)_seg_B.mha A+V+path_ed+230.mha # use B (@255) for m+1 or otherwise B@1
	$(ITKDIR)/mask $^ $@ 0

ACN-a45_fm.mha : $(BASENAME)_seg_B_obp+10+0_kNo+1@1.mha $(BASENAME)_seg_B+A+V+path+d230_ed+3.mha
	$(ITKDIR)/fast-marching_f32 $^ $@ 0
	$(ITKDIR)/toUInt16 $@ $@ 0

# ACN-a45_fm.mha : A+V+ACN-path_fm.mha
# 	ln -sf $< $@

ACN-a45.blend : ACN-a45.wrl.blend
	ln -sf $< $@

### END ACN-a45.blend


## below a rule with "make", a very special case for NOT using $(MAKE) or +make
### lines that contain "$(MAKE)" even in a comment get exectued even with -n|--dry-run !!!
%.gv : % Makefile $(MAKEFILES) # put % to get executed after target has been made to avoid make2graph error due to missing files; http://www.gnu.org/software/make/manual/make.html#MAKEFILES-Variable
	$(GVmake) -Bnd $* | ~/programme/makefile2graph/make2graph | sed 's/label=".*_\([^_\.]\+\)\.[^\.]*"/label="\1"/g' > $@ # DO NOT PUT a comment with make-var here

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
