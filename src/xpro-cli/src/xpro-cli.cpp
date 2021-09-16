//============================================================================
// Name        : xpro-cli.cpp
// Author      : 
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C++, Ansi-style
//============================================================================

#include <Client/Client.h>

enum xOpCode {
	opGetDir = 0
};

/**
 * Used to hold the operation we will be executing based on the arguments
 */
typedef struct {
	xOpCode code;
} xOpPacket;

xError readArgs(int argc, char ** argv, xOpPacket * op);

int main (int argc, char ** argv) {
	xError error = kNoError;
	Client * client = NULL;
	xOpPacket op;

	if (error == kNoError) {
		client = new Client(&error);

		if (client == NULL) {
			error = kClientError;
		}
	}

	if (error == kNoError) {
		error = readArgs(argc, argv, &op);
	}

	if (error == kNoError) {
		error = client->exec();
	}

	return (int) error;
}

xError readArgs(int argc, char ** argv, xOpPacket * op) {
	xError result = kNoError;

	return result;
}
