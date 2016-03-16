

SHELL:= /bin/bash


SUBDIRS:= processing/ana/ manual/slices/ manual/SRV/


.PHONY: all clean $(SUBDIRS)


all : $(SUBDIRS)

clean :
	$(MAKE) -C $(SUBDIRS) clean


processing/% :
	$(MAKE) -C $(dir $@) $(notdir $@)


manual/slices/ : processing/slices.done

processing/ana/ : processing/ana.done

manual/SRV/ : processing/SRV.done


$(SUBDIRS) :
	/usr/bin/time -v -o $@timing \
	   $(MAKE) -C $@


.SERIAL : processing/slices.done processing/ana.done processing/SRV.done
