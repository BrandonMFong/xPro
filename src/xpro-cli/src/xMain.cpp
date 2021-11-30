//============================================================================
// Name        : main.cpp
// Author      :
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C++, Ansi-style
//============================================================================

#include <AppDriver/AppDriver.hpp>

int xMain(int argc, char ** argv) {
	xError 		result = kNoError;
	AppDriver 	appDriver(argc, argv, &result);

	if (result == kNoError) {
		result = appDriver.run();
	}

	return result;
}
