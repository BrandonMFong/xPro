# https://www.cs.swarthmore.edu/~newhall/unixhelp/howto_makefiles.html

# MACROS START
BIN_DIR = ./../../bin
LIB_ROOT=-I./../
tmp := $(shell mkdir -p $(BIN_DIR)) # create output directory 
TAR := $(BIN_DIR)/xpro.enumdir # target
# MACROS END

# macOS 
ifeq ($(shell uname -s),Darwin) # Assuming this identifies macOS
all: main.cpp
	g++ main.cpp -std=c++14 -c -Wall -Iinclude -o $(TAR)
endif

