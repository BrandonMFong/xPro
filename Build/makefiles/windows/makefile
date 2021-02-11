# makefile
# https://docs.microsoft.com/en-us/cpp/build/reference/description-blocks?view=msvc-160
# https://www.bojankomazec.com/2011/10/how-to-use-nmake-and-makefile.html

# MACROS START
CC=cl
LINK=link
SOURCE_ROOT=.\..\..\..\Sources
xPro_ROOT=$(SOURCE_ROOT)\..
TOOLS_DIR=$(SOURCE_ROOT)\Tools
FRAMEWORK_DIR=$(SOURCE_ROOT)\xPro
BIN_DIR=$(xPro_ROOT)\bin
OBJ=.obj
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
	$(FRAMEWORK_DIR)\extern\pugixml \
	$(FRAMEWORK_DIR)\extern\sqlite3.c 

SOURCE_FILES = $(FILESYSTEM) $(SQL) $(XPRO) $(EXTERN)
# MACROS end

# nmake 
all: $(EXTERN) $(XPRO) $(SQL) $(FILESYSTEM) $(OBJECTS) clean
# all: $(OBJECTS)

$(OBJECTS) : 
	@echo Building 
	@$(CC) /c $(TOOLS_DIR)\$@\main.cpp $(FLAGS) *.obj
	@$(LINK) /out:$(BIN_DIR)\xpro.$@.exe *.obj 

$(FRAMEWORK_DIR)\extern\pugixml : 
	@echo Package: Pugixml 
	@$(CC) /c $@.cpp /Fepugixml.obj $(FLAGS)

$(FRAMEWORK_DIR)\extern\sqlite3 : 
	@echo Package: sqlite 
	@$(CC) /c $@.cpp /Fesqlite3.obj $(FLAGS)

$(XPRO) :
	@echo xPro Objects: $@.obj
	@$(CC) /c $(FRAMEWORK_DIR)\$@.cpp /Fe$@.obj $(FLAGS)

$(FILESYSTEM) :
	@echo xPro Objects: $@.obj
	@$(CC) /c $(FRAMEWORK_DIR)\$@.cpp /Fe$@.obj $(FLAGS)

$(SQL) :
	@echo xPro Objects: $@.o
	@$(CC) /c $(FRAMEWORK_DIR)\$@.cpp /Fe$@.obj $(FLAGS)

clean :
	@echo Cleaning...
	@del *.obj
