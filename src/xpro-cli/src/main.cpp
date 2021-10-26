//============================================================================
// Name        : main.cpp
// Author      :
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C++, Ansi-style
//============================================================================

#include <xLib.h>
#include "xArgs.h"

#define kHelpArg "--help"
#define kDirArg "dir"

xArguments * args = xNull;

xError run(void);
void help(xBool moreInfo);

int main(int argc, char ** argv) {
	xError result = kNoError;
	xBool okayToContinue = xTrue;

	// Read arguments
	if (result == kNoError) {
		args = new xArguments(argc, argv, &result);
	}

	// See if the user wants help
	if (result == kNoError) {
		if (args->count() == 1) {
			printf("No arguments\n");

			help(xFalse);
			okayToContinue 	= xFalse;
		} else if (args->contains(kHelpArg, &result) && (args->count() > 2)) {
			printf("Too many arguments for %s\n", kHelpArg);

			help(xFalse);
			okayToContinue 	= xFalse;
		} else if (args->contains(kHelpArg, &result)) {
			help(xTrue);
			okayToContinue 	= xFalse;
		}
	}

	// Run application
	if (okayToContinue && (result == kNoError)) {
		result = run();
	}

	return result;
}

xError run() {
	xError result = kNoError;

	if (result == kNoError) {

	}

	return result;
}

void help(xBool moreInfo) {
	xError result = kNoError;
	char * executableName = xNull;

	if (result == kNoError) {
		executableName = args->argAtIndex(0, &result);
	}

	if (result == kNoError) {
		printf("%s", executableName);
	}

	if (result != kNoError) {
		DLog("help ended in %d", result);
	}
}
