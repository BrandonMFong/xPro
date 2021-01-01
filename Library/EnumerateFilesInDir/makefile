# https://www.cs.swarthmore.edu/~newhall/unixhelp/howto_makefiles.html

# make bin file 
bindir = ./../../bin
tmp := $(shell mkdir -p $(ODIR)) # directory 
# tar := ./../../bin/xpro.enumdir # target
tar := $(bindir)/xpro.enumdir # target

# Linux
ifeq ($(OS),LINUX)
all: main.cpp
	g++ main.cpp -lstdc++fs -std=c++14 -o $(tar)
endif 

# macOS 
ifeq ($(shell uname -s),Darwin) # Assuming this identifies macOS
all: main.cpp
	g++ main.cpp -std=c++14 -c -Wall -Iinclude -o $(tar)
endif

