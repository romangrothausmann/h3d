

SHELL:= /bin/bash
GVmake=$(MAKE) #any line with $(MAKE) gets exectued even with -n, GVmake should merely be used for makefile-visualization to avoid its execution with -n



all : Sc.csv  So.csv  V.csv  luBounds.csv # mask.csv


Sc.csv So.csv V.csv : %.csv : ../../../processing/ana/%.csv
	cp -v $^ .

luBounds.csv : ../../../processing/low_upp-bounds/luBounds.csv
	cp -v $^ .


