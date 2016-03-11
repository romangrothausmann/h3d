
#### Notes:
## $(BASENAME)_seg_B_obp+10+0_kNo+1 : represents main arteries
## $(BASENAME)_seg_B_obp+10+0_kNo+2 : represents main arteries and venes (A+V)


#### ToDo:

## Replace A+B+T by T+B+A as done in processing/low_upp-bounds/Makefile for %_T-mask.mha

#### Done:

BASENAME = h3d

# DATE = ` date +"%y%m%d" `

# BASE = $(BASENAME)-$(DATE)_$(DIRSUFFIX)

ITKDIR = ~/itk/simple/build_itk4_iana0
ITKDIRWG = ~/itk/simple_without-git/build_itk4_iana0
VTKDIR = ~/vtk/simple/build_vtk6_iana0


.PHONY : all clean


all : $(BASENAME).mha $(BASENAME)_seg_A+B.mha $(BASENAME)_seg_A+B+T.mha $(BASENAME)_hull_00.vtp $(BASENAME)_rsi+1+1.0.mha


clean :
	@-rm -v $(BASENAME)_rsi+1+1.0.mha $(BASENAME)_hull_00.vtp $(BASENAME)_hull_00.mha
#	@-rm -v $(BASENAME).mha $(BASENAME)_seg_A+B.mha # not (yet) covered by make
#	@-rm -v $(BASENAME)_seg_A+B+T.mha # not (yet) covered by make


% :: %.gz # try decompress-first rule https://www.gnu.org/software/make/manual/html_node/Match_002dAnything-Rules.html#Match_002dAnything-Rules  https://www.gnu.org/software/make/manual/html_node/Double_002dColon.html#Double_002dColon
	unpigz -v -k -- $<

%.gz : %
	pigz -v -- $< 



$(BASENAME)_rsi+1+1.0.mha : $(BASENAME).mha
	$(ITKDIR)/resample $< $@ 1 0 1.0 1.0 1.0

$(BASENAME)_hull_00%vtp $(BASENAME)_hull_00%mha : $(BASENAME).mha # % only to force single execution of rule ($@ will only contain one of the targets!): http://stackoverflow.com/questions/2973445/gnu-makefile-rule-generating-a-few-targets-from-a-single-source-file#3077254
## upper "lit" needs to be above 342.332 as voxelizer seems to voxelize only below!
	$(VTKDIR)/hull $(BASENAME)_hull_00.vtp 0 0  $<  $(BASENAME)_hull_00.mha  0 \
		822.25    574.062  -34                1.2191     -0.140661  -0.536829398293234  \
		34.1557   655.467  315.587743993803   -0.912432  0.0870706  -0.399858  \
		-61.0851  221.929  -32.7672328973014  0.051673   -0.924611  -0.377391  \
		-67.1372  976.193  -34.2000006437302  0.214026   0.905051   -0.367525  \
		0         0        0                  0          0          -1         \
		0         0        342.332            0          0          1          \


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

## END blood vessel profile speed map and path extraction


## BEGIN fm map for LUT coloring of Bt+Arz

$(BASENAME)_seg_Bt.mha : ../manual/processing/$(BASENAME)_seg_Bt.mha
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

$(BASENAME)_seg_B_fm.mha : $(BASENAME)_seg_B_obp+10+0_kNo+1@1.mha $(BASENAME)_seg_B_kNo+1@255_ed+3.mha
	$(ITKDIR)/fast-marching_f32 $^ $@ 0
	$(ITKDIR)/toUInt16 $@ $@ 0

$(BASENAME)_seg_B_obp+10+0_kNo+1@1_ADD_B_fm.mha : $(BASENAME)_seg_B_fm.mha $(BASENAME)_seg_B_obp+10+0_kNo+1@1.mha # first input defines output type
	$(ITKDIR)/add $^ $@ 0

$(BASENAME)_seg_B_obp+10+0_kNo+1@1_ADD_B_fm_ADD_seg_B@1.mha : $(BASENAME)_seg_B_obp+10+0_kNo+1@1_ADD_B_fm.mha $(BASENAME)_seg_B@1.mha # first input defines output type
	$(ITKDIR)/add $^ $@ 0

### END fm map for LUT coloring of B


### BEGIN make the vene all blue

$(BASENAME)_seg_V@700.mha : $(BASENAME)_seg_B_obp+10+0_kNo+2@1.mha
	$(ITKDIR)/label_connected_components $< $@ 0 0
	$(ITKDIR)/toUInt16 $@ $@ 0
	$(ITKDIR)/thresh-glob $@ $@ 0 1 1 700 # works only if input can hold 700

$(BASENAME)_seg_B-fm.mha : $(BASENAME)_seg_B_obp+10+0_kNo+1@1_ADD_B_fm_ADD_seg_B@1.mha $(BASENAME)_seg_V@700.mha # first input defines output type
	$(ITKDIR)/max $^ $@ 0

##End make the vene all blue


%_th+1+1.mha : %.mha
	$(ITKDIR)/thresh-glob $< $@ 0 1 1 

%_m+1.mha : %.mha
	$(ITKDIRWG)/mean-BOX_01 $< $@ +1 0

%_m+3.mha : %.mha
	$(ITKDIRWG)/mean-BOX_01 $< $@ +3 0

%_th+127@1.mha : %.mha
	$(ITKDIR)/thresh-glob $< $@  0 127 max 1

%_add+1.mha : %.mha
	/opt/convert3d/bin/c3d  $<  -shift 1 -type uchar -o $@

%_ed+10+0.mha : %.mha
	$(ITKDIR)/erode-dilate_dm_f32 $< $@ 0 10 0

%_ed+30+0.mha : %.mha
	$(ITKDIR)/erode-dilate_dm_f32 $< $@ 0 30 0

%_ed+60+0.mha : %.mha
	$(ITKDIR)/erode-dilate_dm_f32 $< $@ 0 60 0

$(BASENAME)_A+B_wsmXm_A+B+tissue_B_m+1_th+127@1_mask_Arz_ed+30.mha : $(BASENAME)_A+B_wsmXm_A+B+tissue_B_m+1_th+127@1_add+1.mha  $(BASENAME)_A+B_wsmXm_Arz_m+3_th+127@5_ed+30+0.mha
	$(ITKDIR)/mask $^ $@ 0

$(BASENAME)_A+B_wsmXm_A+B+tissue_B_m+1_th+127@1_mask_Arz_ed+30_masked.mha : $(BASENAME)_A+B_wsmXm_A+B+tissue_B_m+1_th+127@1_mask_Arz_ed+30.mha kap-net_histo_reg_8bit_mask_hull_02.mha
	$(ITKDIR)/mask $^ $@ 0

$(BASENAME)_A+B_wsmXm_A+B+tissue_B_m+1_th+127@1_mask_Arz_ed+30_masked_mask+A+V.mha : $(BASENAME)_A+B_wsmXm_A+B+tissue_B_m+1_th+127@1_mask_Arz_ed+30_masked.mha $(BASENAME)_A+B_wsmXm_A+B_rep10_B_obp+10+0_kNo+2_ed+10+0.mha
	$(ITKDIR)/mask-negated $^ $@ 0

%_raw.vtp %_sws.vtp : %.mha
	$(VTKDIR)/discrete_marching-cubes $< $(basename $<)  2 2 0

%_th+0+0+1+1+1.vtp : %.vtp
	$(VTKDIR)/threshold  $< $@  0 0 Scalars_ 1 1 1

$(BASENAME)_A+B_wsmXm_A+B+tissue_B_mask_Arz.vtp : $(BASENAME)_A+B_wsmXm_A+B+tissue_B_m+1_th+127@1_mask_Arz_ed+30_masked_mask+A+V_sws_th+0+0+1+1+1.vtp
	ln -sf $< $@


##Begin B_mask_Bt.vtp

$(BASENAME)_A+B_wsmXm_A+B+tissue_B_m+1_th+127@1_mask_Bt_ed+60.mha : $(BASENAME)_A+B_wsmXm_A+B+tissue_B_m+1_th+127@1_add+1.mha  $(BASENAME)_A+B_wsmXm_Bt_m+3_th+127@1_ed+60+0.mha
	$(ITKDIR)/mask $^ $@ 0

$(BASENAME)_A+B_wsmXm_A+B+tissue_B_m+1_th+127@1_mask_Bt_ed+60_masked.mha : $(BASENAME)_A+B_wsmXm_A+B+tissue_B_m+1_th+127@1_mask_Bt_ed+60.mha kap-net_histo_reg_8bit_mask_hull_02.mha
	$(ITKDIR)/mask $^ $@ 0

$(BASENAME)_A+B_wsmXm_A+B+tissue_B_m+1_th+127@1_mask_Bt_ed+60_masked_mask+A+V.mha : $(BASENAME)_A+B_wsmXm_A+B+tissue_B_m+1_th+127@1_mask_Bt_ed+60_masked.mha $(BASENAME)_A+B_wsmXm_A+B_rep10_B_obp+10+0_kNo+2_ed+10+0.mha
	$(ITKDIR)/mask-negated $^ $@ 0

$(BASENAME)_A+B_wsmXm_A+B+tissue_B_mask_Bt.vtp : $(BASENAME)_A+B_wsmXm_A+B+tissue_B_m+1_th+127@1_mask_Bt_ed+60_masked_mask+A+V_sws_th+0+0+1+1+1.vtp
	ln -sf $< $@

##End B_mask_Bt.vtp



#prevent removal of any intermediate files http://stackoverflow.com/questions/5426934/why-this-makefile-removes-my-goal https://www.gnu.org/software/make/manual/html_node/Chained-Rules.html
.SECONDARY: 



.SERIAL : $(BASENAME)_seg_B_fm.mha %_fm.mha %_obp+10+0.mha $(BASENAME)_seg_B_obp+10+0_kNo+2@1_op+500+0_MAX_seg_B@1+mps+ROI900-ROI900_mps+0-1+0.331662.vtk # for gnu-make compiled with patch from: http://savannah.gnu.org/patch/index.php?5108
