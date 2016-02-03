
SHELL:= /bin/bash

SRV_G:= kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_srv+500+500+0.331662+2
SRV_A:= kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_A+B_wsmXm_Bt-fm_comb_Arz-fm+1360_srv+500+500+0.331662+0
SRV_B:= kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_A+B_wsmXm_A+B_rep12_B_kNo+1_ed+3_fm_mod_mask_B_max_700_srv+500+500+0.331662+0

z-slice_num:= $(shell printf "%04d\n" `cat z-slice.lst`)
z-slice_lst:= $(z-slice_num:%=plane-G_z@%.png)
planes_z:= $(z-slice_num:%=z@%.png)
planes-g:= $(planes_z:%=$(SRV_G)_%) $(SRV_G)_x@0250.png $(SRV_G)_y@0250.png
planes-G:= $(planes_z:%=plane-G_%) plane-G_x@0250.png plane-G_y@0250.png
planes-A:= $(planes_z:%=plane-A_%) plane-A_x@0250.png plane-A_y@0250.png
planes-B:= $(planes_z:%=plane-B_%) plane-B_x@0250.png plane-B_y@0250.png
planes-SRV2D:= $(planes-g) $(planes-A) $(planes-B)
planes-SRV2D:= $(planes-SRV2D:%=SRV2D/%)

planes:= $(z-slice_num:%=xy-plane_%)
planes+= yz-plane
planes+= xz-plane
plane_VTPs:= $(planes:%=%.vtp)
plane_X3Ds:= $(planes:%=%.x3d)

fig_SRV-curved_PNGs= $(shell echo fig_SRV-curved_{0..4}.png)


SPACE := $(eval) $(eval)
basen = $(subst $(SPACE),_,$(filter-out $(lastword $(subst _, ,$1)),$(subst _, ,$1)))


.PHONY: all clean

all:  $(planes-G) $(planes-A) $(planes-B) \
  vis_SRV-curved.png vis_SRV-straightened.png vis_SRV-curved.blend \
  Makefile.dot.svg Makefile.neato.svg Makefile.twopi.svg \
  vis_SRV-curved.blend.Makefile.neato.dot vis_SRV-curved.blend.Makefile.neato.svg \
  $(fig_SRV-curved_PNGs)

clean:
	@rm -vf $(planes-G) $(planes-A) $(planes-B) $(plane_VTPs) $(plane_X3Ds) \
		$(SRV_G).mha $(SRV_A).mha $(SRV_B).mha extent.mha \
		$(SRV_G)_[xyz]@[0-9]*.png $(SRV_A)_[xyz]@[0-9]*.png $(SRV_B)_[xyz]@[0-9]*.png \
		vis_SRV-curved.png vis_SRV-curved.svg vis_SRV-curved.pvsm vis_SRV-curved.blend vis_SRV-curved.blend[0-9] vis_SRV-straightened.png vis_SRV-straightened.svg vis_SRV-straightened.pvsm \
		vis_SRV-curved_ori-axes.png vis_SRV-straightened_ori-axes.png LUT_{A,B}.png \
		Makefile.{dot,neato,twopi}.svg vis_SRV-curved.blend.Makefile.{dot,neato,twopi}.{dot,svg} \
		SRV2D/* # use -f not to fail on non-existing files
	@rm -vf $(fig_SRV-curved_PNGs) # fig_SRV-curved_[0-9].png
	@rmdir -v SRV2D/


%.x3d : %.vtp
	~/vtk/simple/build_vtk6_iana0/vtp2x3d  $^ $@


##Begin bg

$(SRV_G).mha: ../$(SRV_G).mha #from ~/itk/itk-vtk_CLIs/build_itk4_iana0/straighten kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1.mha   kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_A+B_wsmXm_A+B_rep10_B_obp+10+0_kNo+2_op+500+0_MAX_ROI900_op+5.5+0_mps+0-1+0.331662_04.vtp   $(SRV_G).mha 0 500 500 0.331662 2   $(SRV_G)  0   $(z-slice_num)
	ln -s ../$(SRV_G).mha .




plane-G_%.png: $(SRV_G)_%.png
	$(eval sep=$(subst @, ,$*))
	$(eval normal= $(word 1, $(sep)))
	$(eval sliceN= $(word 2, $(sep)))

# http://stackoverflow.com/questions/11994029/makefile-ifeq-when-are-they-evaluated
	@if [ "$(normal)" == "z" ]; then \
	   echo "Doing z-normal" ; \
	   mogrify  -flip  $(SRV_G)_$(normal)@$(sliceN).png ; \
	else \
	   echo "Doing other normal" ; \
	   mogrify  -rotate 270  $(SRV_G)_$(normal)@$(sliceN).png ; \
	fi

	convert $(SRV_G)_$(normal)@$(sliceN).png -level ,60%  plane-G_$(normal)@$(sliceN).png


##End bg


##Begin ov-A

LUT_A.png:
	convert -size 10x136 gradient:#0f0-#010 -size 10x89 gradient:#0ff-#011 -append -background black -splice  0x1 -transparent black  LUT_A.png # best green to black and cyan to black such that shielded regions are darker
#	convert -size 10x136 gradient:#080-#080 -size 10x89 gradient:#0f0-#0f0 -append -background black -splice  0x1 -transparent black  LUT_A.png # only bright and dark green to reduce confusion of readers


$(SRV_A).mha: ../$(SRV_A).mha
	ln -s ../$(SRV_A).mha .


plane-A_%.png: LUT_A.png $(SRV_A)_%.png
	$(eval sep=$(subst @, ,$*))
	$(eval normal= $(word 1, $(sep)))
	$(eval sliceN= $(word 2, $(sep)))

	$(eval opts= $(shell if [ "$(normal)" == "z" ]; then  echo "-flip"; else echo "-rotate 270" ; fi))

	convert $(SRV_A)_$(normal)@$(sliceN).png  LUT_A.png  -fx 'v.p{0,u.p*v.h*QuantumRange/2249}' -transparent black $(opts) -depth 8 plane-A_$(normal)@$(sliceN).png


##End ov-A


##Begin ov-B

LUT_B.png:
#	convert -size 10x270 gradient:#f00-#00f  -background '#f44' -splice  0x1  -background '#800' -splice  0x1  -background black -splice  0x1 -transparent black  LUT_B.png # add a bright red and a dark red as extra levels
	convert -size 10x270 gradient:#f00-#00f  -background '#f00' -splice  0x1  -background '#800' -splice  0x1  -background black -splice  0x1 -transparent black  LUT_B.png # add a red and a dark red as extra levels

$(SRV_B).mha: ../$(SRV_B).mha
	ln -s ../$(SRV_B).mha .


plane-B_%.png: LUT_B.png $(SRV_B)_%.png
	$(eval sep=$(subst @, ,$*))
	$(eval normal= $(word 1, $(sep)))
	$(eval sliceN= $(word 2, $(sep)))

	$(eval opts= $(shell if [ "$(normal)" == "z" ]; then  echo "-flip"; else echo "-rotate 270" ; fi))

	convert $(SRV_B)_$(normal)@$(sliceN).png  LUT_B.png  -fx 'v.p{0,u.p*v.h*QuantumRange/270}' -transparent black $(opts) -depth 8 plane-B_$(normal)@$(sliceN).png


##End ov-B


$(plane_VTPs) : #../$@ # with dependencies always gets exectued
	ln -fs  ../$@ . #from ~/itk/itk-vtk_CLIs/build_itk4_iana0/straighten kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1.mha   kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1_A+B_wsmXm_A+B_rep10_B_obp+10+0_kNo+2_op+500+0_MAX_ROI900_op+5.5+0_mps+0-1+0.331662_04.vtp   $(SRV_G).mha 0 500 500 0.331662 2   $(SRV_G)  0   $(z-slice_num)

vis_SRV-curved.png vis_SRV-curved.svg vis_SRV-curved_ori-axes.png vis_SRV-curved.pvsm : $(planes-G) $(planes-A) $(planes-B) $(plane_VTPs)
	/opt/paraview-git/bin/pvpython ~/paraview/scripts/vis_SRV-curved.py -s vis_SRV-curved -o vis_SRV-curved.pvsm #vglrun prevents? resize for ss
	mogrify -trim -level ,70% vis_SRV-curved.png
	mogrify -trim -transparent white vis_SRV-curved_ori-axes.png

vis_SRV-curved.blend : $(planes-G) $(planes-A) $(planes-B) $(plane_X3Ds)
	~/programme/blender/blender -b   -P ~/blender_scripts/vis_SRV-curved.py -- -o vis_SRV-curved.blend
	rm vis_SRV-curved.blend1 # not sure what in the blender script causes a backup save


extent.mha:
	ln -fs ../extent.mha .

vis_SRV-straightened.png vis_SRV-straightened.svg vis_SRV-straightened_ori-axes.png vis_SRV-straightened.pvsm : $(planes-G) $(planes-A) $(planes-B) extent.mha vis_SRV-curved.png #vis_SRV-curved.png added to avoid multiple renders at the same time which can cause missing OVs in ss
	/opt/paraview-git/bin/pvpython ~/paraview/scripts/vis_SRV-straightened.py -s vis_SRV-straightened -o vis_SRV-straightened.pvsm
	mogrify -trim -level ,70% vis_SRV-straightened.png
	mogrify -trim -transparent white vis_SRV-straightened_ori-axes.png


Makefile.%.svg :
	make -Bnd | ~/programme/makefile2graph/make2graph -s | $* -Tsvg -o $@

vis_SRV-curved.blend.Makefile.%.dot :
	make -Bnd vis_SRV-curved.blend | ~/programme/makefile2graph/make2graph -s > $@

vis_SRV-curved.blend.Makefile.%.svg : vis_SRV-curved.blend.Makefile.%.dot
	$* -Tsvg -o $@ $<

SRV2D/ :
	mkdir $@

SRV2D/% : % | SRV2D/ # https://www.gnu.org/software/make/manual/html_node/Prerequisite-Types.html
	cp -a $* $@ # copy better for production, just mv/cp SRV2D/ to latex-image-dir
#	ln -sf ../$* $@

fig_SRV2D.svg : $(planes-SRV2D)
	@echo "changed files: " $?
	touch fig_SRV2D.svg # https://www.gnu.org/software/make/manual/html_node/Empty-Targets.html#Empty-Targets

fig_SRV-curved_%.png : fig_SRV-curved.blend vis_SRV-curved.blend ../A.blend ../V.blend ../Bt.blend ../Arz.blend ../Arz_dec+0.blend
	~/programme/blender/blender -b fig_SRV-curved.blend -noaudio -o fig_SRV-curved_#.png -F PNG -f $*

#prevent removal of any intermediate files http://stackoverflow.com/questions/5426934/why-this-makefile-removes-my-goal https://www.gnu.org/software/make/manual/html_node/Chained-Rules.html
#.SECONDARY: # $(SRV_G)_[xyz]@[0-9]*.png #not working
.PRECIOUS: $(planes-g) # $(SRV_G)_%.png #not working, might need newer version of make

.SECONDEXPANSION:

%.png: $$(call basen,%).mha
	@echo "process $+ to $*"
	$(eval pos= $(subst $(basename $+),,$*))
	$(eval pos= $(subst _,,$(pos)))

	$(eval sep= $(subst @, ,$(pos)))
	$(eval normal= $(word 1, $(sep)))
	$(eval sliceN= $(word 2, $(sep)))

	$(eval type= $(shell if [ "$(basename $+)" == "$(SRV_G)" ]; then  echo "uchar"; else echo "ushort" ; fi))

	/opt/convert3d/bin/c3d $+ -slice $(normal) $(sliceN)  -type $(type) -o $@

