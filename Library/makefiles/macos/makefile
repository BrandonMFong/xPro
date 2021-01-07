# macos
# https://stackoverflow.com/questions/43465483/makefile-with-c-classes

# MACROS START
CC=g++
LIB_ROOT=./../..
SOURCE_DIR=$(LIB_ROOT)/Sources
xPro_ROOT=$(LIB_ROOT)/..
BIN_DIR=$(xPro_ROOT)/bin
FLAGS = \
	-std=c++17 \
	-I$(LIB_ROOT) \
	-Wall
OBJECTS = \
	enumdir \
	exist \
	selectitem
SUBOBJECTS = \
	xDirectory \
	xPro
ALL = $(OBJECTS) $(SUBOBJECTS)
# MACROS END

tmp := $(shell mkdir -p $(BIN_DIR)) # create output bin directory 

all: xPro xDirectory $(OBJECTS)

xPro : 
	$(CC) $(LIB_ROOT)/xPro/xPro.cpp -c -o xPro.o $(FLAGS)

xDirectory : 
	$(CC) $(LIB_ROOT)/xPro/xDirectory.cpp -c -o xDirectory.o $(FLAGS)


$(OBJECTS) :
	@echo Building $@
	@$(CC) $(SOURCE_DIR)/$@/main.cpp xDirectory.o xPro.o -o $(BIN_DIR)/xpro.$@ $(FLAGS)
