
### default paths of external libraries are expected from main Makefile
ITKLIB?=""

## path to submodules
export SUBDIR = $(realpath submodules)

### setting default paths of internal programs
ITK?=$(SUBDIR)/ITK-CLIs/


.PHONY: all clean


all : $(ITKEXE)
clean : cleanITK

.PHONY: initITK cleanITK
initITK :
	mkdir -p $(ITK)/build/ && \
	cd $(ITK)/build/ && \
	cmake -DITK_DIR=$(ITKLIB) -DCMAKE_BUILD_TYPE=Release ..

$(ITKEXE) : initITK
$(ITKEXE) cleanITK :
	$(MAKE) -C $(ITK)/build/ $@
