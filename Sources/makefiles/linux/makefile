# Linux
# MACROS START
CC=g++
LIB_ROOT=./../..
TOOLS_DIR=$(LIB_ROOT)/Tools
xPro_ROOT=$(LIB_ROOT)/..
BIN_DIR=$(xPro_ROOT)/bin
FLAGS = \
	-lstdc++fs \
	-std=c++2a \
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

all: $(SUBOBJECTS) $(OBJECTS) clean

$(SUBOBJECTS) :
	@echo Creating $@.o
	@$(CC) $(LIB_ROOT)/xPro/$@.cpp -c -o $@.o $(FLAGS)

$(OBJECTS) :
	@echo Building xpro.$@
	@$(CC) $(TOOLS_DIR)/$@/main.cpp *.o -o $(BIN_DIR)/xpro.$@ $(FLAGS)

clean :
	@echo Cleaning...
	rm *.o