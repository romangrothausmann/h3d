

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





%_th+1+1.mha : %.mha
	$(ITKDIR)/thresh-glob $< $@ 0 1 1 

$(BASENAME)_A+B_wsmXm_A+B+tissue_B.mha : $(BASENAME)_A+B_wsmXm_A+B+tissue_th+1+1.mha
	ln -sf $< $@

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



