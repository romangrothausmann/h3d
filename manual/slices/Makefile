
ifeq (3.81,$(lastword $(sort $(MAKE_VERSION) 3.81))) # https://lists.gnu.org/archive/html/help-make/2006-04/msg00067.html
$(error Version of make too old! ($(MAKE_VERSION) <= 3.81))
endif

SHELL:= /bin/bash
GVmake=$(MAKE) #any line with $(MAKE) gets exectued even with -n, GVmake should merely be used for makefile-visualization to avoid its execution with -n

## run IM tools without setting cration and modification date (or -strip) to avoid changes in PNGs that are not visual: http://stackoverflow.com/questions/13577280/getting-imagemagick-convert-to-not-write-out-extra-info
convertIM:= convert +set date:create +set date:modify
mogrifyIM:= mogrify +set date:create +set date:modify

SPACE := $(eval) $(eval)
base_ = $(subst $(SPACE),_,$(filter-out $(lastword $(subst _, ,$1)),$(subst _, ,$1)))
base. = $(subst $(SPACE),.,$(filter-out $(lastword $(subst ., ,$1)),$(subst ., ,$1)))

ITKDIR = ~/itk/simple/build_itk4_iana0

fig_histo_3D-sliced+seg_PNGs= BG_x@0838.png BG_y@1624.png BG_z@0688_sb.png OV1_LUT_x@0838.png OV1_LUT_y@1624.png OV1_LUT_z@0688.png 3D-OV.png
fig_histo_3D-sliced+seg_PNGs:= $(addprefix fig_histo_3D-sliced+seg/,$(fig_histo_3D-sliced+seg_PNGs))

.PHONY: all clean

all: fig_histo_3D-sliced+seg.svg fig_histo_3D-sliced+seg.svg.neato.Make.svg fig_histo_3D-sliced+seg.svg.fdp.Make.svg

clean:
	@-rm -v BG_x@0838.png BG_y@1624.png BG_z@0688.png OV1_LUT_x@0838.png OV1_LUT_y@1624.png OV1_LUT_z@0688.png LUT.png
	@-rm -v fig_histo_3D-sliced+seg.svg fig_histo_3D-sliced+seg/*
	@-rmdir -v fig_histo_3D-sliced+seg/
	@-rm -v fig_histo_3D-sliced+seg.svg.gv fig_histo_3D-sliced+seg.svg.neato.Make.svg fig_histo_3D-sliced+seg.svg.fdp.Make.svg

% :: %.gz # try decompress-first rule https://www.gnu.org/software/make/manual/html_node/Match_002dAnything-Rules.html#Match_002dAnything-Rules  https://www.gnu.org/software/make/manual/html_node/Double_002dColon.html#Double_002dColon
	unpigz -v -k -- $<


# %.mha : ../%.mha
# 	ln -sf ../$@ .

LUT.png :
	$(convertIM) xc:#000 xc:#f00 xc:#0f0 xc:#00f -append -transparent black $@

OV1_LUT_%.png : OV1_%.png LUT.png
#	$(eval opts=-rotate 270)
	$(convertIM) $<  LUT.png  -fx "v.p{0,u.p*2^`$(convertIM) $< -format '%z' info:`}" -transparent black $(opts) $@ # p in [0;1], QuantumRange==IM's max bit depth (see Qxx in convert -version), u.depth should work but does not and is very slow

%_sb.png : %.png
	mv $< $@ # this should be replaced by cmds creating sb, e.g. exiftool -SubjectPixelWidth %.ext.png + convert -gravity SouthEast -stroke ${colour} -strokewidth ${strokewidth} -draw "line ${bh},${uy},${scalebar},${uy}" 

fig_histo_3D-sliced+seg/ :
	mkdir -p $@

fig_histo_3D-sliced+seg/%.png : %.png | fig_histo_3D-sliced+seg/
## if needed due to new shortest stem matching rule: http://stackoverflow.com/questions/9301669/gnumake-and-pattern-rules  https://lists.gnu.org/archive/html/info-gnu/2010-07/msg00023.html
	@if [ "$*" == "3D-OV" ]; then \
	   cp $*.png $@ ; \
	else \
	   mv $*.png $@ ; \
	fi

fig_histo_3D-sliced+seg.svg : $(fig_histo_3D-sliced+seg_PNGs)
	sed 's$$xlink:href="file:///myURL/$$xlink:href="fig_histo_3D-sliced+seg/$$g' < fig_base.svg > $@
	@echo "changed files: " $?
	touch $@



## below a rule with "make", a very special case for NOT using $(MAKE) or +make
### lines that contain "$(MAKE)" even in a comment get exectued even with -n|--dry-run !!!
%.gv : % Makefile $(MAKEFILES) # put % to get executed after target has been made to avoid make2graph error due to missing files; http://www.gnu.org/software/make/manual/make.html#MAKEFILES-Variable
	$(GVmake) -Bnd $* | ~/programme/makefile2graph/make2graph | sed 's/label=".*_\([^_\.]\+\)\.[^\.]*"/label="\1"/g' > $@ # DO NOT PUT a comment with make-var here

#.SECONDARY:

.SECONDEXPANSION: # https://www.gnu.org/software/make/manual/html_node/Secondary-Expansion.html

%.png : $$(call base_,%).mha # even though functions are expanded immediately, this needs to be in SECONDEXPANSION for % to be expanded: http://stackoverflow.com/questions/9526295/how-to-call-functions-within-order-only-prerequisites#9533980
	@echo "process $+ to $*"
	$(eval pos= $(subst $(basename $+),,$*))
	$(eval pos= $(subst _,,$(pos)))

	$(eval sep= $(subst @, ,$(pos)))
	$(eval normal= $(word 1, $(sep)))
	$(eval sliceN= $(word 2, $(sep)))

	$(ITKDIR)/slice $+ $@ 0 $(normal) $(sliceN)


%.Make.svg : $$(call base.,%).gv # rule should be more specific than %.svg!
	$(eval pos= $(subst $(basename $+),,$*))
	$(eval pos= $(subst .,,$(pos)))

	$(pos) -Tpng -o $@ $<

