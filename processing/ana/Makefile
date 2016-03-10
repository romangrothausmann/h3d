
SHELL:= /bin/bash
GVmake=$(MAKE) #any line with $(MAKE) gets exectued even with -n, GVmake should merely be used for makefile-visualization to avoid its execution with -n


SPACE := $(eval) $(eval)
base_ = $(subst $(SPACE),_,$(filter-out $(lastword $(subst _, ,$1)),$(subst _, ,$1)))
base. = $(subst $(SPACE),.,$(filter-out $(lastword $(subst ., ,$1)),$(subst ., ,$1)))


BNseg:= h3d_seg_A+B+T

ITKDIR:= ~/itk/simple/build_itk4_iana0
VTKDIR:= ~/vtk/simple/build_vtk6_iana0




.PHONY: all clean


all : V.csv Sc.csv So.csv # all.neato.Make.svg all.fdp.Make.svg

clean :
	@-rm -v $(BNseg)* 
	@-rm -v *.csv
	@-rm -v all.*


% :: %.gz # try decompress-first rule https://www.gnu.org/software/make/manual/html_node/Match_002dAnything-Rules.html#Match_002dAnything-Rules  https://www.gnu.org/software/make/manual/html_node/Double_002dColon.html#Double_002dColon
	unpigz -v -k -- $<

%.gz : %
	pigz -v -- $< 


$(BNseg).mha : ../h3d_seg_A+B+T.mha
	ln -sf $< $@

%_rs+1.0.mha : ../h3d_rsi+1+1.0.mha
	ln -sf $< $@

%_B_raw.vtp %_B_sws.vtp : %.mha
	$(VTKDIR)/discrete_marching-cubes $< $*_B 1 1 1

%_A_raw.vtp %_A_sws.vtp : %.mha
	$(VTKDIR)/discrete_marching-cubes $< $*_A 2 2 1

# %_T_raw.vtp %_T_sws.vtp : %.mha # not possible @ 0.33 (crashes during SWS)
# 	$(VTKDIR)/discrete_marching-cubes $< $*_T 3 3 1

%_o.vtp : %.vtp
	$(VTKDIR)/threshold $< $@ 1 0 Scalars_ 1 3 0 # big files need compression OR writer->SetHeaderTypeToUInt64()

%_raw.vtp %_sws.vtp : %.mha # not possible @ 0.33 (crashes during SWS)
	$(VTKDIR)/discrete_marching-cubes $< $* 1 3 1

%.ana : %.mha
	$(ITKDIR)/analyse_labels $< 1 > $@

%.anaSV : %.vtp
	$(VTKDIR)/analyse_S+V $< > $@

%_raw.anaSS : %_B_raw.anaSV %_A_raw.anaSV # %_T.anaS  not possible @ 0.33
	sed '3d' $^ > $@

%_sws.anaSS : %_B_sws.anaSV %_A_sws.anaSV # %_T.anaS  not possible @ 0.33
	sed '3d' $^ > $@

%_raw_o.anaSS : %_B_raw_o.anaSV %_A_raw_o.anaSV # %_T.anaS  not possible @ 0.33
	sed '3d' $^ > $@

%_sws_o.anaSS : %_B_sws_o.anaSV %_A_sws_o.anaSV # %_T.anaS  not possible @ 0.33
	sed '3d' $^ > $@

%_dc.mha : %.mha
	$(ITKDIR)/file_converter $< $@ 0

%.anaJS : %_dc.mha
	/opt/octave-4.0.0/bin/octave  ~/octave/scripts/jointSurf3D.m  $<  > $@

%.anaJJ : %.ana %.anaJS # need difference 
	paste $^ | awk '{if($$27==0){print $$25 - $$29}}' | sed '1i\\S' > $@

V.csv : $(BNseg).ana       $(BNseg)_rs+1.0.ana \
        $(BNseg)_raw.anaSS $(BNseg)_rs+1.0_raw.anaSV \
        $(BNseg)_sws.anaSS $(BNseg)_rs+1.0_sws.anaSV
	paste <(echo -ne '# ANAs combined by paste\nB\nA\nT') \
	<(awk '{print $$24}' $(word 1,$^)) \
	<(awk '{print $$24}' $(word 2,$^)) \
	<(awk '{print $$2}' $(word 3,$^)) \
	<(awk '{print $$2}' $(word 4,$^)) \
	<(awk '{print $$2}' $(word 5,$^)) \
	<(awk '{print $$2}' $(word 6,$^)) \
	| sed '2i\\tVvox0.3\tVvox1.0\tVraw0.3\tVraw1.0\tVsws0.3\tVsws1.0'> $@ # process substitution;-) http://superuser.com/questions/317819/passing-two-arguments-to-a-command-using-pipes#317855  http://tldp.org/LDP/abs/html/process-sub.html

Sc.csv : $(BNseg).ana       $(BNseg)_rs+1.0.ana \
         $(BNseg)_raw.anaSS $(BNseg)_rs+1.0_raw.anaSV \
         $(BNseg)_sws.anaSS $(BNseg)_rs+1.0_sws.anaSV
	paste <(echo -ne '# ANAs combined by paste\nB\nA\nT') \
	<(awk '{print $$25}' $(word 1,$^)) \
	<(awk '{print $$25}' $(word 2,$^)) \
	<(awk '{print $$3}' $(word 3,$^)) \
	<(awk '{print $$3}' $(word 4,$^)) \
	<(awk '{print $$3}' $(word 5,$^)) \
	<(awk '{print $$3}' $(word 6,$^)) \
	| sed '2i\\tSvox0.3\tSvox1.0\tSraw0.3\tSraw1.0\tSsws0.3\tSsws1.0'> $@

So.csv : $(BNseg).anaJJ       $(BNseg)_rs+1.0.anaJJ \
         $(BNseg)_raw_o.anaSS $(BNseg)_rs+1.0_raw_o.anaSV \
         $(BNseg)_sws_o.anaSS $(BNseg)_rs+1.0_sws_o.anaSV
	paste <(echo -ne '# ANAs combined by paste\nB\nA\nT') \
	$(word 1,$^) \
	$(word 2,$^) \
	<(awk '{print $$3}' $(word 3,$^)) \
	<(awk '{print $$3}' $(word 4,$^)) \
	<(awk '{print $$3}' $(word 5,$^)) \
	<(awk '{print $$3}' $(word 6,$^)) \
	| sed '2i\\tSvox0.3\tSvox1.0\tSraw0.3\tSraw1.0\tSsws0.3\tSsws1.0'> $@


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




