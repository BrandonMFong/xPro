//============================================================================
// Name        : xpro-cli.cpp
// Author      : 
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C++, Ansi-style
//============================================================================

#include <Client/Client.h>

#define xMaxArgs 2

xFlag clientFlag = {.name = "client"};
xFlag serverFlag = {.name = "server"};

xFlag * flags[2] = {&clientFlag, &serverFlag};

xArgs args = {
	.flags = flags,
	.flagCount = (sizeof(flags)/sizeof(flags[0]))
};

xError run(void);

int main (int argc, char ** argv) {
	xError error = kNoError;

	if (error == kNoError) {
		error = readArgs(argc, argv, args);
	}

	if (error == kNoError) {
		error = run();
	}

	return (int) error;
}

xError run() {
	xError result = kNoError;
	Client * client = xNull;

	if (result == kNoError) {
		if (serverFlag.passed) {
			if (result == kNoError) {
				client = new Client(&result);

				if (client == NULL) {
					result = kClientError;
				}
			}

			if (result == kNoError) {
				result = client->exec();
			}
		} else if (clientFlag.passed) {
			printf("Hello from Client!\n");
		}
	}

	return result;
}
