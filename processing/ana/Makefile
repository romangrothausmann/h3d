
SHELL:= /bin/bash
GVmake=$(MAKE) #any line with $(MAKE) gets exectued even with -n, GVmake should merely be used for makefile-visualization to avoid its execution with -n


SPACE := $(eval) $(eval)
base_ = $(subst $(SPACE),_,$(filter-out $(lastword $(subst _, ,$1)),$(subst _, ,$1)))
base. = $(subst $(SPACE),.,$(filter-out $(lastword $(subst ., ,$1)),$(subst ., ,$1)))


BN:= h3d
BNseg:= $(BN)_seg_T+B+a

ITKDIR:= ~/itk/simple/build_itk4_iana0
VTKDIR:= ~/vtk/simple/build_vtk6_iana0




.PHONY: all clean


all : V.csv Sc.csv So.csv # mask.csv all.neato.Make.svg all.fdp.Make.svg

clean :
	@-rm -v $(BNseg)* 
	@-rm -v *.csv
	@-rm -v all.*


% :: %.gz # try decompress-first rule https://www.gnu.org/software/make/manual/html_node/Match_002dAnything-Rules.html#Match_002dAnything-Rules  https://www.gnu.org/software/make/manual/html_node/Double_002dColon.html#Double_002dColon
	unpigz -v -k -- $<

%.gz : %
	pigz -v -- $< 


mask.mha : ../h3d_hull_02-seg.mha # must be the same as for luBounds! => use h3d_hull_02-seg (not $(BN)_seg_T+B+a@1.mha)
	ln -sf $< $@

$(BNseg).mha : ../$(BNseg).mha mask.mha # crop to mask
	$(ITKDIR)/mask $^ $@ 0

%_rs+1.0.mha : %.mha
	touch $@.stime
	$(ITKDIR)/resample $< $@ 1 0 1.0 1.0 1.0

%_B_raw.vtp %_B_sws.vtp : %.mha
	touch $@.stime
	$(VTKDIR)/discrete_marching-cubes $< $*_B 1 1 1

%_a_raw.vtp %_a_sws.vtp : %.mha
	touch $@.stime
	$(VTKDIR)/discrete_marching-cubes $< $*_a 2 2 1

# %_T_raw.vtp %_T_sws.vtp : %.mha # not possible @ 0.33 (crashes during SWS)
# 	touch $@.stime
# 	$(VTKDIR)/discrete_marching-cubes $< $*_T 3 3 1

%_o.vtp : %.vtp
	touch $@.stime
	$(VTKDIR)/threshold $< $@ 1 0 Scalars_ 1 3 0 # big files need compression OR writer->SetHeaderTypeToUInt64()

%_raw.vtp %_sws.vtp : %.mha # not possible @ 0.33 (crashes during SWS)
	touch $@.stime
	$(VTKDIR)/discrete_marching-cubes $< $* 1 3 1

%.ana : %.mha
	touch $@.stime
	$(ITKDIR)/analyse_labels $< 1 > $@

%.anaSV : %.vtp
	touch $@.stime
	$(VTKDIR)/analyse_S+V $< > $@

%_raw.anaSS : %_B_raw.anaSV %_a_raw.anaSV # %_T.anaS  not possible @ 0.33
	sed '3d' $^ > $@

%_sws.anaSS : %_B_sws.anaSV %_a_sws.anaSV # %_T.anaS  not possible @ 0.33
	sed '3d' $^ > $@

%_raw_o.anaSS : %_B_raw_o.anaSV %_a_raw_o.anaSV # %_T.anaS  not possible @ 0.33
	sed '3d' $^ > $@

%_sws_o.anaSS : %_B_sws_o.anaSV %_a_sws_o.anaSV # %_T.anaS  not possible @ 0.33
	sed '3d' $^ > $@

%_dc.mha : %.mha
	touch $@.stime
	$(ITKDIR)/file_converter $< $@ 0

%.anaJS : %_dc.mha
	touch $@.stime
	/opt/octave-4.0.0/bin/octave  ~/octave/scripts/jointSurf3D.m  $<  > $@

%.anaJJ : %.ana %.anaJS # need difference 
	paste $^ | awk '{if($$27==0){print $$25 - $$29}}' | sed '1i\\S' > $@

mask.raw.csv : mask.ana mask_rs+1.0.ana
	paste \
	<(awk '{print $$24}' $(word 1,$^)) \
	<(awk '{print $$24}' $(word 2,$^)) \
	| sed '1d' > $@ # process substitution;-) http://superuser.com/questions/317819/passing-two-arguments-to-a-command-using-pipes#317855  http://tldp.org/LDP/abs/html/process-sub.html

mask.csv : mask.raw.csv
	paste <(echo -ne 'mask') $< \
	| sed '1i\\tVvox0.3\tVvox1.0' > $@

V.raw.csv : $(BNseg).ana       $(BNseg)_rs+1.0.ana \
        $(BNseg)_raw.anaSS $(BNseg)_rs+1.0_raw.anaSV \
        $(BNseg)_sws.anaSS $(BNseg)_rs+1.0_sws.anaSV
	paste \
	<(awk '{print $$24}' $(word 1,$^)) \
	<(awk '{print $$24}' $(word 2,$^)) \
	<(awk '{print $$2}' $(word 3,$^)) \
	<(awk '{print $$2}' $(word 4,$^)) \
	<(awk '{print $$2}' $(word 5,$^)) \
	<(awk '{print $$2}' $(word 6,$^)) \
	| sed '1d' > $@ # process substitution;-) http://superuser.com/questions/317819/passing-two-arguments-to-a-command-using-pipes#317855  http://tldp.org/LDP/abs/html/process-sub.html

%.rsum.csv : %.raw.csv
	awk 'BEGIN{FS=OFS="\t"}{t=0; for(i=1;i<=NF;i++) t+=$$i; print $$0, t}' $< > $@

%.csum.csv : %.raw.csv
	octave -q <<< 'v= dlmread("$<", "\t"); s= sum(v); dlmwrite("$@", [v; s;  bsxfun(@rdivide, v, s)], "delimiter", "\t", "precision", 6);' # v./s == bsxfun(@rdivide, v, s); awk is only meant for row-wise eval

%.ravg.csv : %.csum.csv
	awk 'BEGIN{FS=OFS="\t"}{t=0; for(i=1;i<=NF;i++) t+=$$i; print $$0, t/NF}' $< > $@

V.csv : V.ravg.csv
	paste <(echo -ne 'B\nA\nT\ns\nB/s\nA/s\nT/s') $< \
	| sed '1i\\tVvox0.3\tVvox1.0\tVraw0.3\tVraw1.0\tVsws0.3\tVsws1.0\tavg' > $@


Sc.raw.csv : $(BNseg).ana       $(BNseg)_rs+1.0.ana \
         $(BNseg)_raw.anaSS $(BNseg)_rs+1.0_raw.anaSV \
         $(BNseg)_sws.anaSS $(BNseg)_rs+1.0_sws.anaSV
	paste \
	<(awk '{print $$25}' $(word 1,$^)) \
	<(awk '{print $$25}' $(word 2,$^)) \
	<(awk '{print $$3}' $(word 3,$^)) \
	<(awk '{print $$3}' $(word 4,$^)) \
	<(awk '{print $$3}' $(word 5,$^)) \
	<(awk '{print $$3}' $(word 6,$^)) \
	| sed '1d' > $@

So.raw.csv : $(BNseg).anaJJ       $(BNseg)_rs+1.0.anaJJ \
         $(BNseg)_raw_o.anaSS $(BNseg)_rs+1.0_raw_o.anaSV \
         $(BNseg)_sws_o.anaSS $(BNseg)_rs+1.0_sws_o.anaSV
	paste \
	$(word 1,$^) \
	$(word 2,$^) \
	<(awk '{print $$3}' $(word 3,$^)) \
	<(awk '{print $$3}' $(word 4,$^)) \
	<(awk '{print $$3}' $(word 5,$^)) \
	<(awk '{print $$3}' $(word 6,$^)) \
	| sed '1d' > $@

Sc.csv So.csv : %.csv : %.raw.csv
	paste <(echo -ne 'B\nA\nT') $< \
	| sed '1i\\tSvox0.3\tSvox1.0\tSraw0.3\tSraw1.0\tSsws0.3\tSsws1.0'> $@


## below a rule with "make", a very special case for NOT using $(MAKE) or +make
### lines that contain "$(MAKE)" even in a comment get exectued even with -n|--dry-run !!!
%.gv : % Makefile $(MAKEFILES) # put % to get executed after target has been made to avoid make2graph error due to missing files; http://www.gnu.org/software/make/manual/make.html#MAKEFILES-Variable
	$(GVmake) -Bnd $* | ~/programme/makefile2graph/make2graph | sed 's/label=".*_\([^_\.]\+\)\.[^\.]*"/label="\1"/g' > $@ # DO NOT PUT a comment with make-var here

#prevent removal of any intermediate files http://stackoverflow.com/questions/5426934/why-this-makefile-removes-my-goal https://www.gnu.org/software/make/manual/html_node/Chained-Rules.html
.SECONDARY: 

## just in case .SERIAL should get included in GNU-Make http://savannah.gnu.org/patch/index.php?5108
.SERIAL :  $(BNseg).anaJS $(BNseg)_rs+1.0.anaJS $(BNseg)_sws.vtp

.SECONDEXPANSION: # https://www.gnu.org/software/make/manual/html_node/Secondary-Expansion.html

%.Make.svg : $$(call base.,%).gv # rule should be more specific than %.svg!
	$(eval pos= $(subst $(basename $+),,$*))
	$(eval pos= $(subst .,,$(pos)))

	$(pos) -Tpng -o $@ $<




