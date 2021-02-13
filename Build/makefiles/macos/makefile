# macos
# https://stackoverflow.com/questions/43465483/makefile-with-c-classes

include ../makefile

# MACROS START
CC=g++
SOURCE_ROOT=./../../../Sources
xPro_ROOT=$(SOURCE_ROOT)/..
TOOLS_DIR=$(SOURCE_ROOT)/Tools
BIN_DIR=$(xPro_ROOT)/bin
FLAGS = \
	-std=c++17 \
	-I$(SOURCE_ROOT) \
	-Wall 
# MACROS END

tmp := $(shell mkdir -p $(BIN_DIR)) # create output bin directory 

all: $(EXTERN) $(XPRO) $(SQL) $(FILESYSTEM) $(OBJECTS) clean

pugixml.cpp : promptPackage
	@echo "  |->" $@
	@$(CC) $(SOURCE_ROOT)/xPro/extern/pugixml.cpp -c -o pugixml.o $(FLAGS)

sqlite3.c : 
	@echo "  |->" $@
	@gcc $(SOURCE_ROOT)/xPro/extern/sqlite3.c -c -o sqlite3.o -I$(SOURCE_ROOT) -Wall

$(OBJECTS) : promptObjects
	@echo "  |->" $@.o
	@$(CC) $(SOURCE_ROOT)/xPro/$@.cpp -c -o $@.o $(FLAGS)

$(TOOLS) : promptTools
	@echo "  |->" xpro.$@
	@$(CC) $(TOOLS_DIR)/$@/main.cpp *.o -o $(BIN_DIR)/xpro.$@ $(FLAGS)

promptTools :
	@echo " /"
	@echo "-"xPro Tools:
	@echo "|_"

promptObjects :
	@echo " /"
	@echo "-"xPro Objects:
	@echo "|_"

promptPackage : 
	@echo "-"Packages:
	@echo "|_"

clean :
	@echo Cleaning...
	rm *.o