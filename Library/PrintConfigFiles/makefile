# https://www.cs.swarthmore.edu/~newhall/unixhelp/howto_makefiles.html

# make bin file 
ODIR = ./../../bin/
dummy_build_folder := $(shell mkdir -p $(ODIR)) # TODO add this to all:

# Linux
ifeq ($(OS),LINUX)
all: main.cpp
	g++ main.cpp -lstdc++fs -std=c++14 -o ./../../bin/xpro.listdir

endif 

# macOS 
ifeq ($(shell uname -s),Darwin) # Assuming this identifies macOS
all: main.cpp
	g++ main.cpp -std=c++14 -o ./../../bin/xpro.listdir

endif

