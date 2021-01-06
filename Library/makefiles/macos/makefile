# macos
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
# MACROS END

tmp := $(shell mkdir -p $(BIN_DIR)) # create output bin directory 

all: $(OBJECTS)

$(OBJECTS) :
	@echo Building $@
	@$(CC) $(SOURCE_DIR)/$@/main.cpp -o $(BIN_DIR)/xpro.$@ $(FLAGS)
