# makefile: apple  
# https://stackoverflow.com/questions/42015121/exec-format-error-running-a-binary-created-by-g
# https://www.cs.swarthmore.edu/~newhall/unixhelp/howto_makefiles.html

# MACROS START
LIB_ROOT=./../..
SOURCE_DIR=$(LIB_ROOT)/Sources
xPro_ROOT=$(LIB_ROOT)/..
BIN_DIR=$(xPro_ROOT)/bin
INC=-I$(LIB_ROOT)

# enumdir
ENUMDIR_APPNAME = enumdir
ENUMDIR_TARGET_DIR := $(SOURCE_DIR)/$(ENUMDIR_APPNAME)
ENUMDIR_STD_FLAG = c++14
ENUMDIR_APP = xpro.$(ENUMDIR_APPNAME)

# exist
EXIST_APPNAME = exist
EXIST_TARGET_DIR := $(SOURCE_DIR)/$(EXIST_APPNAME)
EXIST_STD_FLAG = c++14
EXIST_APP = xpro.$(EXIST_APPNAME)

# selectitem
SELECTITEM_APPNAME = selectitem
SELECTITEM_TARGET_DIR := $(SOURCE_DIR)/$(SELECTITEM_APPNAME)
SELECTITEM_STD_FLAG = c++14
SELECTITEM_APP = xpro.$(SELECTITEM_APPNAME)
# MACROS START

tmp := $(shell mkdir -p $(BIN_DIR)) # create output bin directory 

# make
all: $(ENUMDIR_APP) \
	$(EXIST_APP) \
	$(SELECTITEM_APP)

$(ENUMDIR_APP) : $(ENUMDIR_TARGET_DIR)/main.cpp
	@echo Building $(ENUMDIR_APP)
	g++ $(ENUMDIR_TARGET_DIR)/main.cpp -std=$(ENUMDIR_STD_FLAG) -Wall $(INC) -o $(BIN_DIR)/$(ENUMDIR_APP)

$(EXIST_APP) : $(EXIST_TARGET_DIR)/main.cpp
	@echo Building $(EXIST_APP)
	g++ $(EXIST_TARGET_DIR)/main.cpp -std=$(EXIST_STD_FLAG) -Wall $(INC) -o $(BIN_DIR)/$(EXIST_APP)



$(SELECTITEM_APP) : $(SELECTITEM_TARGET_DIR)/main.cpp
	@echo Building $(SELECTITEM_APP)
	g++ $(SELECTITEM_TARGET_DIR)/main.cpp -std=$(SELECTITEM_STD_FLAG) -Wall $(INC) -o $(BIN_DIR)/$(SELECTITEM_APP)