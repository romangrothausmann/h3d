
### default paths of external libraries are expected from main Makefile
ITKLIB?=""
VTKLIB?=""

## path to submodules
export SUBDIR = $(realpath submodules)

### setting default paths of internal programs
ITK?=$(SUBDIR)/ITK-CLIs/
VTK?=$(SUBDIR)/VTK-CLIs/
ITKVTK?=$(SUBDIR)/ITKVTK-CLIs/


.PHONY: all clean


all : $(ITKEXE)
all : $(VTKEXE)
all : $(ITKVTKEXE)
clean :
	$(MAKE) -C $(ITK)/build/ clean
	$(MAKE) -C $(VTK)/build/ clean
	$(MAKE) -C $(ITKVTK)/build/ clean

.PHONY: initITK
initITK :
	mkdir -p $(ITK)/build/ && \
	cd $(ITK)/build/ && \
	cmake -DITK_DIR=$(ITKLIB) -DCMAKE_BUILD_TYPE=Release ..

$(ITKEXE) : initITK
	$(MAKE) -C $(ITK)/build/ $@

.PHONY: initVTK
initVTK :
	cd $(VTK)/ && \
	git submodule update --init --recursive # http://stackoverflow.com/questions/3796927/how-to-git-clone-including-submodules#4438292
	mkdir -p $(VTK)/build/ && \
	cd $(VTK)/build/ && \
	cmake -DVTK_DIR=$(VTKLIB) -DCMAKE_BUILD_TYPE=Release ..

$(VTKEXE) : initVTK
	$(MAKE) -C $(VTK)/build/ $@

.PHONY: initITKVTK
initITKVTK :
	cd $(ITKVTK)/ && \
	git submodule update --init --recursive # http://stackoverflow.com/questions/3796927/how-to-git-clone-including-submodules#4438292
	mkdir -p $(ITKVTK)/build/ && \
	cd $(ITKVTK)/build/ && \
	cmake -DITK_DIR=$(ITKLIB) -DVTK_DIR=$(VTKLIB) -DCMAKE_BUILD_TYPE=Release ..

$(ITKVTKEXE) : initITKVTK
	$(MAKE) -C $(ITKVTK)/build/ $@
