# Linux
# MACROS START
CC=g++
SOURCE_ROOT=./../..
xPro_ROOT=$(SOURCE_ROOT)/..
TOOLS_DIR=$(SOURCE_ROOT)/Tools
BIN_DIR=$(xPro_ROOT)/bin
FLAGS = \
	-lstdc++fs \
	-std=c++17 \
	-I$(SOURCE_ROOT) \
	-Wall \
	-lssl \
	-lcrypto 
OBJECTS = \
	enumdir \
	exist \
	selectitem \
	getpath \
	cat \
	getdir \
	query

# Ascend object hierarchy
FILESYSTEM = \
	xAppPointer \
	xConfigReader \
	xXml \
	xFile \
	xDirectory 

SQL = \
	xDatabase \
	xQuery 

XPRO = \
	xPro \
	xObject

# MACROS END

tmp := $(shell mkdir -p $(BIN_DIR)) # create output bin directory 

all: pugi $(XPRO) $(SQL) $(FILESYSTEM) $(OBJECTS) clean

pugi : 
	@echo Package: Pugixml 
	@$(CC) $(SOURCE_ROOT)/xPro/extern/pugixml.cpp -c -o pugixml.o $(FLAGS)

$(XPRO) :
	@echo xPro Objects: $@.o
	@$(CC) $(SOURCE_ROOT)/xPro/$@.cpp -c -o $@.o $(FLAGS)

$(FILESYSTEM) :
	@echo xPro Objects: $@.o
	@$(CC) $(SOURCE_ROOT)/xPro/$@.cpp -c -o $@.o $(FLAGS)

$(SQL) :
	@echo xPro Objects: $@.o
	@$(CC) $(SOURCE_ROOT)/xPro/$@.cpp -c -o $@.o $(FLAGS)

$(OBJECTS) :
	@echo xPro Tools: xpro.$@
	@$(CC) $(TOOLS_DIR)/$@/main.cpp *.o -o $(BIN_DIR)/xpro.$@ $(FLAGS)

clean :
	@echo Cleaning...
	rm *.o