//============================================================================
// Name        : xpro-cli.cpp
// Author      : 
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C++, Ansi-style
//============================================================================

#include <Client/Client.h>

int main (int argc, char ** argv) {
	xError error = kNoError;
	Client * client = NULL;

	if (error == kNoError) {
		client = new Client(&error);

		if (client == NULL) {
			error = kClientError;
		}
	}

	if (error == kNoError) {
		error = client->readArgs(argc, argv);
	}

	if (error == kNoError) {
		error = client->exec();
	}

	return (int) error;
}
