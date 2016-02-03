
BASENAME = kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1

ITKDIR = ~/itk/simple/build_itk4_iana0
ITKDIRWG = ~/itk/simple_without-git/build_itk4_iana0
VTKDIR = ~/vtk/simple/build_vtk6_iana0

.PHONY: all clean init Arz2blend cleanArz cleanBt cleanBlendPre

all : ACN-Bt_sws.blend Arz2blend

init ../$(BASENAME)_A+B_wsmXm_A+B+tissue_B_mask_Arz.vtp ../$(BASENAME)_A+B_wsmXm_A+B+tissue_B_mask_Bt.vtp :
	$(MAKE) -C .. VE3



% :: %.gz # try decompress-first rule https://www.gnu.org/software/make/manual/html_node/Match_002dAnything-Rules.html#Match_002dAnything-Rules  https://www.gnu.org/software/make/manual/html_node/Double_002dColon.html#Double_002dColon
	unpigz -v -k -- $<

%.gz : %
	pigz -v -- $< 


A+V+ACN-path_sws.vtp : ../$(BASENAME)_A+B_rep08_B_masked_dm_th+100_m+2_OR_ROI900_mps_m+1_th+127@1_kNo+1+0+1_add+1_masked_sws_lmp_th+0+0+1+1+1.vtp
	ln -sf $< $@

ACN-Arz_sws.vtp : ../$(BASENAME)_A+B_wsmXm_A+B+tissue_B_mask_Arz.vtp
	ln -sf $< $@

ACN-Bt_sws.vtp : ../$(BASENAME)_A+B_wsmXm_A+B+tissue_B_mask_Bt.vtp
	ln -sf $< $@

%.wrl : %.vtp  A+V+ACN-path_fm.mha
	$(VTKDIR)/probe-surf2vrml  $^ $@  270 0 0

%.wrl.blend : %.wrl
	~/programme/blender/blender -b   -P ~/blender_scripts/x3d2blend.py -- -i $< -o $@

%.stl : %.vtp
	~/vtk/simple/build_vtk6_iana0/vtp2stl  $^ $@ 1

%.stl.blend : %.stl
	~/programme/blender/blender -b   -P ~/blender_scripts/stl2blend.py -- -i $< -o $@

%.pvtp : %.vtp
	$(VTKDIR)/vtp2pvtp $< $@ 0 4

ACN-Arz_sws_0.vtp ACN-Arz_sws_1.vtp ACN-Arz_sws_2.vtp ACN-Arz_sws_3.vtp : ACN-Arz_sws.pvtp
#ACN-Arz_sws_%.vtp : ACN-Arz_sws.pvtp #does not work

# order only targets are understood differently: http://stackoverflow.com/questions/24821611/order-only-prerequisites-not-working-correctly-in-gnu-make
Arz2blend : ACN-Arz_sws_0.stl.blend ACN-Arz_sws_1.stl.blend ACN-Arz_sws_2.stl.blend ACN-Arz_sws_3.stl.blend

overview_V2A_%/ : overview_V2A_%.blend ACN-Bt_sws.stl.blend Arz2blend
	# ~/skripte/blender-multi $< $(basename $@)/ 0 1550 3
	~/skripte/blender-multi $< $(basename $@)/    0  499 3 # V exit till ACN-Bt appearance
	~/skripte/blender-multi $< $(basename $@)/ 1510 1550 3 # A entry
	~/skripte/blender-multi $< $(basename $@)/  800 1509 3 # all there (~3min per frame)
	~/skripte/blender-multi $< $(basename $@)/  500  599 5 # ACN-Bt appearance (~37GB RAM 14%, ~7min per frame)
	~/skripte/blender-multi $< $(basename $@)/  600  699 3 # ACN-Arz appearance (~72GB RAM 27%, ~40min per frame)
	~/skripte/blender-multi $< $(basename $@)/  700  799 5 # Arz appearance (~41GB RAM 16%, ~1h per frame)

Arz_CO2_%/ : Arz_CO2_%.blend ACN-Bt_sws.stl.blend Arz2blend
	~/skripte/blender-multi $< $(basename $@)/    0 3000 4

%.mp4 : %/
	mencoder mf://$</*.png -o $</$@  -ovc x264 -x264encopts preset=veryslow:fast_pskip=0:tune=film:frameref=15:bitrate=3000:threads=auto:pass=1  -fps 25 && \
	mencoder mf://$</*.png -o $</$@  -ovc x264 -x264encopts preset=veryslow:fast_pskip=0:tune=film:frameref=15:bitrate=3000:threads=auto:pass=2  -fps 25

	ln -sf $</$@ .
	cp -v $@ ~/$@
	rm divx2pass.log divx2pass.log.mbtree

cleanArz :
	rm -f ACN-Arz_sws.vtp ACN-Arz_sws.pvtp ACN-Arz_sws_?.vtp ACN-Arz_sws_?.stl ACN-Arz_sws_?.stl.blend

cleanBt :
	rm -f ACN-Bt_sws.vtp ACN-Bt_sws.stl ACN-Bt_sws.stl.blend

cleanBlendPre :
	rm -f ACN-Bt_sws.vtp ACN-Bt_sws.stl
	rm -f ACN-Arz_sws.vtp ACN-Arz_sws.pvtp ACN-Arz_sws_?.vtp ACN-Arz_sws_?.stl

#prevent removal of any intermediate files http://stackoverflow.com/questions/5426934/why-this-makefile-removes-my-goal https://www.gnu.org/software/make/manual/html_node/Chained-Rules.html
.SECONDARY: 



