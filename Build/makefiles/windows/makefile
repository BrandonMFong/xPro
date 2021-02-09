# makefile
# https://docs.microsoft.com/en-us/cpp/build/reference/description-blocks?view=msvc-160
# @cl $(SOURCE_DIR)\$@\main.cpp $(LIB_ROOT)\xPro\xPro.cpp /Fexpro.$@.exe $(FLAGS)

# MACROS START
CC=cl
SOURCE_ROOT=.\..\..\..\Sources
xPro_ROOT=$(SOURCE_ROOT)\..
TOOLS_DIR=$(SOURCE_ROOT)\Tools
FRAMEWORK_DIR=$(SOURCE_ROOT)\xPro
BIN_DIR=$(xPro_ROOT)\bin
FLAGS = \
	/std:c++latest \
	/EHsc \
	/I$(SOURCE_ROOT) \
	/D_CRT_SECURE_NO_WARNINGS=1

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
	$(FRAMEWORK_DIR)\xAppPointer.cpp \
	$(FRAMEWORK_DIR)\xConfigReader.cpp \
	$(FRAMEWORK_DIR)\xXml.cpp \
	$(FRAMEWORK_DIR)\xJson.cpp \
	$(FRAMEWORK_DIR)\xAppSettings.cpp \
	$(FRAMEWORK_DIR)\xFile.cpp \
	$(FRAMEWORK_DIR)\xDirectory.cpp 

SQL = \
	$(FRAMEWORK_DIR)\xDatabase.cpp \
	$(FRAMEWORK_DIR)\xQuery.cpp 

XPRO = \
	$(FRAMEWORK_DIR)\xPro.cpp \
	$(FRAMEWORK_DIR)\xObject.cpp

EXTERN = \
	$(FRAMEWORK_DIR)\extern\pugixml.cpp \
	$(FRAMEWORK_DIR)\extern\sqlite3.c 

SOURCE_FILES = $(FILESYSTEM) $(SQL) $(XPRO) $(EXTERN)
# MACROS end

# nmake 
all: $(OBJECTS)

$(OBJECTS) : 
	@echo Building 
	@$(CC) /Fe$(BIN_DIR)\xpro.$@.exe $(SOURCE_FILES) $(FLAGS)
