# makefile
# https://docs.microsoft.com/en-us/cpp/build/reference/description-blocks?view=msvc-160
# @cl $(SOURCE_DIR)\$@\main.cpp $(LIB_ROOT)\xPro\xPro.cpp /Fexpro.$@.exe $(FLAGS)

# MACROS START
CC=cl
SOURCE_ROOT=.\..\..\..\Sources
xPro_ROOT=$(SOURCE_ROOT)\..
TOOLS_DIR=$(SOURCE_ROOT)\Tools
BIN_DIR=$(xPro_ROOT)\bin
FLAGS = \
	/std:c++latest \
	/EHsc \
	/I$(LIB_ROOT) \
	/Wall \

OBJECTS = \
	enumdir \
	exist \
	selectitem \
	getpath \
	cat \
	getdir \
	query \
	json

# Ascend object hierarchy
FILESYSTEM = \
	xAppPointer \
	xConfigReader \
	xXml \
	xJson \
	xAppSettings \
	xFile \
	xDirectory 

SQL = \
	xDatabase \
	xQuery 

XPRO = \
	xPro \
	xObject

EXTERN = \
	pugi \
	sqlite 
# MACROS end

# nmake 
all: pugi

pugi : 
	@echo Package: Pugixml 
	@$(CC) /Fopugixml.obj $(SOURCE_ROOT)\xPro\extern\pugixml.cpp $(FLAGS)

sqlite : 
	@echo Package: sqlite 

$(XPRO) :
	@echo xPro Objects: $@.o

$(FILESYSTEM) :
	@echo xPro Objects: $@.o

$(SQL) :
	@echo xPro Objects: $@.o

$(OBJECTS) :
	@echo xPro Tools: xpro.$@

$(OBJECTS) : 
	@echo Building 
	@copy xpro.$@.exe $(BIN_DIR)\$(ENUMDIR_EXE)
	@del xpro.$@.exe
	@del main.obj
