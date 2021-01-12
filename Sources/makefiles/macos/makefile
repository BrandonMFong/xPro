# macos
# https://stackoverflow.com/questions/43465483/makefile-with-c-classes

# MACROS START
CC=g++
SOURCE_ROOT=./../..
xPro_ROOT=$(SOURCE_ROOT)/..
TOOLS_DIR=$(SOURCE_ROOT)/Tools
BIN_DIR=$(xPro_ROOT)/bin
FLAGS = \
	-std=c++17 \
	-I$(SOURCE_ROOT) \
	-Wall
OBJECTS = \
	enumdir \
	exist \
	selectitem \
	getpath \
	cat \
	getrootchild \
	readxml

# Ascend object hierarchy
SUBOBJECTS = \
	xPro \
	xConfigReader \
	xXml \
	xFile \
	xDirectory
ALL = $(OBJECTS) $(SUBOBJECTS)
# MACROS END

tmp := $(shell mkdir -p $(BIN_DIR)) # create output bin directory 

all: $(SUBOBJECTS) $(OBJECTS) clean

$(SUBOBJECTS) :
	@echo Creating $@.o
	@$(CC) $(SOURCE_ROOT)/xPro/$@.cpp -c -o $@.o $(FLAGS)

$(OBJECTS) :
	@echo Building xpro.$@
	@$(CC) $(TOOLS_DIR)/$@/main.cpp *.o -o $(BIN_DIR)/xpro.$@ $(FLAGS)

clean :
	@echo Cleaning...
	rm *.o
