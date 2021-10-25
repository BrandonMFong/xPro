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
xError help(xBool moreInfo);

int main(int argc, char ** argv) {
	xError result = kNoError;
	xBool okayToContinue = xTrue;

	// Read arguments
	if (result == kNoError) {
		args = new xArguments(argc, argv, &result);
	}

	// See if the user wants help
	if (result == kNoError) {
		if (args->count() == 0) {
			result = help(xFalse);
			okayToContinue = xFalse;
		} else if (args->contains(kHelpArg, &result)) {
			result = help(xFalse);
			okayToContinue = xFalse;
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

xError help(xBool moreInfo) {
	xError result = kNoError;
	char * executableName = xNull;

	if (result == kNoError) {
		executableName = args->argAtIndex(0, &result);
	}

	if (result == kNoError) {
		printf("%s", executableName);
	}

	return result;
}
