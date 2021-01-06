# makefile
# https://docs.microsoft.com/en-us/cpp/build/reference/description-blocks?view=msvc-160

# MACROS START
LIB_ROOT = ..\..
SOURCE_DIR = $(LIB_ROOT)\Sources
xPro_ROOT = $(LIB_ROOT)\..
BIN_DIR = $(xPro_ROOT)\bin
FLAGS = \
	/std:c++latest \
	/EHsc \
	/I$(LIB_ROOT)
OBJECTS = \
	enumdir \
	exist \
	selectitem
# MACROS end

# nmake 
all: $(OBJECTS)

$(OBJECTS): 
	@echo Building 
	@cl $(SOURCE_DIR)\$@\main.cpp /Fexpro.$@.exe $(FLAGS)
	@copy xpro.$@.exe $(BIN_DIR)\$(ENUMDIR_EXE)
	@del xpro.$@.exe
	@del main.obj
