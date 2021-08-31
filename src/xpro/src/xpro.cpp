//============================================================================
// Name        : xPro.cpp
// Author      : 
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C++, Ansi-style
//============================================================================

#include <Server/Server.h>

int main() {
	xError error = kNoError;
	Server * heimdall = NULL;

	if (error == kNoError) {
		heimdall = new Server(&error);

		if (heimdall == NULL) {
			error = kServerError;
		}
	}

	if (error == kNoError) {
		error = heimdall->listen();
	}

	return (int) error;
}
