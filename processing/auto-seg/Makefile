#### Notes:
##

#### ToDo:
## couple with processing/ and main MF

#### Done:



SHELL:= /bin/bash
GVmake=$(MAKE) #any line with $(MAKE) gets exectued even with -n, GVmake should merely be used for makefile-visualization to avoid its execution with -n

SUBMODDIR?=../../submodules/

### setting default paths of internal programs
ITK?=$(SUBMODDIR)/ITK-CLIs/

### setting default paths of external programs



export PATH:= $(ITK)/build:$(PATH)


EXECUTABLES = file-series_reader_SDI mask mask-negated add thresh-glob watershed_morph_nX+border-thr watershed_morph_nX_marker_float open_label-shape fill_holes erode_bin_morph


K:= $(foreach exec,$(EXECUTABLES),\
	$(if $(shell PATH=$(PATH) which $(exec)),some string,$(error "No $(exec) in PATH")))



BASENAME = h3d



.PHONY : all clean


all : autoSeg.done

autoSeg.done : $(BASENAME)_seg_T+B+a.mha
autoSeg.done :
	touch $@
#	@-rm -vr 

clean :
	@-rm -v autoSeg.done
	@-rm -v $(BASENAME)_seg_T+B+a.mha


% :: %.gz
	unpigz -v -- $<

%.gz : %
	pigz -v -- $< 

$(BASENAME).mha : ../slides2stack/$(BASENAME).mha
	ln -sf $< $@

# BEGIN A:

%_slices/ : %.mha
	mkdir -pv $@
	file-series_writer $< $@/$*_%04d.mha 1

$(BASENAME)_2D_wsmXbt+1+05+1+150.mha : $(BASENAME)_slices/
	ls $(BASENAME)_slices/*.mha | \
		parallel --eta  -j24 watershed_morph_nX+border-thr {} {.}_wsmXbt+1+05+1+150.mha 1 +1 5 1 150 "2>>stderr.out" # ls -1 kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_[0-9][0-9][0-9][0-9].mha  | parallel --eta  -j24 watershed_morph_nX+border-thr {} {.}_wsmXbt+1+05+1+150.mha 1 +1 5 1 150 "2>>stderr.out"
	file-series_reader_SDI $@ $(BASENAME)_slices/*_wsmXbt+1+05+1+150.mha # file-series_reader_SDI kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_%04d_wsmXbt+1+05+1+150.mha kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150.mhd 0 1032 1032


# BEGIN C:

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+0+09+0_ols+0+3000+1.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150.mha
	ls $(BASENAME)_slices/*_wsmXbt+1+05+1+150.mha | \
		parallel --eta  -j24 opening_by_label-shape_01 {} {.}_ols+0+09+0.mha +0 +09 +0 NumberOfPixels "&>>stderr.out" # ls -1 kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_[0-9][0-9][0-9][0-9]_wsmXbt+1+05+1+150.mha | parallel --eta  -j24 opening_by_label-shape_01 {} {.}_ols+0+09+0.mha +0 +09 +0 NumberOfPixels "&>>stderr.out"
	ls $(BASENAME)_slices/*_wsmXbt+1+05+1+150_ols+0+09+0.mha | \
		parallel --eta  -j24 opening_by_label-shape_01 {} {.}_ols+0+3000+1.mha +0 +3000 +1 NumberOfPixels "&>>stderr.out" # ls -1 kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_[0-9][0-9][0-9][0-9]_wsmXbt+1+05+1+150_ols+0+09+0.mha  | parallel --eta  -j24 opening_by_label-shape_01 {} {.}_ols+0+3000+1.mha +0 +3000 +1 NumberOfPixels "&>>stderr.out"
	file-series_reader_SDI $@ $(BASENAME)_slices/*_wsmXbt+1+05+1+150_ols+0+09+0_ols+0+3000+1.mha # file-series_reader_SDI kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_%04d_wsmXbt+1+05+1+150_ols+0+09+0_ols+0+3000+1.mha kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+0+09+0_ols+0+3000+1.mha 0 1032 1032

# END C:

%@1.mha : %.mha
	thresh-glob $< $@ 0  1 max 1

%@2.mha : %.mha
	thresh-glob $< $@ 0  1 max 2

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+0+09+0_ols+0+3000+1@1.mha $(BASENAME)_2D_wsmXbt+1+05+1+150@2.mha
	add $^ $@ 0 # fiji: C->1 A->2: C+A: kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+300_C+A.mha

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1+0.mha # borderExtraWS used to be false <=> 0
	ln -sf $< $@ # watershed_morph_nX_marker_float $^ $@ 0 1 1 0 # borderExtraWS used to be false <=> 0 # watershed_morph_nX_marker_float kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1.mha kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A.mhd kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1.mha 0 1 1

%_B.mha : %.mha
	thresh-glob $< $@ 0  1 1

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_B.mha
	ln -sf $< $@ # thresh-glob kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1.mha kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C.mha 0  1 1

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C_masked_C+A_fh+0_obm+10.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C.mha   $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255.mha
	mask $^ $@ 0 # mask   kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C.mha   kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255.mha   kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C_masked_C+A_fh+0_obm+10.mha 0 1

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C_masked_C+A_fh+0_obm+10_OR_seg17.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C_masked_C+A_fh+0_obm+10.mha  $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_dmsm_wsm+02+1+1_masked_C+A_fh+0_obm+10_seg17.mha
	add $^ $@ 0
	thresh-glob $@ $@ 0 1 max 255 # as a replacement for OR # fiji: kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C_masked_C+A_fh+0_obm+10.mha  OR  kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_dmsm_wsm+02+1+1_masked_C+A_fh+0_obm+10_seg17.mha  ->  kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C_masked_C+A_fh+0_obm+10_OR_seg17.mha

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+B.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C_masked_C+A_fh+0_obm+10_OR_seg17.mha 
	ln -sf $< $@

%_fh+0.mha : %.mha
	fill_holes $< $@ 0 0 # fill_holes kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+B.mha kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+B_fh+0.mha 0 0 #1005 holes

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_masked_th+125_kNo+1_mask-B.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_masked_th+125_kNo+1.mha $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+B_fh+0.mha
	mask-negated $^ $@ 0

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+B_fh+0.mha $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_masked_th+125_kNo+1_mask-B.mha
	add $^ $@ 0
	stat $@ #fiji: B: (kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+B_fh+0.mha) -> 1, A: (kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_masked_th+125_kNo+1.mha) -> 2, if(v==3){v=1;}else{v=v;} -> kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B.mha

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B.mha $(BASENAME)_th+125_kNo+1.mha
	mask $^ $@ 0 # mask   kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B.mha   kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_th+125_kNo+1.mha   kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1.mha  0

%_ebm+01+1.mha : %.mha
	erode_bin_morph $< $@  0 1 1 # erode_bin_morph  kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1.mha   kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1_ebm+01+1.mha 0 1 1 #erode B by 1, by 2 is too much

%_ebm+02+2.mha : %.mha
	erode_bin_morph $< $@  0 2 2 # erode_bin_morph  kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1_ebm+01+1.mha  kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1_ebm+01+1_ebm+02+2.mha 0 2 2  #erode A by 2, by 3 is too much

# $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1+0.mha
$(BASENAME)_A+B.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1_ebm+01+1_ebm+02+2.mha
	ln -sf $< $@

%_wsmXm+1+1+0.mha : $(BASENAME).mha %.mha
	watershed_morph_nX_marker_float $^ $@  0 1 1 0 # watershed_morph_nX_marker_float  kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1.mha   kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1_ebm+01+1_ebm+02+2.mha  kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_A+B_wsmXm+1+1+0.mha 0 1 1 0

$(BASENAME)_A+B_wsmXm+1+1+0_masked_th+125_kNo+1.mha : %_A+B_wsmXm+1+1+0_masked_th+125_kNo+1.mha : %_A+B_wsmXm+1+1+0.mha %_th+125_kNo+1.mha
	mask $^ $@ 0 # mask   kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_A+B_wsmXm+1+1+0.mha    kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_th+125_kNo+1.mha   kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_A+B_wsmXm+1+1+0_masked_th+125_kNo+1.mha  0

# END A:

# BEGIN A+B:

$(BASENAME)_A+B_wsmXm_A+B_rep00.mha : %_A+B_wsmXm_A+B_rep00.mha : %_A+B_wsmXm+1+1+0_masked_th+125_kNo+1.mha %_A+B_wsmXm+2+1+0_masked_th+125_kNo+1.mha
	add $^ $@ 0 # A from kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_A+B_wsmXm+1+1+0_masked_th+125_kNo+1.mha # B from kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_A+B_wsmXm+2+1+0_masked_th+125_kNo+1.mha # -> kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_A+B_wsmXm_A+B_rep00.mha

$(BASENAME)_seg_T+B+a.mha : $(BASENAME)_A+B_wsmXm_A+B_rep13+tissue_mask_Bt_corrected-mask_rep03.mha
	ln -sf $< $@
