
SHELL:= /bin/bash

BASEDIR = /raid5/sdb3/grothama/kap-net/histo-slices/kap-net_histo_reg/kap-net_histo_reg_8bit_rep_smROISBS_masked_m+3+3_rsi+1+0.331662

DIRs = Bt2Arz Arz2A45 A452V V2A A2A45 A452Bt

fBt2Arz  = $(shell echo render_{000000..002999}.png)
FBt2Arz  = $(fBt2Arz:%=Bt2Arz/%)

fArz2A45 = $(shell echo render_{000000..001590}.png)
FArz2A45 = $(fArz2A45:%=Arz2A45/%)

fA452V   = $(shell echo render_{002417..004939}.png)
FA452V   = $(fA452V:%=A452V/%)

fV2A     = $(shell echo render_{000001..001549}.png)
FV2A     = $(fV2A:%=V2A/%)

fA2A45   = $(shell echo render_{000048..002061}.png)
FA2A45   = $(fA2A45:%=A2A45/%)

fA452Bt  = $(shell echo render_{000001..003000}.png)
FA452Bt  = $(fA452Bt:%=A452Bt/%)

Fall=  $(FBt2Arz) $(FArz2A45) $(FA452V) $(FV2A) $(FA2A45) $(FA452Bt)

.PHONY: all clean mkDIRs rmDIRs popArz2A45 popA452V


all: kap-net_full.mp4

clean:
	rm -r $(DIRs) *.flist divx2pass.log divx2pass.log.mbtree


# %/ :
# 	mkdir $@


Bt2Arz/render%.png : $(BASEDIR)/virt_endo2/ani04/render%.png
	@mkdir -p $(dir $@)
	@cp -av $< $(dir $@)

Arz2A45/render%.png : $(BASEDIR)/virt_endo3/ani03/render%.png
	@mkdir -p $(dir $@) # http://stackoverflow.com/questions/99132/how-to-prevent-directory-already-exists-error-in-a-makefile-when-using-mkdir
	@cp -av $< $(dir $@)

A452V/render%.png : $(BASEDIR)/virt_endo/A2V_37/render%.png
	@mkdir -p $(dir $@)
	@cp -av $< $(dir $@)

V2A/render%.png : $(BASEDIR)/virt_endo3/V2A_ov2_15/render%.png
	@mkdir -p $(dir $@)
	@cp -av $< $(dir $@)

A2A45/render%.png : $(BASEDIR)/virt_endo/A2V_37/render%.png
	@mkdir -p $(dir $@)
	@cp -av $< $(dir $@)

A452Bt/render%.png : $(BASEDIR)/virt_endo3/Arz_CO2_ov3_10/render%.png
	@mkdir -p $(dir $@)
	@cp -av $< $(dir $@)

%.flist: $(Fall)
#	$(file >$@,$^) #needs at least make 3.82
#	@echo $^ | sed 's/ /\n/g' > $@ # Argument list too long
#	@echo > $@ <<EOF $^ # Argument list too long
	@echo $(FBt2Arz) | sed 's/ /\n/g' > $@
	@echo $(FArz2A45) | sed 's/ /\n/g' >> $@
	@echo $(FA452V) | sed 's/ /\n/g' >> $@
	@echo $(FV2A) | sed 's/ /\n/g' >> $@
	@echo $(FA2A45) | sed 's/ /\n/g' >> $@
	@echo $(FA452Bt) | sed 's/ /\n/g' >> $@
	@echo $@ created

%.mp4.1p %.2pass.log %.2pass.log.mbtree : %.flist
	mencoder mf://@$< -o $*.mp4.1p -ovc x264 -x264encopts preset=veryslow:fast_pskip=0:tune=film:frameref=15:bitrate=3000:threads=auto:pass=1  -fps 25 -passlogfile $*.2pass.log

%.mp4 : %.flist %.2pass.log %.2pass.log.mbtree
	mencoder mf://@$< -o $@        -ovc x264 -x264encopts preset=veryslow:fast_pskip=0:tune=film:frameref=15:bitrate=3000:threads=auto:pass=2  -fps 25 -passlogfile $*.2pass.log

	cp -v $@ ~/$@




# popArz2A45 : $(FArz2A45)
# popA452V : $(FA452V)

# mkDIRs :
# 	mkdir $(DIRs)

# rmDIRs :
# 	rmdir $(DIRs)


#prevent removal of any intermediate files http://stackoverflow.com/questions/5426934/why-this-makefile-removes-my-goal https://www.gnu.org/software/make/manual/html_node/Chained-Rules.html
.SECONDARY: 



