# makefile
# https://docs.microsoft.com/en-us/cpp/build/reference/description-blocks?view=msvc-160
# @cl $(SOURCE_DIR)\$@\main.cpp $(LIB_ROOT)\xPro\xPro.cpp /Fexpro.$@.exe $(FLAGS)

# MACROS START
CPP_EXT = cpp
LIB_ROOT = ..\..
SOURCE_DIR = $(LIB_ROOT)\Sources
xPro_ROOT = $(LIB_ROOT)\..
BIN_DIR = $(xPro_ROOT)\bin
FLAGS = \
	/std:c++latest \
	/EHsc \
	/I$(LIB_ROOT)
TARGET_DIR = xPro 
TARGETS = \
	$(SOURCE_DIR)\$@\main.cpp \
	$(LIB_ROOT)\xPro\xPro.cpp \
	$(LIB_ROOT)\xPro\xDirectory.cpp
OBJECTS = \
	enumdir \
	exist \
	selectitem
# MACROS end

# nmake 
all: $(OBJECTS) Clean

$(OBJECTS): 
	@echo Building 
	@cl $(TARGETS) /Fexpro.$@.exe $(FLAGS)
	@copy xpro.$@.exe $(BIN_DIR)\$(ENUMDIR_EXE)
	@del xpro.$@.exe
	@del main.obj
