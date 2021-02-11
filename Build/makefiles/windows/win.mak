# makefile
# https://docs.microsoft.com/en-us/cpp/build/reference/description-blocks?view=msvc-160
# https://www.bojankomazec.com/2011/10/how-to-use-nmake-and-makefile.html

# MACROS START
CC=cl
LINK=link
SOURCE_ROOT=.\..\..\Sources
xPro_ROOT=$(SOURCE_ROOT)\..
TOOLS_DIR=$(SOURCE_ROOT)\Tools
FRAMEWORK_DIR=$(SOURCE_ROOT)\xPro
BIN_DIR=$(xPro_ROOT)\bin
OBJ=.obj
FLAGS = \
	/std:c++17 \
	/EHsc \
	/I$(SOURCE_ROOT) \
	/D_CRT_SECURE_NO_WARNINGS=1

TOOLS = \
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
	pugixml.cpp \
	sqlite3.c 

OBJECTS = $(XPRO) $(SQL) $(FILESYSTEM)
# MACROS end
