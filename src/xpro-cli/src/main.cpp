//============================================================================
// Name        : main.cpp
// Author      :
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C++, Ansi-style
//============================================================================

#include <xLib.h>

#define HELP_ARG "--help"
#define DIR_ARG "dir"
#define VERSION_ARG "--version"

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
			printf("No arguments\n\n");

			help(xFalse);
			okayToContinue 	= xFalse;
		} else if (args->contains(HELP_ARG, &result) && (args->count() > 2)) {
			printf("Too many arguments for %s\n\n", HELP_ARG);

			help(xFalse);
			okayToContinue 	= xFalse;
		} else if (args->contains(HELP_ARG, &result)) {
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
		executableName = xBasename(executableName, &result);
	}

	if (result == kNoError) {
		printf("usage: %s\t[ %s ] [ %s ] <command> [<args>] \n\n",
				executableName,
				VERSION_ARG,
				HELP_ARG);

		printf("List of commands:\n");

		printf("\t%s\treturns directory for alias", DIR_ARG);

		printf("\n");

		free(executableName);
	}

	if (result != kNoError) {
		DLog("help ended in %d", result);
	}
}
