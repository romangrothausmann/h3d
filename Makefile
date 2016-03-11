

SHELL:= /bin/bash


SUBDIRS:= processing/ processing/ana/ manual/slices/ manual/SRV/


.PHONY: all clean $(SUBDIRS)


all : $(SUBDIRS)

clean :
	$(MAKE) -C $(SUBDIRS) clean


processing/% :
	$(MAKE) -C $(dir $@) $(notdir $@)


manual/slices/ : processing/h3d.mha  processing/h3d_seg_A+B.mha processing/h3d_rsi+1+1.0.mha processing/h3d_hull_00.vtp

processing/ana/ : processing/h3d_seg_A+B+T.mha

manual/SRV/ : processing/demo-path.vtp processing/h3d.mha processing/h3d_seg_Bt+Arz-fm.mha processing/h3d_seg_B-fm.mha # man. files outside manual/SRV/:  manual/processing/h3d_seg_Bt.mha.gz manual/processing/h3d_seg_Arz.mha.gz manual/processing/h3d_seg_Bt+Arz_fm-seeds.mha.gz


$(SUBDIRS) :
	/usr/bin/time -v -o $@timing \
	   $(MAKE) -C $@


.SERIAL : processing/demo-path.vtp processing/h3d_seg_Bt+Arz-fm.mha processing/h3d_seg_B-fm.mha # for gnu-make compiled with patch from: http://savannah.gnu.org/patch/index.php?5108
