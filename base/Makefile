

HTTPSproxy?=""

all : base.done

base.done : cMR3006g_OT1 cMR3006g_OT2 # cMR3006g_OT3
	touch $@

%.tif : %.tif.md5
	https_proxy=$(HTTPSproxy) wget --continue  https://midas3.kitware.com/midas/download/item/321188/$*.tif

.PHONY : cMR3006g_OT1 cMR3006g_OT2 cMR3006g_OT3
cMR3006g_OT1 cMR3006g_OT2 cMR3006g_OT3 : c% : %.tif
	md5sum -c $<.md5
