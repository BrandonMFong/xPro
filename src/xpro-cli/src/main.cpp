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
xError help(void);

int main(int argc, char ** argv) {
	xError result = kNoError;

	if (result == kNoError) {
		args = new xArguments(argc, argv, &result);
	}

	if (result == kNoError) {
		result = run();
	}

	return result;
}

xError run() {
	xError result = kNoError;

	if (result == kNoError) {
		help();
	}

	return result;
}

xError help() {
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
