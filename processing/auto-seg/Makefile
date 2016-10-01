#### Notes:
##

#### ToDo:
## basic MF fully functional
## couple with processing/ and main MF
## test -j6 and set .SERIAL for ws etc.
## add touch $@.stime
## clean-up
### replace rep13 by rep00 in FNs (diverged from reference cap-net anyway since _rep13+tissue.mha due to different mask)
### reduce FN complexity
## optimize and remove redundencies
### join mask-B rules

#### Done:



SHELL:= /bin/bash
GVmake=$(MAKE) #any line with $(MAKE) gets exectued even with -n, GVmake should merely be used for makefile-visualization to avoid its execution with -n

SUBMODDIR?=../../submodules/

### setting default paths of internal programs
ITK?=$(SUBMODDIR)/ITK-CLIs/

### setting default paths of external programs



export PATH:= $(ITK)/build:$(PATH)


EXECUTABLES = file-series_reader_SDI file-series_writer_SDI mask mask-negated add thresh-glob distance_map_signed_maurer_f32 watershed_morph watershed_morph_nX+border-thr watershed_morph_nX_marker_float open_label-shape fill_holes erode_bin_morph open_bin_morph change_header keepNobj toUInt8


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
	@-rm -v autoSeg.done stderr.out
	@-rm -v $(BASENAME).mha
	@-rm -v $(BASENAME)_seg_T+B+a.mha
	@-rm -v $(BASENAME)_2D*
	@-rm -vr $(BASENAME)_slices/


% :: %.gz
	unpigz -v -- $<

%.gz : %
	pigz -v -- $< 

$(BASENAME).mha : ../slides2stack/$(BASENAME).mha
	ln -sf $< $@

# BEGIN A:

%_slices/ : %.mha
	mkdir -pv $@
	file-series_writer_SDI $< $@/$*_%04d.mha 1

$(BASENAME)_2D_wsmXbt+1+05+1+150.mha : | $(BASENAME)_slices/ # ToDo: order-only dep not ideal, replace with better deps
	ls $(BASENAME)_slices/*.mha | \
		parallel --eta  -j24 watershed_morph_nX+border-thr {} {.}_wsmXbt+1+05+1+150.mha 1 +1 5 1 150 "2>>stderr.out" # ls -1 kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_[0-9][0-9][0-9][0-9].mha  | parallel --eta  -j24 watershed_morph_nX+border-thr {} {.}_wsmXbt+1+05+1+150.mha 1 +1 5 1 150 "2>>stderr.out"
	file-series_reader_SDI $@ $(BASENAME)_slices/*_wsmXbt+1+05+1+150.mha # file-series_reader_SDI kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_%04d_wsmXbt+1+05+1+150.mha kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150.mhd 0 1032 1032
	change_header $@ $@ 0  0.331662 0.331662 0.331662 # z-spacing got lost with file-series_writer


# BEGIN C:

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+0+09+0_ols+0+3000+1.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150.mha
	ls $(BASENAME)_slices/*_wsmXbt+1+05+1+150.mha | \
		parallel --eta  -j24 open_label-shape {} {.}_ols+0+09+0.mha   1  0    9 0 NumberOfPixels "&>>stderr.out" # ls -1 kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_[0-9][0-9][0-9][0-9]_wsmXbt+1+05+1+150.mha | parallel --eta  -j24 opening_by_label-shape_01 {} {.}_ols+0+09+0.mha +0 +09 +0 NumberOfPixels "&>>stderr.out"
	ls $(BASENAME)_slices/*_wsmXbt+1+05+1+150_ols+0+09+0.mha | \
		parallel --eta  -j24 open_label-shape {} {.}_ols+0+3000+1.mha 1  0 3000 1 NumberOfPixels "&>>stderr.out" # ls -1 kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_[0-9][0-9][0-9][0-9]_wsmXbt+1+05+1+150_ols+0+09+0.mha  | parallel --eta  -j24 opening_by_label-shape_01 {} {.}_ols+0+3000+1.mha +0 +3000 +1 NumberOfPixels "&>>stderr.out"
	file-series_reader_SDI $@ $(BASENAME)_slices/*_wsmXbt+1+05+1+150_ols+0+09+0_ols+0+3000+1.mha # file-series_reader_SDI kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_%04d_wsmXbt+1+05+1+150_ols+0+09+0_ols+0+3000+1.mha kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+0+09+0_ols+0+3000+1.mha 0 1032 1032
	change_header $@ $@ 0  0.331662 0.331662 0.331662 # z-spacing got lost with file-series_writer

# END C:

%@1.mha : %.mha
	thresh-glob $< $@ 0  1 max 1
	toUInt8 $@ $@ 0 # in case input is > 8bit, e.g. wsmXbt

%@2.mha : %.mha
	thresh-glob $< $@ 0  1 max 2
	toUInt8 $@ $@ 0 # in case input is > 8bit, e.g. wsmXbt

%@255.mha : %.mha
	thresh-glob $< $@ 0  1 max # defaults to 255 
	toUInt8 $@ $@ 0 # in case input is > 8bit, e.g. wsmXbt

$(BASENAME)_2D_wsmXbt+1+05+1+150@2_mask-B.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150@2.mha $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+0+09+0_ols+0+3000+1@1.mha
	mask-negated $^ $@ 0

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+0+09+0_ols+0+3000+1@1.mha $(BASENAME)_2D_wsmXbt+1+05+1+150@2_mask-B.mha
	add $^ $@ 0 # fiji: C->1 A->2: if(v==3){v=1;}else{v=v;} C+A: kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+300_C+A.mha
#	stat_SDI $@ 100 > $@.stat

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1+0.mha # borderExtraWS used to be false <=> 0
	ln -sf $< $@ # watershed_morph_nX_marker_float $^ $@ 0 1 1 0 # borderExtraWS used to be false <=> 0 # watershed_morph_nX_marker_float kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1.mha kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A.mhd kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1.mha 0 1 1

%_B.mha : %.mha
	thresh-glob $< $@ 0  1 1
	toUInt8 $@ $@ 0 # in case input is > 8bit, e.g. wsmXbt

%_B@1.mha : %.mha # needs make 4.x
	thresh-glob $< $@ 0  1 1 1
#	toUInt8 $@ $@ 0 # in case input is > 8bit, e.g. wsmXbt

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_B.mha
	ln -sf $< $@ # thresh-glob kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1.mha kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C.mha 0  1 1

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1@255.mha
	ln -sf $< $@ # thresh-glob   kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1.mha   kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A.mha 0 1 max

%_obm+10+255.mha : %.mha
	open_bin_morph $< $@ 0 10 255 # opening_bin_morph kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0.mha kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255.mha 0 10 255


$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C_masked_C+A_fh+0_obm+10.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C.mha   $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255.mha
	mask-negated $^ $@ 0 # mask   kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C.mha   kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255.mha   kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C_masked_C+A_fh+0_obm+10.mha 0 1

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_masked_th+125_kNo+1.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255.mha  $(BASENAME)_th+125_kNo+1.mha
	mask $^ $@ 0 # mask kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255.mha  kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_th+125_kNo+1.mha  kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_masked_th+125_kNo+1.mha 0

%_dmsm.mha : %.mha
	distance_map_signed_maurer_f32 $< $@ 0 0 0 # distance_map_signed_maurer_f32 kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255.mha kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_dmsm.mha 0 0

%_wsm+02+1+1.mha : %.mha
	watershed_morph $< $@ 0 02 1 1 # watershed_morph kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_dmsm.mha kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_dmsm_wsm+02+1+1.mha 0 02 1 1 #level << obm_radius for CnJ # T: 10:11:22, RAM: 219818144

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_dmsm_wsm+02+1+1_masked_C+A_fh+0_obm+10.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_dmsm_wsm+02+1+1.mha $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255.mha
	mask $^ $@ 0 # mask kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_dmsm_wsm+02+1+1.mha kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255.mha kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_dmsm_wsm+02+1+1_masked_C+A_fh+0_obm+10.mha 0 #lcc:

### rule for manual creation of target
# $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_dmsm_wsm+02+1+1_masked_C+A_fh+0_obm+10_seg00.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_dmsm_wsm+02+1+1_masked_C+A_fh+0_obm+10.mha $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_masked_th+125_kNo+1_dmsm_wsm+02+1+1_masked_obm+10+255_masked_th+125_kNo+1_dmsm_wsm+02+1+1.mha # using seg00 instead of seg17 for use of manual res.
# 	$(VGLRUN) $(ITSNKAPDIR)/ITK-SNAP -g $< -s $(word 2 $^) # vglrun +xcb /opt/compilation/itksnap-src_build-v3.3.0+gdWS/ITK-SNAP -g kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1.mha -s kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_dmsm_wsm+02+1+1_masked_C+A_fh+0_obm+10_seg00.mha   #CnJ with   kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_masked_th+125_kNo+1_dmsm_wsm+02+1+1_masked_obm+10+255_masked_th+125_kNo+1_dmsm_wsm+02+1+1.mha  ->  kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_dmsm_wsm+02+1+1_masked_C+A_fh+0_obm+10_seg17.mha
### rule to use manual created target
$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_dmsm_wsm+02+1+1_masked_C+A_fh+0_obm+10_seg00.mha : ../../manual/processing/$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_dmsm_wsm+02+1+1_masked_C+A_fh+0_obm+10_seg18.mha
	ln -sf $< $@

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C_masked_C+A_fh+0_obm+10_OR_seg00.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C_masked_C+A_fh+0_obm+10.mha  $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_dmsm_wsm+02+1+1_masked_C+A_fh+0_obm+10_seg00.mha
	add $^ $@ 0
	thresh-glob $@ $@ 0 1 max 255 # as a replacement for OR # using seg00 instead of seg17 for use of manual res. # fiji: kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C_masked_C+A_fh+0_obm+10.mha  OR  kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_dmsm_wsm+02+1+1_masked_C+A_fh+0_obm+10_seg17.mha  ->  kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C_masked_C+A_fh+0_obm+10_OR_seg17.mha

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+B.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C_masked_C+A_fh+0_obm+10_OR_seg00.mha 
	ln -sf $< $@

%_fh+0.mha : %.mha
	fill_holes $< $@ 0 0 # fill_holes kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+B.mha kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+B_fh+0.mha 0 0 #1005 holes

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_masked_th+125_kNo+1_mask-B.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_masked_th+125_kNo+1.mha $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+B_fh+0.mha
	mask-negated $^ $@ 0

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+B_fh+0@1.mha $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_masked_th+125_kNo+1_mask-B@2.mha
	add $^ $@ 0
#	stat_SDI $@ 100 > $@.stat #fiji: B: (kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+B_fh+0.mha) -> 1, A: (kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_masked_th+125_kNo+1.mha) -> 2, if(v==3){v=1;}else{v=v;} -> kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B.mha

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B.mha $(BASENAME)_th+125_kNo+1.mha
	mask $^ $@ 0 # mask   kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B.mha   kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_th+125_kNo+1.mha   kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1.mha  0

%_ebm+01+1.mha : %.mha
	erode_bin_morph $< $@  0 1 1 # erode_bin_morph  kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1.mha   kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1_ebm+01+1.mha 0 1 1 #erode B by 1, by 2 is too much

%_ebm+02+2.mha : %.mha
	erode_bin_morph $< $@  0 2 2 # erode_bin_morph  kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1_ebm+01+1.mha  kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1_ebm+01+1_ebm+02+2.mha 0 2 2  #erode A by 2, by 3 is too much

$(BASENAME)_A+B_wsmXm+1+1+0.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1_ebm+01+1_ebm+02+2_wsmXm+1+1+0.mha
	ln -sf $< $@

%_wsmXm+1+1+0.mha : $(BASENAME).mha %.mha
	watershed_morph_nX_marker_float $^ $@  0 1 1 0 # watershed_morph_nX_marker_float  kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1.mha   kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1_ebm+01+1_ebm+02+2.mha  kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_A+B_wsmXm+1+1+0.mha 0 1 1 0 # T: 5:38:15, RAM: 141263308

%_th+125.mha : %.mha
	thresh-glob $< $@ 0  125 max # thresh-glob kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1.mha kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_th+125.mha 0 125 max
#	toUInt8 $@ $@ 0 # not needed, only used for h3d.mha

%_kNo+1.mha : %.mha
	keepNobj $< $@ 0  0 255 1 0 1 NumberOfPixels # keep_N_objects_01 kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_th+125.mha  kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_th+125_kNo+1.mha 0 255 1 0 1 NumberOfPixels

# END A:


# BEGIN B:

### rule for manual creation of target
# $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1_ebm+01+1_ebm+02+2_seg00.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1_ebm+01+1_ebm+02+2.mha  $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1_ebm+01+1_ebm+02+2_lcc+0.mha
# 	$(VGLRUN) $(ITKSNAPDIR)/ITK-SNAP -g $< -s $(word 2 $^) # vglrun +xcb /opt/compilation/itksnap-src_build-v3.3.0+gdWS/ITK-SNAP -g kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1.mha   -s kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1_ebm+01+1_ebm+02+2.mha   #CnJ with  kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1_ebm+01+1_ebm+02+2_lcc+0.mha  ->  kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1_ebm+01+1_ebm+02+2_seg00.mha
### rule to use manual created target
$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1_ebm+01+1_ebm+02+2_seg00.mha : ../../manual/processing/$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1_ebm+01+1_ebm+02+2_seg12.mha
	ln -sf $< $@

$(BASENAME)_A+B_wsmXm+2+1+0.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1_ebm+01+1_ebm+02+2_seg00_wsmXm+2+1+0.mha
	ln -sf $< $@ # watershed_morph_nX_marker_float  kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1.mha   kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1_ebm+01+1_ebm+02+2_seg00.mha  kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_A+B_wsmXm+2+1+0.mha 0 2 1 0

%_wsmXm+2+1+0.mha : $(BASENAME).mha  %.mha
	watershed_morph_nX_marker_float $^ $@  0 2 1 0 # watershed_morph_nX_marker_float  kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1.mha   kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1_ebm+01+1_ebm+02+2_seg00.mha  kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_A+B_wsmXm+2+1+0.mha 0 2 1 0

# END B:

$(BASENAME)_A+B_wsmXm+1+1+0_masked_th+125_kNo+1.mha $(BASENAME)_A+B_wsmXm+2+1+0_masked_th+125_kNo+1.mha : %_masked_th+125_kNo+1.mha: %.mha $(BASENAME)_th+125_kNo+1.mha
	mask $^ $@ 0 # mask   kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_A+B_wsmXm+1+1+0.mha    kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_th+125_kNo+1.mha   kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_A+B_wsmXm+1+1+0_masked_th+125_kNo+1.mha  0 # mask   kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_A+B_wsmXm+2+1+0.mha    kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_th+125_kNo+1.mha   kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_A+B_wsmXm+2+1+0_masked_th+125_kNo+1.mha  0


# BEGIN A+B:

$(BASENAME)_A+B_wsmXm+1+1+0_masked_th+125_kNo+1_mask-B.mha : $(BASENAME)_A+B_wsmXm+1+1+0_masked_th+125_kNo+1.mha $(BASENAME)_A+B_wsmXm+2+1+0_masked_th+125_kNo+1_B@1.mha # also tested $(BASENAME)_A+B_wsmXm+1+1+0_masked_th+125_kNo+1_a@2.mha, result differs more to kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_A+B_wsmXm_A+B_rep01.mha than without _a@2
	mask-negated $^ $@ 0

$(BASENAME)_A+B_wsmXm_A+B.mha : $(BASENAME)_A+B_wsmXm+2+1+0_masked_th+125_kNo+1_B@1.mha $(BASENAME)_A+B_wsmXm+1+1+0_masked_th+125_kNo+1_mask-B.mha
	add $^ $@ 0 # A from kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_A+B_wsmXm+1+1+0_masked_th+125_kNo+1.mha # B from kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_A+B_wsmXm+2+1+0_masked_th+125_kNo+1.mha # -> kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_A+B_wsmXm_A+B_rep00.mha

### rule for manual creation of target
# $(BASENAME)_A+B_wsmXm_A+B_rep00.mha : $(BASENAME).mha $(BASENAME)_A+B_wsmXm_A+B.mha # repair not based on another segmentation via CnJ
# 	$(VGLRUN) $(ITKSNAPDIR)/ITK-SNAP -g $< -s $(word 2 $^) # manual repair
### rule to use manual created target
$(BASENAME)_A+B_wsmXm_A+B_rep00.mha : ../../manual/processing/$(BASENAME)_A+B_wsmXm_A+B_rep13.mha
	ln -sf $< $@

$(BASENAME)_A+B_wsmXm_A+B_rep00+T.mha : $(BASENAME)_A+B_wsmXm_A+B_rep00.mha
#	add_const $< $@ 0 1 # this would be the better way to get ordered T+B+a, however not done for consitency to earlier way
	thresh-glob $< $@ 0 0 0 3; add $< $@ $@ 0 # instead of label_replace $< $@ 0  0 3 which is not available (yet)

$(BASENAME)_A+B_wsmXm_A+B_rep13+tissue.mha : $(BASENAME)_A+B_wsmXm_A+B_rep00+T.mha ../slides2stack/hull_02-seg.mha
	mask $^ $@ 0

$(BASENAME)_seg_T+B+a.mha : $(BASENAME)_A+B_wsmXm_A+B_rep13+tissue_mask_Bt_corrected-mask_rep03.mha
	ln -sf $< $@



.SECONDARY: 
