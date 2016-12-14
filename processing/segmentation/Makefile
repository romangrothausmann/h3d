#### Notes:
## ITK-SNAP calles use non-existent params: -L FN for CnJ source, -S FN to save final segmentation in

#### ToDo:
## conditional use of manual or automatic results
## join last rep03 with rep13 -> rep14 then mask with mask.mha to create new _seg_T+B+a.mha
## couple with processing/ and main MF
## add touch $@.stime
### reduce FN complexity
## optimize and remove redundencies
### join mask-B rules

#### Done:
## basic MF fully functional
## tested -j6 no .SERIAL for ws necessary
## clean-up
## replaced _rep13+tissue with +T



SHELL:= /bin/bash
GVmake=$(MAKE) #any line with $(MAKE) gets exectued even with -n, GVmake should merely be used for makefile-visualization to avoid its execution with -n

SUBMODDIR?=../../submodules/

### setting default paths of internal programs
ITK?=$(SUBMODDIR)/ITK-CLIs/

### setting default paths of external programs



export PATH:= $(ITK)/build:$(PATH)


EXECUTABLES = file-series_reader_SDI file-series_writer_SDI mask mask-negated add thresh-glob distance_map_signed_maurer_f32 watershed_morph watershed_morph_nX+border-thr watershed_morph_nX_marker_float open_label-shape fill_holes erode_bin_morph open_bin_morph change_header keepNobj toUInt8 label_overlap


K:= $(foreach exec,$(EXECUTABLES),\
	$(if $(shell PATH=$(PATH) which $(exec)),some string,$(error "No $(exec) in PATH")))



BASENAME = h3d



.PHONY : all clean


all : autoSeg.done

autoSeg.done : $(BASENAME)_seg_T+B+a.mha
autoSeg.done : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1_ebm+01+1_ebm+02+2_msg.lol
autoSeg.done : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_masked_th+125_kNo+1_dmsm_wsm+02+1+1_masked_obm+10+255_masked_th+125_kNo+1@1_msg.lol
autoSeg.done : $(BASENAME)_A+B_wsmXm_A+B_msg.lol
autoSeg.done : $(BASENAME)_A+B_wsmXm_A+B+T_msg.lol
autoSeg.done :
	touch $@
	@-rm -vr !(Makefile|h3d_seg_T+B+a.mha|h3d_A+B_wsmXm_A+B+T_msg.mha|autoSeg.done|*.lol) # http://stackoverflow.com/questions/8525437/list-files-not-matching-a-pattern#12265662

clean :
	@-rm -v autoSeg.done stderr.out preMask.mha
	@-rm -v $(BASENAME).mha
	@-rm -v $(BASENAME)_seg_T+B+a.mha
	@-rm -v $(BASENAME)_2D*
	@-rm -v $(BASENAME)_A+B*
	@-rm -v $(BASENAME)_th+125*
	@-rm -vr $(BASENAME)_slices/


% :: %.gz
	unpigz -v -- $<

%.gz : %
	pigz -v -- $< 

% :: %.bz2
	pbzip2 -v -d -- $< # no -f to force failure of MF because there should be no *.bz2 if it alreay has been decompressed, if it got copied over again, this leads to extra and unnecessary dependencies!

%.bz2 : %
	pbzip2 -v -- $< 

$(BASENAME).mha : ../slides2stack/$(BASENAME).mha
	ln -sf $< $@

%_slices/ : %.mha
	mkdir -pv $@
	file-series_writer_SDI $< $@/$*_%04d.mha 1

$(BASENAME)_2D_wsmXbt+1+05+1+150.mha : | $(BASENAME)_slices/ # ToDo: order-only dep not ideal, replace with better deps
	ls $(BASENAME)_slices/*.mha | \
		parallel --eta  -j24 watershed_morph_nX+border-thr {} {.}_wsmXbt+1+05+1+150.mha 1 +1 5 1 150 "2>>stderr.out"
	file-series_reader_SDI $@ $(BASENAME)_slices/*_wsmXbt+1+05+1+150.mha
	change_header $@ $@ 0  0.331662 0.331662 0.331662 # z-spacing got lost with file-series_writer

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+0+3001+0.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150.mha # a
	ls $(BASENAME)_slices/*_wsmXbt+1+05+1+150.mha | \
		parallel --eta  -j24 open_label-shape {} {.}_ols+0+3001+0.mha 1  0 3001 0 NumberOfPixels "&>>stderr.out"
	file-series_reader_SDI $@ $(BASENAME)_slices/*_wsmXbt+1+05+1+150_ols+0+3001+0.mha
	change_header $@ $@ 0  0.331662 0.331662 0.331662 # z-spacing got lost with file-series_writer

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+0+09+0_ols+0+3000+1.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150.mha # C
	ls $(BASENAME)_slices/*_wsmXbt+1+05+1+150.mha | \
		parallel --eta  -j24 open_label-shape {} {.}_ols+0+09+0.mha   1  0    9 0 NumberOfPixels "&>>stderr.out"
	ls $(BASENAME)_slices/*_wsmXbt+1+05+1+150_ols+0+09+0.mha | \
		parallel --eta  -j24 open_label-shape {} {.}_ols+0+3000+1.mha 1  0 3000 1 NumberOfPixels "&>>stderr.out"
	file-series_reader_SDI $@ $(BASENAME)_slices/*_wsmXbt+1+05+1+150_ols+0+09+0_ols+0+3000+1.mha
	change_header $@ $@ 0  0.331662 0.331662 0.331662 # z-spacing got lost with file-series_writer

%@1.mha : %.mha
	thresh-glob $< $@ 0  1 max 1
	toUInt8 $@ $@ 0 # in case input is > 8bit, e.g. wsmXbt

%@2.mha : %.mha
	thresh-glob $< $@ 0  1 max 2
	toUInt8 $@ $@ 0 # in case input is > 8bit, e.g. wsmXbt

%@255.mha : %.mha
	thresh-glob $< $@ 0  1 max # defaults to 255 
	toUInt8 $@ $@ 0 # in case input is > 8bit, e.g. wsmXbt

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+0+3001+0@2_mask-B.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+0+3001+0@2.mha $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+0+09+0_ols+0+3000+1@1.mha
	mask-negated $^ $@ 0

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+0+09+0_ols+0+3000+1@1.mha $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+0+3001+0@2_mask-B.mha
	add $^ $@ 0

%_wsmXm+1+1+0+0.mha : $(BASENAME).mha %.mha
	watershed_morph_nX_marker_float $^ $@  0 1 1 0  0 # optional 0 for compat. to earlier version

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1+0+0.mha : | $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1_ebm+01+1_ebm+02+2_msg_wsmXm+2+1+0.mha # just to avoid parallel execution of wsmXm with other jobs
$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1+0+0.mha # borderExtraWS used to be false <=> 0
	ln -sf $< $@

%_B.mha : %.mha
	thresh-glob $< $@ 0  1 1
	toUInt8 $@ $@ 0 # in case input is > 8bit, e.g. wsmXbt

%_B@1.mha : %.mha # needs make 4.x
	thresh-glob $< $@ 0  1 1 1

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_B.mha
	ln -sf $< $@

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1@255.mha
	ln -sf $< $@

%_obm+10+255.mha : %.mha
	open_bin_morph $< $@ 0 10 255

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C_masked_C+A_fh+0_obm+10.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C.mha   $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255.mha
	mask-negated $^ $@ 0

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_masked_th+125_kNo+1.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255.mha  $(BASENAME)_th+125_kNo+1.mha
	mask $^ $@ 0

%_dmsm.mha : %.mha
	distance_map_signed_maurer_f32 $< $@ 0 0 1 # orig version of dmsm used image-spacing by default!

%_wsm+02+1+1.mha : %.mha
	watershed_morph $< $@ 0 02 1 1 # T: 10:11:22, RAM: 219818144

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_masked_th+125_kNo+1_dmsm_wsm+02+1+1.mha : | $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1+0+0.mha # just to avoid parallel execution of wsmXm with other jobs
$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_masked_th+125_kNo+1_dmsm_wsm+02+1+1_masked_obm+10+255_masked_th+125_kNo+1.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_masked_th+125_kNo+1_dmsm_wsm+02+1+1.mha $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_masked_th+125_kNo+1.mha # wsm masked by A+V+a # FN base of orig. target wrong (extra _dmsm_wsm+02+1+1 at FN end)
	mask $^ $@ 0

### rule for manual creation of target
# $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_masked_th+125_kNo+1_dmsm_wsm+02+1+1_masked_obm+10+255_masked_th+125_kNo+1@1_msg.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_masked_th+125_kNo+1_dmsm_wsm+02+1+1_masked_obm+10+255_masked_th+125_kNo+1.mha
# 	$(VGLRUN) $(ITSNKAPDIR)/ITK-SNAP -g $(BASENAME).mha -L $< -S $@ # CnJ (on empty base) to select larger blood vessels (A+V_@1) separating them from air (a)
### rule to use manual created target
$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_masked_th+125_kNo+1_dmsm_wsm+02+1+1_masked_obm+10+255_masked_th+125_kNo+1@1_msg.mha : ../../manual/correction/$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_dmsm_wsm+02+1+1_masked_C+A_fh+0_obm+10_seg18.mha # A+V (no C, no a) # FN base of orig. wrong (substrings missing)
	ln -sf $< $@

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C_masked_C+A_fh+0_obm+10_OR_seg00.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C_masked_C+A_fh+0_obm+10.mha  $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_masked_th+125_kNo+1_dmsm_wsm+02+1+1_masked_obm+10+255_masked_th+125_kNo+1@1_msg.mha # C || A+V
	add $^ $@ 0
	thresh-glob $@ $@ 0 1 max 255 # as a replacement for OR

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+B.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C_masked_C+A_fh+0_obm+10_OR_seg00.mha 
	ln -sf $< $@

%_fh+0.mha : %.mha
	fill_holes $< $@ 0 0

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_masked_th+125_kNo+1_mask-B.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_masked_th+125_kNo+1.mha $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+B_fh+0.mha
	mask-negated $^ $@ 0

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+B_fh+0@1.mha $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_masked_th+125_kNo+1_mask-B@2.mha # pre B+a
	add $^ $@ 0

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B.mha $(BASENAME)_th+125_kNo+1.mha
	mask $^ $@ 0

%_ebm+01+1.mha : %.mha
	erode_bin_morph $< $@  0 1 1

%_ebm+02+2.mha : %.mha
	erode_bin_morph $< $@  0 2 2

### rule for manual creation of target
# $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1_ebm+01+1_ebm+02+2_msg.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1_ebm+01+1_ebm+02+2.mha  $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1_ebm+01+1_ebm+02+2_lcc+0.mha
# 	$(VGLRUN) $(ITKSNAPDIR)/ITK-SNAP -g $< -s $(word 2 $^) # CnJ
### rule to use manual created target
$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1_ebm+01+1_ebm+02+2_msg.mha : ../../manual/correction/$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1_ebm+01+1_ebm+02+2_seg12.mha
	ln -sf $< $@

$(BASENAME)_A+B_wsmXm+1+1+0.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1_ebm+01+1_ebm+02+2_msg_wsmXm+1+1+0.mha # a
	ln -sf $< $@

$(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1_ebm+01+1_ebm+02+2_msg_wsmXm+2+1+0.mha : | $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1_ebm+01+1_ebm+02+2_msg_wsmXm+1+1+0.mha # just to avoid parallel execution of wsmXm with other jobs
$(BASENAME)_A+B_wsmXm+2+1+0.mha : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1_ebm+01+1_ebm+02+2_msg_wsmXm+2+1+0.mha # B
	ln -sf $< $@

%_wsmXm+1+1+0.mha : $(BASENAME).mha %.mha
	watershed_morph_nX_marker_float $^ $@  0 1 1 0

%_wsmXm+2+1+0.mha : $(BASENAME).mha  %.mha
	watershed_morph_nX_marker_float $^ $@  0 2 1 0

%_th+125.mha : %.mha
	thresh-glob $< $@ 0  125 max
#	toUInt8 $@ $@ 0 # not needed, only used for h3d.mha

%_kNo+1.mha : %.mha
	keepNobj $< $@ 0  0 255 1 0 1 NumberOfPixels

$(BASENAME)_A+B_wsmXm+1+1+0_masked_th+125_kNo+1.mha $(BASENAME)_A+B_wsmXm+2+1+0_masked_th+125_kNo+1.mha : %_masked_th+125_kNo+1.mha : %.mha $(BASENAME)_th+125_kNo+1.mha
	mask $^ $@ 0

# BEGIN A+B:

$(BASENAME)_A+B_wsmXm+1+1+0_masked_th+125_kNo+1_mask-B.mha : $(BASENAME)_A+B_wsmXm+1+1+0_masked_th+125_kNo+1.mha $(BASENAME)_A+B_wsmXm+2+1+0_masked_th+125_kNo+1_B@1.mha
	mask-negated $^ $@ 0

$(BASENAME)_A+B_wsmXm_A+B.mha : $(BASENAME)_A+B_wsmXm+2+1+0_masked_th+125_kNo+1_B@1.mha $(BASENAME)_A+B_wsmXm+1+1+0_masked_th+125_kNo+1_mask-B.mha # final B+a
	add $^ $@ 0

### rule for manual creation of target
# $(BASENAME)_A+B_wsmXm_A+B_msg.mha : $(BASENAME).mha $(BASENAME)_A+B_wsmXm_A+B.mha # repair not based on another segmentation via CnJ
# 	$(VGLRUN) $(ITKSNAPDIR)/ITK-SNAP -g $< -s $(word 2 $^) # manual repair
### rule to use manual created target
$(BASENAME)_A+B_wsmXm_A+B_msg.mha : ../../manual/correction/$(BASENAME)_A+B_wsmXm_A+B_rep13.mha
	ln -sf $< $@

$(BASENAME)_A+B_wsmXm_A+B_msg+T.mha : $(BASENAME)_A+B_wsmXm_A+B_msg.mha
#	add_const $< $@ 0 1 # this would be the better way to get ordered T+B+a, however not done for consitency to earlier way
	thresh-glob $< $@ 0 0 0 3; add $< $@ $@ 0 # instead of label_replace $< $@ 0  0 3 which is not available (yet)

preMask.mha : $(BASENAME)_seg_T+B+a.mha
	thresh-glob $< $@ 0 1 max

$(BASENAME)_A+B_wsmXm_A+B+T.mha : $(BASENAME)_A+B_wsmXm_A+B_msg+T.mha preMask.mha # B+a+T
	mask $^ $@ 0

$(BASENAME)_A+B_wsmXm_A+B+T_msg.mha : ../../manual/correction/$(BASENAME)_A+B_wsmXm_A+B_rep13+tissue_mask_Bt_corrected-mask_rep03.mha # comp. to _A+B_wsmXm_A+B+T.mha only rep. of Bt obstruction and "landing platform"
	ln -sf $< $@

$(BASENAME)_seg_T+B+a.mha : $(BASENAME)_A+B_wsmXm_A+B+T_msg.mha
	ln -sf $< $@

%_msg.lol : %.mha %_msg.mha
	label_overlap $^ > $@

# .SECONDARY:
.PRECIOUS: $(BASENAME)_A+B_wsmXm_A+B+T_msg.mha

.SERIAL: $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_masked_th+125_kNo+1_dmsm_wsm+02+1+1.mha
