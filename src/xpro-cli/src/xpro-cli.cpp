//============================================================================
// Name        : xpro-cli.cpp
// Author      : 
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C++, Ansi-style
//============================================================================

#include <Client/Client.h>

#define xMaxArgs 2

xFlag helloFlag = {.name = "hello"};

xFlag * flags[1] = {&helloFlag};

xArgs args = {
	.flags = flags
};

int main (int argc, char ** argv) {
	xError error = kNoError;
	Client * client = NULL;

	if (error == kNoError) {
		error = readArgs(argc, argv, args);
	}

	if (error == kNoError) {
		client = new Client(&error);

		if (client == NULL) {
			error = kClientError;
		}
	}

	if (error == kNoError) {
		error = client->exec();
	}

	return (int) error;
}
