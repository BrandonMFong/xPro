# macos
# MACROS START
CC=g++
SOURCE_ROOT=./../..
TOOLS_DIR=$(SOURCE_ROOT)/Tools
xPro_ROOT=$(SOURCE_ROOT)/..
BIN_DIR=$(xPro_ROOT)/bin
FLAGS = \
	-std=c++17 \
	-I$(SOURCE_ROOT) \
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
	@$(CC) $(TOOLS_DIR)/$@/main.cpp -o $(BIN_DIR)/xpro.$@ $(FLAGS)
