

SHELL:= /bin/bash


SUBDIRS:= processing/ processing/ana/


.PHONY: all clean $(SUBDIRS)


all : $(SUBDIRS)

clean :
	$(MAKE) -C $(SUBDIRS) clean


processing/% :
	$(MAKE) -C $(dir $@) $(notdir $@)


processing/ana/ : processing/h3d_seg_A+B+T.mha processing/h3d_rsi+1+1.0.mha


$(SUBDIRS) :
	/usr/bin/time -v -o $@timing \
	   $(MAKE) -C $@


