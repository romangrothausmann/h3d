
### setting default paths of external programs
BLENDER?=/opt/blender-2.76b


SHELL:= /bin/bash


export PATH:= $(BLENDER):$(PATH)



## run IM tools without setting cration and modification date (or -strip) to avoid changes in PNGs that are not visual: http://stackoverflow.com/questions/13577280/getting-imagemagick-convert-to-not-write-out-extra-info
## some bug now needs even more default options: http://unix.stackexchange.com/questions/255252/create-the-same-png-with-imagemagick-2-times-binaries-differ#255256
convertIM:= convert -define png:exclude-chunks=date,time +set date:create +set date:modify
mogrifyIM:= mogrify -define png:exclude-chunks=date,time +set date:create +set date:modify



fig_ov01_PNGs= $(shell echo fig_ov01_{1..6}.png)
fig_ov01_PNGs:= $(addprefix fig_ov01/,$(fig_ov01_PNGs))

fig_A2V_PNGs= $(shell echo fig_A2V_{1..6}.png)
fig_A2V_PNGs:= $(addprefix fig_A2V/,$(fig_A2V_PNGs))

.PHONY: all clean video

all : fig_ov01.svg fig_A2V.svg 

video : A2V.mp4 Bt2A45.mp4 V2A_ov.mp4 A452Bt.mp4 A2V-reversed.mp4
	$(MAKE) -C ani_comb/


% :: %.gz # try decompress-first rule https://www.gnu.org/software/make/manual/html_node/Match_002dAnything-Rules.html#Match_002dAnything-Rules  https://www.gnu.org/software/make/manual/html_node/Double_002dColon.html#Double_002dColon
	unpigz -v -k -- $<

%.gz : %
	pigz -v -- $< 


%.blend : ../../processing/%.blend
	ln -fs $< $@


.PHONY : ACN-Arz.blend
ACN-Arz.blend : ACN-Arz_0.blend ACN-Arz_1.blend ACN-Arz_2.blend ACN-Arz_3.blend

A2V.blend A2V-reversed.blend : A+V+ACN-path_dec.blend
fig_ov01.blend V2A_ov.blend Bt2A45.blend A452Bt.blend A2V.blend A2V-reversed.blend fig_A2V.blend cover.blend : A+V+ACN-path.blend
fig_ov01.blend V2A_ov.blend Bt2A45.blend A452Bt.blend cover.blend : A.blend V.blend Bt.blend Arz.blend Arz_dec.blend ACN-Arz.blend ACN-Bt.blend
Bt2A45.blend V2A_ov.blend A452Bt.blend : ACN-a45.blend
cover.blend : h3d_rsi+1+1.0.raw

%.mhd %.raw : ../../processing/%.mha
	file_converter $< $*.mhd 0

A2V-reversed.mp4 : A2V.mp4 Bt2A45.mp4 V2A_ov.mp4 A452Bt.mp4 # make A2V-reversed.mp4 after all others

A2V/render_000000.png : A2V.blend # 000000 not replaced by % to avoid multiple execution of rule
	$(SUBDIR)/blender/blender-multi $< $(dir $@)    0 5000 4

A2V-reversed/render_000000.png : A2V-reversed.blend # 000000 not replaced by % to avoid multiple execution of rule
	$(SUBDIR)/blender/blender-multi $< $(dir $@)    0 5000 4

# V2A.mp4 : A2V-reversed/render_005000.png
# #	$(file >$@,$^) #needs at least make 3.82
# 	@ls -1r A2V-reversed/*.png > A2V-reversed/$@.flist
# 	@echo A2V-reversed/$@.flist created
# 	mencoder mf://@A2V-reversed/$@.flist -o A2V-reversed/$@  -ovc x264 -x264encopts preset=veryslow:fast_pskip=0:tune=film:frameref=15:bitrate=3000:threads=auto:pass=1  -fps 25 && \
# 	mencoder mf://@A2V-reversed/$@.flist -o A2V-reversed/$@  -ovc x264 -x264encopts preset=veryslow:fast_pskip=0:tune=film:frameref=15:bitrate=3000:threads=auto:pass=2  -fps 25

# 	ln -sf A2V-reversed/$@ .
# 	rm divx2pass.log divx2pass.log.mbtree


V2A_ov/render_000000.png : V2A_ov.blend # 000000 not replaced by % to avoid multiple execution of rule
	$(SUBDIR)/blender/blender-multi $< $(dir $@)    0 1550 3
#	$(SUBDIR)/blender/blender-multi $< $(dir $@)    0  499 3 # V exit till ACN-Bt appearance
#	$(SUBDIR)/blender/blender-multi $< $(dir $@) 1510 1550 3 # A entry
#	$(SUBDIR)/blender/blender-multi $< $(dir $@)  800 1509 3 # all there (~3min per frame)
#	$(SUBDIR)/blender/blender-multi $< $(dir $@)  500  599 5 # ACN-Bt appearance (~37GB RAM 14%, ~7min per frame)
#	$(SUBDIR)/blender/blender-multi $< $(dir $@)  600  699 3 # ACN-Arz appearance (~72GB RAM 27%, ~40min per frame)
#	$(SUBDIR)/blender/blender-multi $< $(dir $@)  700  799 5 # Arz appearance (~41GB RAM 16%, ~1h per frame)

A452Bt/render_000000.png : A452Bt.blend # 000000 not replaced by % to avoid multiple execution of rule
	$(SUBDIR)/blender/blender-multi $< $(dir $@)    0 3000 4

Bt2A45/render_000000.png : Bt2A45.blend # 000000 not replaced by % to avoid multiple execution of rule
	$(SUBDIR)/blender/blender-multi $< $(dir $@)    0 4600 4

%.ass : ../processing/default.ass
	ln -sf $< $@

%.mp4 : %/render_000000.png %.ass
	mencoder mf://$*/*.png -o $*/_$@  -ovc x264 -x264encopts preset=veryslow:fast_pskip=0:tune=film:frameref=15:bitrate=3000:threads=auto:pass=1  -fps 25 && \
	mencoder mf://$*/*.png -o $*/_$@  -ovc x264 -x264encopts preset=veryslow:fast_pskip=0:tune=film:frameref=15:bitrate=3000:threads=auto:pass=2  -fps 25 -ass -sub $*.ass

	ffmpeg -y -i $*/_$@ -vcodec copy -acodec copy -movflags +faststart $*/$@ # -movflags must appear after -i !!! ffmpeg -f image2 -i $*/render_%06d.png -movflags +faststart */$@ # -f image2 does not regard -movflags re-enc is needed!

	ln -sf $*/$@ .
	rm divx2pass.log divx2pass.log.mbtree

%.avi : %/render_000000.png %.ass
	mencoder mf://$*/*.png -o $*/$@  -ovc lavc -lavcopts vcodec=msmpeg4v2:vhq:vbitrate=24000000:vpass=1  -fps 25 && \
	mencoder mf://$*/*.png -o $*/$@  -ovc lavc -lavcopts vcodec=msmpeg4v2:vhq:vbitrate=24000000:vpass=2  -fps 25 -ass -sub $*.ass

	ln -sf $*/$@ .
	-rm divx2pass.log

%_1min.avi : %/render_000000.png %.ass
	mencoder mf://$*/*.png -o $*/$@  -ovc lavc -lavcopts vcodec=msmpeg4v2:vhq:vbitrate=24000000:vpass=1  -fps 25 -frames 2500 -speed 1.6 && \
	mencoder mf://$*/*.png -o $*/$@  -ovc lavc -lavcopts vcodec=msmpeg4v2:vhq:vbitrate=24000000:vpass=2  -fps 25 -frames 2500 -speed 1.6 -ass -sub $*.ass

	ln -sf $*/$@ .
	-rm divx2pass.log


fig_ov01/ :
	+mkdir -p $@

fig_ov01/fig_ov01_%.png : fig_ov01.blend | fig_ov01/
	touch $@.stime
	blender -b $< -o fig_ov01/$(basename $<)_#.png -noaudio -F PNG -f $* # -o $@ does not work
	@if [ "$*" -ge 5 -a "$*" -le 6 ]; then \
	   $(mogrifyIM) -gravity Center -crop 1280x800+0+0 +repage $@ ; \
	fi # a separate rule like fig_ov01_5.png fig_ov01_6.png : ; $(mogrifyIM) -gravity Center -crop 1280x800+0+0 +repage $@  does not work because multiple dependencies but only one rule: http://stackoverflow.com/questions/22127119/gnu-make-warning-ignoring-old-commands-for-target-xxx#22127172  https://www.gnu.org/software/make/manual/html_node/Secondary-Expansion.html

fig_ov01.svg : $(fig_ov01_PNGs)
	@echo "changed files: " $?
	touch $@


cover.png : cover.blend
	touch $@.stime
	blender -b $< -o $(basename $@)_######.png -noaudio -F PNG -f 1 # -o $@ does not work
	mv -f $(basename $@)_000001.png $@ # remove frame number ending

fig_A2V/ :
	+mkdir -p $@

fig_A2V/fig_A2V_1.png : A2V.blend | fig_A2V/
	touch $@.stime
	blender -b $< -o $(basename $@)_######.png -noaudio -F PNG -f  555 # -o $@ does not work
	mv -f $(basename $@)_000555.png $@ # remove frame number ending

fig_A2V/fig_A2V_3.png : A2V.blend | fig_A2V/
	touch $@.stime
	blender -b $< -o $(basename $@)_######.png -noaudio -F PNG -f 2900 # -o $@ does not work
	mv -f $(basename $@)_002900.png $@ # remove frame number ending

fig_A2V/fig_A2V_5.png : A2V.blend | fig_A2V/
	touch $@.stime
	blender -b $< -o $(basename $@)_######.png -noaudio -F PNG -f 4550 # -o $@ does not work
	mv -f $(basename $@)_004550.png $@ # remove frame number ending

fig_A2V/fig_A2V_2.png : A2V-reversed.blend | fig_A2V/
	touch $@.stime
	blender -b $< -o $(basename $@)_######.png -noaudio -F PNG -f  676 # -o $@ does not work
	mv -f $(basename $@)_000676.png $@ # remove frame number ending

fig_A2V/fig_A2V_4.png : A2V-reversed.blend | fig_A2V/
	touch $@.stime
	blender -b $< -o $(basename $@)_######.png -noaudio -F PNG -f 2881 # -o $@ does not work
	mv -f $(basename $@)_002881.png $@ # remove frame number ending

fig_A2V/fig_A2V_6.png : A2V-reversed.blend | fig_A2V/
	touch $@.stime
	blender -b $< -o $(basename $@)_######.png -noaudio -F PNG -f 4200 # -o $@ does not work
	mv -f $(basename $@)_004200.png $@ # remove frame number ending

fig_A2V.svg : $(fig_A2V_PNGs)
	@echo "changed files: " $?
	touch $@



#prevent removal of any intermediate files http://stackoverflow.com/questions/5426934/why-this-makefile-removes-my-goal https://www.gnu.org/software/make/manual/html_node/Chained-Rules.html
.SECONDARY: 


.SERIAL: Bt2A45/render_000000.png V2A_ov/render_000000.png A452Bt/render_000000.png A2V/render_000000.png A2V-reversed/render_000000.png

