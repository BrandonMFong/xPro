# makefile: apple  
# https://stackoverflow.com/questions/42015121/exec-format-error-running-a-binary-created-by-g
# https://www.cs.swarthmore.edu/~newhall/unixhelp/howto_makefiles.html

# MACROS 
BIN_DIR = ./../../../bin# bin folder
LIB_ROOT=./../..# root for Library folder 
INC=-I$(LIB_ROOT)# flag for include

tmp := $(shell mkdir -p $(BIN_DIR)) # create output bin directory 
all: enumdir exist 

# enumdir
ENUMDIR_TARGET_DIR := $(LIB_ROOT)/EnumerateFilesInDir
ENUMDIR_STD_FLAG = c++14
ENUMDIR_APP = xpro.enumdir
enumdir: $(ENUMDIR_TARGET_DIR)/main.cpp
	g++ $(ENUMDIR_TARGET_DIR)/main.cpp -std=$(ENUMDIR_STD_FLAG) -Wall $(INC) -o $(BIN_DIR)/$(ENUMDIR_APP)

# exist
EXIST_TARGET_DIR := $(LIB_ROOT)/DoesExist
EXIST_STD_FLAG = c++14
EXIST_APP = xpro.exist
exist: $(EXIST_TARGET_DIR)/main.cpp
	g++ $(EXIST_TARGET_DIR)/main.cpp -std=$(EXIST_STD_FLAG) -Wall $(INC) -o $(BIN_DIR)/$(EXIST_APP)
