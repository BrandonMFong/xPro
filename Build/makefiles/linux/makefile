# Linux
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
	-Wall \
	-lssl \
	-lcrypto \
	-lpthread \
	-ldl

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

# MACROS END

tmp := $(shell mkdir -p $(BIN_DIR)) # create output bin directory 

all: $(EXTERN) $(XPRO) $(SQL) $(FILESYSTEM) $(OBJECTS) clean

pugi : 
	@echo Package: Pugixml 
	@$(CC) $(SOURCE_ROOT)/xPro/extern/pugixml.cpp -c -o pugixml.o $(FLAGS)

sqlite : 
	@echo Package: sqlite 
	@gcc $(SOURCE_ROOT)/xPro/extern/sqlite3.c -c -o sqlite3.o -lstdc++fs -I$(SOURCE_ROOT) -Wall -lssl -ldl

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