

SHELL:= /bin/bash
GVmake=$(MAKE) #any line with $(MAKE) gets exectued even with -n, GVmake should merely be used for makefile-visualization to avoid its execution with -n

BASENAME = h3d


all : Sc.csv  So.csv  V.csv  luBounds.csv # mask.csv
all : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_obm_A+B_masked_th+125_kNo+1_ebm+01+1_ebm+02+2_msg.lol
all : $(BASENAME)_2D_wsmXbt+1+05+1+150_ols+3000_C+A_wsmXm+1+1_C+A_fh+0_obm+10+255_masked_th+125_kNo+1_dmsm_wsm+02+1+1_masked_obm+10+255_masked_th+125_kNo+1@1_msg.lol
all : $(BASENAME)_A+B_wsmXm_A+B_msg.lol
all : $(BASENAME)_A+B_wsmXm_A+B+T_msg.lol
all : $(BASENAME)_seg_B@a45_m+1_th+127@1_kNo+1+0+1_msg.lol


Sc.csv So.csv V.csv : %.csv : ../../../processing/ana/%.csv
	cp -v $^ .

luBounds.csv : ../../../processing/low_upp-bounds/luBounds.csv
	cp -v $^ .

%.lol : ../../../processing/segmentation/%.lol
	cp -v $^ .

h3d_seg_B@a45_m+1_th+127@1_kNo+1+0+1_msg.lol : %.lol : ../../../processing/%.lol
	cp -v $^ .
