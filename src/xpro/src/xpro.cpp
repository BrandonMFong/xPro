//============================================================================
// Name        : xpro.cpp
// Author      : 
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C++, Ansi-style
//============================================================================

#include <Driver/Driver.h>

int main() {
	xError error = kNoError;
	Driver * driver = NULL;

	if (error == kNoError) {
		driver = new Driver();

		if (driver == NULL) {
			error = kNULLError;
		} else {
			error = driver->status;
		}
	}
	std::cout << "!!!Hello World!!!" << std::endl; // prints !!!Hello World!!!
	return 0;
}
