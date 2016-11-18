

HTTPSproxy?=""

all : base.done

clean:
	@-rm -v MR3006g_OT[1-3].tif

base.done : cMR3006g_OT1 cMR3006g_OT2 # cMR3006g_OT3
	touch $@

.PHONY : MR3006g_OT1.tif MR3006g_OT2.tif

MR3006g_OT1.tif :
	https_proxy=$(HTTPSproxy) wget --continue --progress=bar -O $@ 'https://osf.io/958cq/?action=download'

MR3006g_OT2.tif :
	https_proxy=$(HTTPSproxy) wget --continue --progress=bar -O $@ 'https://osf.io/6py3h/?action=download'

.PHONY : cMR3006g_OT1 cMR3006g_OT2 cMR3006g_OT3
cMR3006g_OT1 cMR3006g_OT2 cMR3006g_OT3 : c% : %.tif | %.tif.md5
	md5sum -c $<.md5
