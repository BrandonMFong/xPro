
ifeq $($(shell uname), Darwin)
SEP = /
CPP_VERSION = c++17
LSTDC_FLAG = -lstdc++fs
EXT = 
CFLAG = 
else

# Linux
ifeq $($(shell uname),Linux)
SEP = /
CPP_VERSION = c++2a
LSTDC_FLAG = -lstdc++fs
EXT = 
CFLAG = 
endif

# Windows
else
SEP = \\
CPP_VERSION = c++latest
LSTDC_FLAG = 
EXT = .exe
CFLAG = -c
endif

# https://www.cs.swarthmore.edu/~newhall/unixhelp/howto_makefiles.html

# MACROS START
CC=g++
LIB_ROOT=.$(SEP)..
SOURCE_DIR=$(LIB_ROOT)$(SEP)Sources
xPro_ROOT=$(LIB_ROOT)$(SEP)..
BIN_DIR=$(xPro_ROOT)$(SEP)bin
INC=-I$(LIB_ROOT)

# Applications
OBJECTS = \
	enumdir \
	exist \
	selectitem

# MACROS END

tmp := $(shell mkdir -p $(BIN_DIR)) # create output bin directory 

all: $(OBJECTS)

$(OBJECTS) :
	@echo Building $@
	$(CC) $(SOURCE_DIR)$(SEP)$@$(SEP)main.cpp $(LSTDC_FLAG) -std=$(CPP_VERSION) $(INC) $(CFLAG) -Wall -o $(BIN_DIR)$(SEP)xpro.$@$(EXT)
