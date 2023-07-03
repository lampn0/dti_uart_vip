#---------------------------------------------------------------
# Define Variables
#---------------------------------------------------------------
UVM_HOME ?= ..
MTI_HOME ?= ..
PLATFORM ?= Linux
BITS     ?= 32

LIBDIR    = $(UVM_HOME)/lib
DPI_SRC   = $(UVM_HOME)/src/dpi/uvm_dpi.cc

ifeq ($(PLATFORM), Linux)
  LIBNAME   = uvm_dpi$(BITS)
  CC        = g++
  INC       = 
  GCCCMD    =  $(CC) -m$(BITS) -fPIC -DQUESTA -g -W -shared -x c $(INC) $(DPI_SRC) -o $(LIBDIR)/$(LIBNAME).so
else
  LIBNAME   = uvm_dpiWin$(BITS)
  ifeq ($(BITS), 32)
    INC     = -I$(MTI_HOME)/gcc-4.2.1-mingw32vc9/include -I$(MTI_HOME)/include
    CC      = $(MTI_HOME)/gcc-4.2.1-mingw32vc9/bin/g++.exe
  else
    INC     = -I$(MTI_HOME)/gcc-4.5.0-mingw64/include -I$(MTI_HOME)/include
    CC      = $(MTI_HOME)/gcc-4.5.0-mingw64/bin/g++.exe
  endif
  GCCCMD    = $(CC) -g -DQUESTA -W -shared -Bsymbolic -x c $(INC) $(DPI_SRC) -o $(LIBDIR)/$(LIBNAME).dll -L$(MTI_HOME)/win$(BITS) -lmtipli -lregex
endif

#---------------------------------------------------------------
# If USES_DPI is set, enables compilation and loading of DPI
# libraries. Enabling DPI adds +acc on command line, which
# may adversely affect simulator performance.
#---------------------------------------------------------------

#---------------------------------------------------------------
# Define Targets
#
# vlog and vsim targets defined in individual examples
#---------------------------------------------------------------

help: 
	@echo "Usage:  make -f Makefile.questa [target(s)]"
	@echo ""
	@echo "Typical: make -f Makefile.questa all"
	@echo ""
	@echo "where target is any of"
	@echo ""
	@echo "  dpi_lib     - compile DPI lib (use BITS=XX, def=32)"
	@echo "  dpi_lib32   - compile DPI lib for 32-bit Linux (BITS=32)"
	@echo "  dpi_lib64   - compile DPI lib for 64-bit Linux (BITS=64)"
	@echo "  dpi_libWin  - compile DPI lib for Windows"
	@echo ""
	@echo "Variables: specify any of the following on the make command line"
	@echo "  UVM_HOME  - root directory of the UVM library (default:..)"
	@echo "  MTI_HOME  - root directory of the Questasim installation (default:..)"
	@echo "  BITS      - the bus architecture: 32 or 64 (default:32)"
	@echo "  PLATFORM  - flatform (default: Linux)"
	@echo ""

all:
	$(GCCCMD)
