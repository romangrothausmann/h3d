
#### ToDo:

#### Done:
## rewrite (at least fig_SRV2D.svg and its SRV2D rules) from scratch, apparently there are overlapping dependencies since adding rules to move PNGs in SRV2D sub-folder; e.g. sometimes grey images for fig_SRV2D.svg do not get rotated sometimes all is fine, possibly depending on whether make -j12 starts with fig_SRV-curvedPV.svg  or  fig_SRV2D.svg
## check e.g. make -d -j12 fig_SRV2D.svg : did only work after run a second time, rules worked for some slices but not all. Why? Possibly a newer GNU-Make solves the problem
## figure out why PNGs have a direct dependence on MHAs, see e.g. connections between MHAs and PNGs in make fig_SRV2D.svg.twopi.svg fig_SRV2D.svg.dot.svg
## older version did not yield this connections! see e.g. vis_SRV-curved.blend.Makefile.neato.gephi.svg
## -> not a problem of make but its debug output used by make2graph: https://github.com/lindenb/makefile2graph/issues/12

SHELL:= /bin/bash
GVmake=$(MAKE) #any line with $(MAKE) gets exectued even with -n, GVmake should merely be used for makefile-visualization to avoid its execution with -n


## run IM tools without setting cration and modification date (or -strip) to avoid changes in PNGs that are not visual: http://stackoverflow.com/questions/13577280/getting-imagemagick-convert-to-not-write-out-extra-info
## some bug now needs even more default options: http://unix.stackexchange.com/questions/255252/create-the-same-png-with-imagemagick-2-times-binaries-differ#255256
convertIM:= convert -define png:exclude-chunks=date,time +set date:create +set date:modify
mogrifyIM:= mogrify -define png:exclude-chunks=date,time +set date:create +set date:modify # avoid mogrify as it likely leads to a kind of input : input rule, which can corrupt the Makefile

SRV_G:= h3d_srv+500+500+0.331662+2
SRV_A:= h3d_seg_Bt+Arz-fm_srv+500+500+0.331662+0
SRV_B:= h3d_seg_B-fm_srv+500+500+0.331662+0

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
plane_VTPs:= $(planes:%=%.vtp) # should not inclued yz- and xz-plane
planes+= yz-plane
planes+= xz-plane
plane_X3Ds:= $(planes:%=%.x3d) # should inclued yz- and xz-plane

fig_SRV-curved_PNGs= $(shell echo fig_SRV-curved_{0..4}.png)
fig_SRV-curved_PNGs:= $(addprefix fig_SRV-curved/,$(fig_SRV-curved_PNGs))


SPACE := $(eval) $(eval)
base_ = $(subst $(SPACE),_,$(filter-out $(lastword $(subst _, ,$1)),$(subst _, ,$1)))
base. = $(subst $(SPACE),.,$(filter-out $(lastword $(subst ., ,$1)),$(subst ., ,$1)))


.PHONY: all clean

all: fig_SRV-curvedPV.svg fig_SRV-straightenedPV.svg fig_SRV2D.svg $(fig_SRV-curved_PNGs) 

clean:
	@rm -vf $(planes-G) $(planes-A) $(planes-B) $(plane_VTPs) $(plane_X3Ds) \
		$(SRV_G).mha $(SRV_A).mha $(SRV_B).mha extent.mha \
		$(SRV_G)_[xyz]@[0-9]*.tif $(SRV_A)_[xyz]@[0-9]*.tif $(SRV_B)_[xyz]@[0-9]*.tif \
		vis_SRV-curved.png vis_SRV-curved.svg vis_SRV-curved.pvsm vis_SRV-curved.blend vis_SRV-curved.blend[0-9] vis_SRV-straightened.png vis_SRV-straightened.svg vis_SRV-straightened.pvsm \
		vis_SRV-curved_ori-axes.png vis_SRV-straightened_ori-axes.png LUT_{A,B}.png \
		{all,fig_SRV2D.svg,fig_SRV-curved.svg}.gv \
		all.{dot,neato,twopi,fdp}.svg fig_SRV2D.svg.{dot,neato,twopi,fdp}.svg fig_SRV-curved.svg.{dot,neato,twopi,fdp}.svg \
		fig_SRV-curved/* \
		fig_SRV-curvedPV/* \
		fig_SRV-straightenedPV/* \
		SRV2D/* # use -f not to fail on non-existing files
	@rm -vf $(fig_SRV-curved_PNGs) # fig_SRV-curved_[0-9].png
	@-rmdir -v fig_SRV-curved/
	@-rmdir -v fig_SRV-curvedPV/ #-: ignore error:  http://stackoverflow.com/questions/2989465/rm-rf-versus-rm-rf  http://stackoverflow.com/questions/2670130/make-how-to-continue-after-a-command-fails#2670143
	@-rmdir -v fig_SRV-straightenedPV/
	@-rmdir -v SRV2D/
	@-rm -v planeVTPs.done
	@-rm -v Bt.blend Arz.blend A.blend V.blend ACN-Arz_?.blend Arz_dec.blend fig_SRV-curved.svg


% :: %.gz # try decompress-first rule https://www.gnu.org/software/make/manual/html_node/Match_002dAnything-Rules.html#Match_002dAnything-Rules  https://www.gnu.org/software/make/manual/html_node/Double_002dColon.html#Double_002dColon
	unpigz -v -- $<


gv-fig_SRV2D : fig_SRV2D.svg.neato.svg fig_SRV2D.svg.fdp.svg fig_SRV2D.svg.dot.svg

gv-fig_SRV2D : fig_SRV-curved.svg.neato.svg fig_SRV-curved.svg.fdp.svg fig_SRV-curved.svg.dot.svg


%.x3d : %.vtp
	vtp2x3d  $^ $@


##Begin bg

$(SRV_G)%mha planeVTPs%done : ../../processing/h3d.mha ../../processing/demo-path.vtp
	touch $@.stime
	straighten $^  $(SRV_G).mha  0 500 500 0.331662 2  xy-plane   0   $(z-slice_num)
	touch planeVTPs.done

$(plane_VTPs) : planeVTPs.done # merely a trick to crate a pseudo dependence with a dot to use with % in rule above
	touch $@


plane-G_%.png : $(SRV_G)_%.tif
	$(eval sep=$(subst @, ,$*))
	$(eval normal= $(word 1, $(sep)))
	$(eval sliceN= $(word 2, $(sep)))

	$(eval opts= $(shell if [ "$(normal)" == "z" ]; then  echo "-flip"; else echo "-rotate 270" ; fi))

	$(convertIM) $< -level ,60% $(opts) $@

SRV2D/$(SRV_G)_%.png : $(SRV_G)_%.tif | SRV2D/
	$(eval sep=$(subst @, ,$*))
	$(eval normal= $(word 1, $(sep)))
	$(eval sliceN= $(word 2, $(sep)))

	$(eval opts= $(shell if [ "$(normal)" == "z" ]; then  echo "-flip"; else echo "-rotate 270" ; fi))
	$(convertIM) $< $(opts) $@

##End bg


##Begin ov-A

LUT_A.png:
	$(convertIM) -size 10x136 gradient:#0f0-#010 -size 10x89 gradient:#0ff-#011 -append -background black -splice  0x1 -transparent black  LUT_A.png # best green to black and cyan to black such that shielded regions are darker
#	$(convertIM) -size 10x136 gradient:#080-#080 -size 10x89 gradient:#0f0-#0f0 -append -background black -splice  0x1 -transparent black  LUT_A.png # only bright and dark green to reduce confusion of readers


$(SRV_A).mha: ../../processing/h3d_seg_Bt+Arz-fm.mha ../../processing/demo-path.vtp
	touch $@.stime
	straighten $^  $@  0 500 500 0.331662 0


plane-A_%.png: $(SRV_A)_%.tif LUT_A.png # order matters to IM
	$(eval sep=$(subst @, ,$*))
	$(eval normal= $(word 1, $(sep)))
	$(eval sliceN= $(word 2, $(sep)))

	$(eval opts= $(shell if [ "$(normal)" == "z" ]; then  echo "-flip"; else echo "-rotate 270" ; fi))

	$(convertIM) $^ -fx "v.p{0,u.p*v.h*2^`$(convertIM) $< -format '%z' info:`/2249}" -transparent black $(opts) -depth 8 plane-A_$(normal)@$(sliceN).png # as LUT is not 1:1, it needs to be scaled (*v.h) to actual maximum of the orig. 3D image (2249), u.depth should give the image depth but is slow and wrong (newer IM needed?), instead a previous call to IM is made


##End ov-A


##Begin ov-B

LUT_B.png:
#	$(convertIM) -size 10x270 gradient:#f00-#00f  -background '#f44' -splice  0x1  -background '#800' -splice  0x1  -background black -splice  0x1 -transparent black  LUT_B.png # add a bright red and a dark red as extra levels
	$(convertIM) -size 10x270 gradient:#f00-#00f  -background '#f00' -splice  0x1  -background '#800' -splice  0x1  -background black -splice  0x1 -transparent black  LUT_B.png # add a red and a dark red as extra levels

$(SRV_B).mha: ../../processing/h3d_seg_B-fm.mha ../../processing/demo-path.vtp
	touch $@.stime
	straighten $^  $@  0 500 500 0.331662 0


plane-B_%.png: $(SRV_B)_%.tif LUT_B.png # order matters to IM
	$(eval sep=$(subst @, ,$*))
	$(eval normal= $(word 1, $(sep)))
	$(eval sliceN= $(word 2, $(sep)))

	$(eval opts= $(shell if [ "$(normal)" == "z" ]; then  echo "-flip"; else echo "-rotate 270" ; fi))

	$(convertIM) $^  LUT_B.png  -fx "v.p{0,u.p*v.h*2^`$(convertIM) $< -format '%z' info:`/270}" -transparent black $(opts) -depth 8 plane-B_$(normal)@$(sliceN).png


##End ov-B

xz-plane.vtp : ../../processing/demo-path.vtp
	touch $@.stime
	ribbon_FrenetSerret $< $@ 0 82.9155 0

yz-plane.vtp : ../../processing/demo-path.vtp
	touch $@.stime
	ribbon_FrenetSerret $< $@ 0 82.9155 90


fig_SRV-curvedPV/%.png fig_SRV-curvedPV/%_ori-axes.png %.pvsm : $(planes-G) $(planes-A) $(planes-B) $(plane_VTPs) xz-plane.vtp yz-plane.vtp | fig_SRV-curvedPV/
	touch $@.stime
	vglrun pvpython ~/paraview/scripts/vis_SRV-curved.py -s $* -o $*.pvsm
	$(mogrifyIM) -trim -level ,70% $*.png
	$(mogrifyIM) -trim -transparent white $*_ori-axes.png
	mv $*.png $*_ori-axes.png fig_SRV-curvedPV/

vis_SRV-curved.blend : $(planes-G) $(planes-A) $(planes-B) $(plane_X3Ds)
	touch $@.stime
	blender -b   -P ~/blender/scripts/vis_SRV-curved.py -- -o vis_SRV-curved.blend
	rm vis_SRV-curved.blend1 # not sure what in the blender script causes a backup save


extent.mha : $(SRV_G).mha
	ln -fs $< $@

fig_SRV-straightenedPV/%.png fig_SRV-straightenedPV/%_ori-axes.png %.pvsm : $(planes-G) $(planes-A) $(planes-B) extent.mha vis_SRV-curved.pvsm | fig_SRV-straightenedPV/ #vis_SRV-curved.pvsm added to avoid multiple renders at the same time which can cause missing OVs in ss
	touch $@.stime
	vglrun pvpython ~/paraview/scripts/vis_SRV-straightened.py -s $* -o $*.pvsm
	$(mogrifyIM) -trim -level ,70% $*.png
	$(mogrifyIM) -trim -transparent white $*_ori-axes.png
	mv $*.png $*_ori-axes.png fig_SRV-straightenedPV/

fig_SRV-curved/ fig_SRV-curvedPV/ fig_SRV-straightenedPV/ SRV2D/ :
	+mkdir -p $@

SRV2D/%.png : %.png | SRV2D/ # https://www.gnu.org/software/make/manual/html_node/Prerequisite-Types.html
	cp $< $@

%.blend : ../../processing/%.blend
	ln -fs $< $@

fig_SRV-curved.blend : vis_SRV-curved.blend $(planes-G) $(planes-A) $(planes-B) Bt.blend Arz.blend A.blend V.blend ACN-Arz_0.blend ACN-Arz_1.blend ACN-Arz_2.blend ACN-Arz_3.blend Arz_dec.blend # vis_SRV-curved.blend does not include texture PNGs

fig_SRV-curved/fig_SRV-curved_%.png : fig_SRV-curved.blend | fig_SRV-curved/
	touch $@.stime
	blender -b $< -o //fig_SRV-curved/$(basename $<)_#.png -noaudio -F PNG -f $* # -o $@ does not work
	$(convertIM) $@ -gravity South -background white -splice 0x1 -background black -splice 0x1 -trim +repage -chop 0x1 -gravity North -background white -splice 0x1 -background black -splice 0x1 -trim +repage -chop 0x1 $@.png # mogrify shoud but does not know -splice : http://www.imagemagick.org/discourse-server/viewtopic.php?t=11344#p36577
	mv -f $@.png $@

fig_SRV-curved.svg : $(fig_SRV-curved_PNGs)
	@echo "changed files: " $?
	touch $@

fig_SRV-curvedPV.svg : fig_SRV-curvedPV/vis_SRV-curved.png fig_SRV-curvedPV/vis_SRV-curved_ori-axes.png
	@echo "changed files: " $?
	touch $@

fig_SRV-straightenedPV.svg : fig_SRV-straightenedPV/vis_SRV-straightened.png fig_SRV-straightenedPV/vis_SRV-straightened_ori-axes.png
	@echo "changed files: " $?
	touch $@

fig_SRV2D.svg : $(planes-SRV2D)
#	sed -i 's/h3d/$$(BASENAME)/g' fig_SRV2D_base.svg > $@
	@echo "changed files: " $?
	touch $@ # https://www.gnu.org/software/make/manual/html_node/Empty-Targets.html#Empty-Targets


## below a rule with "make", a very special case for NOT using $(MAKE) or +make
### lines that contain "$(MAKE)" even in a comment get exectued even with -n|--dry-run !!!
%.gv : % Makefile $(MAKEFILES) # put % to get executed after target has been made to avoid make2graph error due to missing files; http://www.gnu.org/software/make/manual/make.html#MAKEFILES-Variable
	$(GVmake) -Bnd $* | ~/programme/makefile2graph/make2graph | sed 's/label=".*_\([^_\.]\+\)\.[^\.]*"/label="\1"/g' > $@ # DO NOT PUT a comment with make-var here

#prevent removal of any intermediate files http://stackoverflow.com/questions/5426934/why-this-makefile-removes-my-goal https://www.gnu.org/software/make/manual/html_node/Chained-Rules.html
#.SECONDARY: # $(SRV_G)_[xyz]@[0-9]*.png #not working
.PRECIOUS:  %.gv # $(SRV_G)_%.png not working because $(SRV_G) is a list, $(addsuffix _%.png,$(SRV_G)) does not work because of %-eval, %.gv works

#.SERIAL: # not fig_SRV-curvedPV/vis_SRV-curved.png fig_SRV-straightenedPV/vis_SRV-straightened.png because non-PV-render processes are OK

.SECONDEXPANSION: # https://www.gnu.org/software/make/manual/html_node/Secondary-Expansion.html

%.tif: $$(call base_,%).mha # even though functions are expanded immediately, this needs to be in SECONDEXPANSION for % to be expanded: http://stackoverflow.com/questions/9526295/how-to-call-functions-within-order-only-prerequisites#9533980
	@echo "process $+ to $*"
	$(eval pos= $(subst $(basename $+),,$*))
	$(eval pos= $(subst _,,$(pos)))

	$(eval sep= $(subst @, ,$(pos)))
	$(eval normal= $(word 1, $(sep)))
	$(eval sliceN= $(word 2, $(sep)))

	slice $+ $@ 0 $(normal) $(sliceN) # ITK-slice much faster than c3d and SDI!

	@if [ "$(basename $+)" == "$(SRV_G)" ]; then \
	   echo "Doing G" ; \
	   toUInt8 $@ $@ 0 ; \
	else \
	   echo "Doing A|B" ; \
	   toUInt16 $@ $@ 0 ; \
	fi

#	stat $@


%.svg: $$(call base.,%).gv # %.svg : $(suffix $*).gv does not work, needs SECONDEXPANSION
	$(eval pos= $(subst $(basename $+),,$*))
	$(eval pos= $(subst .,,$(pos)))

	$(pos) -Tsvg -o $@ $<
