# makefile
# https://docs.microsoft.com/en-us/cpp/build/reference/description-blocks?view=msvc-160

# MACROS START
LIB_ROOT = ..\..
xPro_ROOT = $(LIB_ROOT)\..
OUTPUT_DIR = $(xPro_ROOT)\bin

# enumdir
ENUMDIR_TARGET_DIR = $(LIB_ROOT)\EnumerateFilesInDir
ENUMDIR_STD_FLAG = c++latest 
ENUMDIR_EXE = xpro.enumdir.exe

# exist
EXIST_TARGET_DIR = $(LIB_ROOT)\DoesExist
EXIST_STD_FLAG = c++latest 
EXIST_EXE = xpro.exist.exe

# selectitem 
SELECTITEM_TARGET_DIR = $(LIB_ROOT)\SelectItem
SELECTITEM_STD_FLAG = c++latest 
SELECTITEM_EXE = xpro.selectitem.exe
# MACROS end

# nmake 
all:\
	$(ENUMDIR_EXE) \
	$(EXIST_EXE) \
	$(SELECTITEM_EXE)

$(ENUMDIR_EXE) : $(ENUMDIR_TARGET_DIR)\main.cpp
	echo Building $(ENUMDIR_EXE)
	cl $(ENUMDIR_TARGET_DIR)\main.cpp /std:$(ENUMDIR_STD_FLAG) /Fe$(ENUMDIR_EXE) /EHsc /I$(LIB_ROOT)
	copy $(ENUMDIR_EXE) $(OUTPUT_DIR)\$(ENUMDIR_EXE)
	del $(ENUMDIR_EXE)
	del main.obj

$(EXIST_EXE) : $(EXIST_TARGET_DIR)\main.cpp
	echo Building $(EXIST_EXE)
	cl $(EXIST_TARGET_DIR)\main.cpp /std:$(EXIST_STD_FLAG) /Fe$(EXIST_EXE) /EHsc /I$(LIB_ROOT)
	copy $(EXIST_EXE) $(OUTPUT_DIR)\$(EXIST_EXE)
	del $(EXIST_EXE)
	del main.obj

$(SELECTITEM_EXE) : $(SELECTITEM_TARGET_DIR)\main.cpp
	echo Building $(SELECTITEM_EXE)
	cl $(SELECTITEM_TARGET_DIR)\main.cpp /std:$(SELECTITEM_STD_FLAG) /Fe$(SELECTITEM_EXE) /EHsc /I$(LIB_ROOT)
	copy $(SELECTITEM_EXE) $(OUTPUT_DIR)\$(SELECTITEM_EXE)
	del $(SELECTITEM_EXE)
	del main.obj