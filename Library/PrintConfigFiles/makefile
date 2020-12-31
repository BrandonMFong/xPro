# https://www.cs.swarthmore.edu/~newhall/unixhelp/howto_makefiles.html

# Linux
ifeq ($(OS),LINUX)
# create directory
ODIR = ./../../bin/
dummy_build_folder := $(shell mkdir -p $(ODIR)) # TODO add this to all:

# -std=c++14 is to fix -Wc++11-extensions error
# TODO figure out how to pass condition flags based on system 
# main.cpp:38:16: warning: 'auto' type specifier is a C++11 extension [-Wc++11-extensions]
#     for (const auto & entry : fs::directory_iterator(path)) 
#                ^
# main.cpp:38:31: error: use of undeclared identifier 'fs'
#     for (const auto & entry : fs::directory_iterator(path)) 
#                               ^
# main.cpp:38:29: warning: range-based for loop is a C++11 extension [-Wc++11-extensions]
	# for (const auto & entry : fs::directory_iterator(path)) 
all: main.cpp
	g++ main.cpp -lstdc++fs -std=c++14 -o ./../../bin/xpro.listdir

# macOS
else ifeq ($(OS),Darwin)
# create directory
ODIR = ./../../bin/
dummy_build_folder := $(shell mkdir -p $(ODIR)) # TODO add this to all:

# -std=c++14 is to fix -Wc++11-extensions error
# TODO figure out how to pass condition flags based on system 
# main.cpp:38:16: warning: 'auto' type specifier is a C++11 extension [-Wc++11-extensions]
#     for (const auto & entry : fs::directory_iterator(path)) 
#                ^
# main.cpp:38:31: error: use of undeclared identifier 'fs'
#     for (const auto & entry : fs::directory_iterator(path)) 
#                               ^
# main.cpp:38:29: warning: range-based for loop is a C++11 extension [-Wc++11-extensions]
	# for (const auto & entry : fs::directory_iterator(path)) 
all: main.cpp
	g++ main.cpp -lstdc++fs -std=c++14 -o ./../../bin/xpro.listdir

endif

