#### Notes:
## use CZItoTIFFBatchConverter.exe to convert CZI to TIFF @ 1x and 8x
## load 8x TIFFs into fiji
## mark slice centers with "multi-point" tool
## export with export_multipointset.ijm from: http://imagejdocu.tudor.lu/doku.php?id=macro:multiple_points
### bfconvert can only load/save images up to 2GB, this is a Java limit:
### http://www.openmicroscopy.org/site/support/faq/bio-formats/i-see-an-outofmemory-or-negativearraysize-error-message-when-attempting-to-open-an-svs-or-jpeg-2000-file.-what-does-this-mean
### http://en.wikipedia.org/wiki/Criticism_of_Java#Large_arrays


#### ToDo:
##

#### Done:
##



SHELL:= /bin/bash
GVmake=$(MAKE) #any line with $(MAKE) gets exectued even with -n, GVmake should merely be used for makefile-visualization to avoid its execution with -n


SUBMODDIR?=../../submodules/

### setting default paths of internal programs
ITK?=$(SUBMODDIR)/ITK-CLIs/

export PATH:= $(ITK)/build:$(PATH)


EXECUTABLES = 


K:= $(foreach exec,$(EXECUTABLES),\
	$(if $(shell PATH=$(PATH) which $(exec)),some string,$(error "No $(exec) in PATH")))


BASENAME = h3d






.PHONY : all clean


all : 


clean :
	@-rm -v 


% :: %.gz
	unpigz -v -- $<

%.gz : %
	pigz -v -- $< 




