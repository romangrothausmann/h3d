
ifeq (3.81,$(lastword $(sort $(MAKE_VERSION) 3.81))) # https://lists.gnu.org/archive/html/help-make/2006-04/msg00067.html
$(error Version of make too old! ($(MAKE_VERSION) <= 3.81))
endif


SHELL:= /bin/bash

DIRs = Bt2A45 A2V V2A_ov A452Bt

fBt2A45  = $(shell echo render_{000000..004535}.png)
FBt2A45  = $(fBt2A45:%=Bt2A45/%)

fA452V   = $(shell echo render_{002373..004939}.png)
FA452V   = $(fA452V:%=A2V/%)

fV2A     = $(shell echo render_{000001..001549}.png)
FV2A     = $(fV2A:%=V2A_ov/%)

fA2A45   = $(shell echo render_{000048..002061}.png)
FA2A45   = $(fA2A45:%=A2V/%)

fA452Bt  = $(shell echo render_{000001..003000}.png)
FA452Bt  = $(fA452Bt:%=A452Bt/%)

Fall=  $(FBt2A45) $(FA452V) $(FV2A) $(FA2A45) $(FA452Bt)

.PHONY: all clean


all: h3d_full.mp4

clean:
	-rm -vf *.flist 
	-rm -vf *.2pass.log  *.2pass.log.mbtree *.mp4.1p *.mp4
	-rm -v $(DIRs) # DIRs are soft links

$(DIRs) : % : ../%
	@ln -s $< .

Bt2A45/render%.png : ../Bt2A45/render%.png
A2V/render%.png : ../A2V/render%.png
V2A_ov/render%.png : ../V2A_ov/render%.png
A452Bt/render%.png : ../A452Bt/render%.png

%.png : | $(DIRs)
	@test -f $@ || @echo "$@ missing."
	@echo "$@ exists."

%.flist : $(Fall)
#	$(file >$@) $(foreach O,$^,$(file >>$@,$O)) # segfaults with v4.0, works with v4.1
	$(file >$@,$^) # (file-) functions are even executed with -n
	+sed -i 's/ /\n/g' $@
	@echo $@ created

%.mp4.1p %.2pass.log %.2pass.log.mbtree : %.flist $(Fall)
	touch $@.stime
	mencoder mf://@$< -o $*.mp4.1p -ovc x264 -x264encopts preset=veryslow:fast_pskip=0:tune=film:frameref=15:bitrate=3000:threads=auto:pass=1  -fps 25 -passlogfile $*.2pass.log

%.mp4 : %.flist %.2pass.log %.2pass.log.mbtree
	touch $@.stime
	mencoder mf://@$< -o _$@        -ovc x264 -x264encopts preset=veryslow:fast_pskip=0:tune=film:frameref=15:bitrate=3000:threads=auto:pass=2  -fps 25 -passlogfile $*.2pass.log

	ffmpeg -y -i _$@ -vcodec copy -acodec copy -movflags +faststart $@ # -movflags must appear after -i !!! ffmpeg -f image2 -i $*/render_%06d.png -movflags +faststart */$@ # -f image2 does not regard -movflags re-enc is needed!


# %.mpg : %.flist
# 	mencoder -ovc lavc -of mpeg -mpegopts format=dvd:tsaf -vf-clr -srate 48000 -ofps 25 -lavcopts vcodec=mpeg2video:vpass=1:vrc_buf_size=1835:vrc_maxrate=8264:vbitrate=4500:keyint=15:trell:mbd=2:precmp=2:subcmp=2:cmp=2:dia=2:predia=2:o=mpv_flags=+cbp_rd+mv0:lmin=1:dc=10:acodec=ac3:abitrate=384:vstrict=0:aspect=16/9 -o $@  mf://@$<

# Bt2A45/ol_001550.png : Bt2A45/ol_001550.png
# #	mogrify -type Bilevel -alpha copy Bt2A45/ol_001550.png
# 	mogrify -colors 4 -type Palette -alpha copy  Bt2A45/ol_001550.png

# h3d_full_OL.mp4 : spumux.xml Bt2A45/ol_001550.png h3d_full.mp4
# # %_OL.mpg : %.xml %.ol-list %.mpg
# 	spumux -m svcd -s 0 -P $< < $(lastword $^) > $@


#prevent removal of any intermediate files http://stackoverflow.com/questions/5426934/why-this-makefile-removes-my-goal https://www.gnu.org/software/make/manual/html_node/Chained-Rules.html
.SECONDARY: 



