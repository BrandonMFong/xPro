# makefile
# https://www.bojankomazec.com/2011/10/how-to-use-nmake-and-makefile.html

# MACROS 
LIB_ROOT = ..\..
xPro_ROOT = $(LIB_ROOT)\..
OUTPUT_DIR = $(xPro_ROOT)\bin

# enumdir
ENUMDIR_TARGET_DIR = $(LIB_ROOT)\EnumerateFilesInDir
ENUMDIR_TAR = $(ENUMDIR_TARGET_DIR)\main.cpp
ENUMDIR_STD_FLAG = c++latest 
ENUMDIR_EXE = xpro.enumdir.exe
ENUMDIR_OBJ = main.obj
$(ENUMDIR_EXE): 
	cl $(ENUMDIR_TAR) /std:$(ENUMDIR_STD_FLAG) /Fe$(ENUMDIR_EXE) /EHsc /I$(LIB_ROOT)
	copy $(ENUMDIR_EXE) $(OUTPUT_DIR)\$(ENUMDIR_EXE)
	del $(ENUMDIR_EXE)
	del $(ENUMDIR_OBJ)

all: $(ENUMDIR_EXE)  