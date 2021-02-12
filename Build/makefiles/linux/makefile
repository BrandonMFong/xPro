# Linux

include ../makefile

# MACROS START
CC=g++
SOURCE_ROOT=./../../../Sources
xPro_ROOT=$(SOURCE_ROOT)/..
TOOLS_DIR=$(SOURCE_ROOT)/Tools
BIN_DIR=$(xPro_ROOT)/bin
FLAGS = \
	-lstdc++fs \
	-std=c++17 \
	-I$(SOURCE_ROOT) \
	-lssl \
	-lcrypto \
	-lpthread \
	-ldl
CLANGFLAGS = \
	-lstdc++fs \
	-I$(SOURCE_ROOT) \
	-lssl \
	-lcrypto \
	-lpthread \
	-ldl
# MACROS END

tmp := $(shell mkdir -p $(BIN_DIR)) # create output bin directory 

all: $(EXTERN) $(OBJECTS) $(TOOLS) clean

pugixml.cpp : 
	@echo Package: $@ 
	@$(CC) $(SOURCE_ROOT)/xPro/extern/$@ -c -o $@.o $(FLAGS)

sqlite3.c : 
	@echo Package: $@ 
	@gcc $(SOURCE_ROOT)/xPro/extern/$@ -c -o $@.o $(CLANGFLAGS)

$(OBJECTS) :
	@echo xPro Objects: $@.o
	@$(CC) $(SOURCE_ROOT)/xPro/$@.cpp -c -o $@.o $(FLAGS)

$(TOOLS) :
	@echo xPro Tools: xpro.$@
	@$(CC) $(TOOLS_DIR)/$@/main.cpp *.o -o $(BIN_DIR)/xpro.$@ $(FLAGS)

clean :
	@echo Cleaning...
	@rm *.o
	