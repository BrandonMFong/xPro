# https://www.cs.swarthmore.edu/~newhall/unixhelp/howto_makefiles.html

# MACROS START
BIN_DIR = ./../../bin
LIB_ROOT=./..
INC=-I$(LIB_ROOT)

# enumdir
ENUMDIR_TARGET_DIR := $(LIB_ROOT)/EnumerateFilesInDir
ENUMDIR_TAR := $(BIN_DIR)/xpro.enumdir
ENUMDIR_STD_FLAG = c++14
ENUMDIR_APP = xpro.enumdir
# MACROS END

tmp := $(shell mkdir -p $(BIN_DIR)) # create output bin directory 

enumdir: $(ENUMDIR_TARGET_DIR)/main.cpp
	g++ $(ENUMDIR_TARGET_DIR)/main.cpp  -lstdc++fs -std=$(ENUMDIR_STD_FLAG) -o $(BIN_DIR)/$(ENUMDIR_APP) $(INC)

# Linux
all: test 

# all: main.cpp
# 	g++ main.cpp -lstdc++fs -std=c++14 -o $(TAR) $(LIB_ROOT)