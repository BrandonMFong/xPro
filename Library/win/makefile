# makefile
# https://www.bojankomazec.com/2011/10/how-to-use-nmake-and-makefile.html

# MACROS START
xPro_ROOT = ..\..
LIB_ROOT = ..
OUTPUT_DIR = $(xPro_ROOT)\bin

# Enumdir
ENUMDIR_TARGET_DIR = $(LIB_ROOT)\EnumerateFilesInDir
ENUMDIR_TAR = $(ENUMDIR_TARGET_DIR)\main.cpp
ENUMDIR_STD_FLAG = c++latest 
ENUMDIR_NAME = xpro.enumdir.exe
# MACROS END

$(ENUMDIR_NAME): 
	cl $(ENUMDIR_TAR) /std:$(ENUMDIR_STD_FLAG) /Fe$(ENUMDIR_NAME) /EHsc	
	copy $(ENUMDIR_NAME) $(OUTPUT_DIR)\$(ENUMDIR_NAME)

all: $(ENUMDIR_NAME)  
