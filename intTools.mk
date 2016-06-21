
### default paths of external libraries are expected from main Makefile
ITKLIB?=""
VTKLIB?=""

## path to submodules
export SUBDIR = $(realpath submodules)

### setting default paths of internal programs
ITK?=$(SUBDIR)/ITK-CLIs/
VTK?=$(SUBDIR)/VTK-CLIs/


.PHONY: all clean


all : $(ITKEXE)
all : $(VTKEXE)
clean : cleanITK
clean : cleanVTK

.PHONY: initITK cleanITK
initITK :
	mkdir -p $(ITK)/build/ && \
	cd $(ITK)/build/ && \
	cmake -DITK_DIR=$(ITKLIB) -DCMAKE_BUILD_TYPE=Release ..

$(ITKEXE) : initITK
$(ITKEXE) cleanITK :
	$(MAKE) -C $(ITK)/build/ $@

.PHONY: initVTK cleanVTK
initVTK :
	cd $(VTK)/ && \
	git submodule update --init --recursive # http://stackoverflow.com/questions/3796927/how-to-git-clone-including-submodules#4438292
	mkdir -p $(VTK)/build/ && \
	cd $(VTK)/build/ && \
	cmake -DVTK_DIR=$(VTKLIB) -DCMAKE_BUILD_TYPE=Release ..

$(VTKEXE) : initVTK
$(VTKEXE) cleanVTK :
	$(MAKE) -C $(VTK)/build/ $@
