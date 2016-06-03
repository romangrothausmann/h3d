
SHELL:= /bin/bash
GVmake=$(MAKE) #any line with $(MAKE) gets exectued even with -n, GVmake should merely be used for makefile-visualization to avoid its execution with -n

BASENAME = h3d

## run IM tools without setting cration and modification date (or -strip) to avoid changes in PNGs that are not visual: http://stackoverflow.com/questions/13577280/getting-imagemagick-convert-to-not-write-out-extra-info
## some bug now needs even more default options: http://unix.stackexchange.com/questions/255252/create-the-same-png-with-imagemagick-2-times-binaries-differ#255256
convertIM:= convert -define png:exclude-chunks=date,time +set date:create +set date:modify
mogrifyIM:= mogrify -define png:exclude-chunks=date,time +set date:create +set date:modify

SPACE := $(eval) $(eval)
base_ = $(subst $(SPACE),_,$(filter-out $(lastword $(subst _, ,$1)),$(subst _, ,$1)))
base. = $(subst $(SPACE),.,$(filter-out $(lastword $(subst ., ,$1)),$(subst ., ,$1)))





fig_v-render_PNGs= fig_v-render_01_trim.png fig_v-render_02_oao_trim.png fig_v-render_02_trim.png fig_v-render_03_LE_trim.png fig_v-render_03_RE_trim.png


.PHONY: all clean


all : $(fig_v-render_PNGs) # all.neato.Make.svg all.fdp.Make.svg

clean :
	@-rm -v $(fig_v-render_PNGs) h3d.mha
	@-rm -v *.png

% :: %.gz # try decompress-first rule https://www.gnu.org/software/make/manual/html_node/Match_002dAnything-Rules.html#Match_002dAnything-Rules  https://www.gnu.org/software/make/manual/html_node/Double_002dColon.html#Double_002dColon
	unpigz -v -k -- $<

%.gz : %
	pigz -v -- $< 


h3d.mha : ../../processing/$(BASENAME).mha # *.pvsm refer to h3d.mha
	ln -sf $< $@

fig_v-render_%.png : fig_v-render_%.pvsm h3d.mha
	touch $@.stime
	$(VGLRUN) pvpython $(SUBDIR)/paraview/scripts/render-view.py  -s 1400 1400 -hq -i $< -png $@

fig_v-render_%_oao.png : fig_v-render_%.pvsm h3d.mha
	touch $@.stime
	$(VGLRUN) pvpython $(SUBDIR)/paraview/scripts/render-view.py  -s 1400 1400 -oao -i $< -png $@

fig_v-render_03_LE.png : fig_v-render_03.pvsm h3d.mha
	touch $@.stime
	$(VGLRUN) pvpython $(SUBDIR)/paraview/scripts/render-view.py  -s 1400 1024 -hq -oa -i $< -png $@ -LE

fig_v-render_03_RE.png : fig_v-render_03.pvsm h3d.mha
	touch $@.stime
	$(VGLRUN) pvpython $(SUBDIR)/paraview/scripts/render-view.py  -s 1400 1024 -hq -oa -i $< -png $@ -RE

%_trim.png : %.png
	$(convertIM) $< -trim $@


## below a rule with "make", a very special case for NOT using $(MAKE) or +make
### lines that contain "$(MAKE)" even in a comment get exectued even with -n|--dry-run !!!
%.gv : % Makefile $(MAKEFILES) # put % to get executed after target has been made to avoid make2graph error due to missing files; http://www.gnu.org/software/make/manual/make.html#MAKEFILES-Variable
	$(GVmake) -Bnd $* | make2graph | sed 's/label=".*_\([^_\.]\+\)\.[^\.]*"/label="\1"/g' > $@ # DO NOT PUT a comment with make-var here

#prevent removal of any intermediate files http://stackoverflow.com/questions/5426934/why-this-makefile-removes-my-goal https://www.gnu.org/software/make/manual/html_node/Chained-Rules.html
.SECONDARY: 

.SECONDEXPANSION: # https://www.gnu.org/software/make/manual/html_node/Secondary-Expansion.html

%.Make.svg : $$(call base.,%).gv # rule should be more specific than %.svg!
	$(eval pos= $(subst $(basename $+),,$*))
	$(eval pos= $(subst .,,$(pos)))

	$(pos) -Tpng -o $@ $<




