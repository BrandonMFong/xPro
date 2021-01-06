


# ifeq ($(OS),Windows_NT)

# # MACROS START
# LIB_ROOT = ..\..
# SOURCE_DIR = $(LIB_ROOT)\Sources
# xPro_ROOT = $(LIB_ROOT)\..
# OUTPUT_DIR = $(xPro_ROOT)\bin

# # enumdir
# ENUMDIR_APPNAME = enumdir
# ENUMDIR_TARGET_DIR = $(SOURCE_DIR)\$(ENUMDIR_APPNAME)
# ENUMDIR_STD_FLAG = c++latest 
# ENUMDIR_EXE = xpro.$(ENUMDIR_APPNAME).exe

# # exist
# EXIST_APPNAME = exist
# EXIST_TARGET_DIR = $(SOURCE_DIR)\$(EXIST_APPNAME)
# EXIST_STD_FLAG = c++latest 
# EXIST_EXE = xpro.$(EXIST_APPNAME).exe

# # selectitem 
# SELECTITEM_APPNAME = selectitem
# SELECTITEM_TARGET_DIR = $(SOURCE_DIR)\$(SELECTITEM_APPNAME)
# SELECTITEM_STD_FLAG = c++latest 
# SELECTITEM_EXE = xpro.$(SELECTITEM_APPNAME).exe
# # MACROS end

# # nmake 
# all:\
# 	$(ENUMDIR_EXE) \
# 	$(EXIST_EXE) \
# 	$(SELECTITEM_EXE)

# $(ENUMDIR_EXE) : $(ENUMDIR_TARGET_DIR)\main.cpp
# 	echo Building $(ENUMDIR_EXE)
# 	cl $(ENUMDIR_TARGET_DIR)\main.cpp /std:$(ENUMDIR_STD_FLAG) /Fe$(ENUMDIR_EXE) /EHsc /I$(LIB_ROOT)
# 	copy $(ENUMDIR_EXE) $(OUTPUT_DIR)\$(ENUMDIR_EXE)
# 	del $(ENUMDIR_EXE)
# 	del main.obj

# $(EXIST_EXE) : $(EXIST_TARGET_DIR)\main.cpp
# 	echo Building $(EXIST_EXE)
# 	cl $(EXIST_TARGET_DIR)\main.cpp /std:$(EXIST_STD_FLAG) /Fe$(EXIST_EXE) /EHsc /I$(LIB_ROOT)
# 	copy $(EXIST_EXE) $(OUTPUT_DIR)\$(EXIST_EXE)
# 	del $(EXIST_EXE)
# 	del main.obj

# $(SELECTITEM_EXE) : $(SELECTITEM_TARGET_DIR)\main.cpp
# 	echo Building $(SELECTITEM_EXE)
# 	cl $(SELECTITEM_TARGET_DIR)\main.cpp /std:$(SELECTITEM_STD_FLAG) /Fe$(SELECTITEM_EXE) /EHsc /I$(LIB_ROOT)
# 	copy $(SELECTITEM_EXE) $(OUTPUT_DIR)\$(SELECTITEM_EXE)
# 	del $(SELECTITEM_EXE)
# 	del main.obj
# endif 

ifeq ($(shell uname), Darwin)
CPP_VERSION = c++17
LSTDC_FLAG = -lstdc++fs
else
ifeq ($(shell uname),Linux)
CPP_VERSION = c++2a
LSTDC_FLAG = -lstdc++fs
endif
endif

# https://www.cs.swarthmore.edu/~newhall/unixhelp/howto_makefiles.html

# MACROS START
CC=g++
LIB_ROOT=./..
SOURCE_DIR=$(LIB_ROOT)/Sources
xPro_ROOT=$(LIB_ROOT)/..
BIN_DIR=$(xPro_ROOT)/bin
INC=-I$(LIB_ROOT)

# Applications
OBJECTS = \
	enumdir \
	exist \
	selectitem

# MACROS END

tmp := $(shell mkdir -p $(BIN_DIR)) # create output bin directory 

all: $(OBJECTS)

$(OBJECTS) :
	@echo Building $@
	$(CC) $(SOURCE_DIR)/$@/main.cpp $(LSTDC_FLAG) -std=$(CPP_VERSION) $(INC) -Wall -o $(BIN_DIR)/xpro.$@
