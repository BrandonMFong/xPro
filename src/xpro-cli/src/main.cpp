//============================================================================
// Name        : main.cpp
// Author      :
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C++, Ansi-style
//============================================================================

#include <main.hpp>

int main(int argc, char ** argv) {
	xError 			result 			= kNoError;
	xBool 			okayToContinue 	= xTrue;
	xArguments * 	args 			= xNull;

	// Read arguments
	if (result == kNoError) {
		args = new xArguments(argc, argv, &result);
	}

	// See if the user wants help
	if (result == kNoError) {
		if (args->count() == 1) {
			printf("No arguments\n");

			Help(xFalse);
			okayToContinue 	= xFalse;
		} else if (args->contains(HELP_ARG, &result) && (args->count() > 2)) {
			printf("Too many arguments for %s\n", HELP_ARG);

			Help(xFalse);
			okayToContinue 	= xFalse;
		} else if (args->contains(HELP_ARG, &result)) {
			Help(xTrue);
			okayToContinue 	= xFalse;
		}
	}

	// Run application
	if (okayToContinue && (result == kNoError)) {
		result = Run();
	}

	return result;
}

void Help(xBool moreInfo) {
	xError result 			= kNoError;
	char * executableName 	= xNull;

	if (result == kNoError) {
		executableName = xArguments::shared()->argAtIndex(0, &result);
	}

	if (result == kNoError) {
		executableName = xBasename(executableName, &result);
	}

	if (result == kNoError) {
		printf("usage: %s\t[ %s ] [ %s ] <command> [<args>] \n\n",
				executableName,
				VERSION_ARG,
				HELP_ARG);
		free(executableName);

		printf("List of commands:\n");

		printf("\t%s\treturns directory for alias\n", DIR_ARG);

		printf("\n");
	}

	if (result != kNoError) {
		DLog("help ended in %d", result);
	}
}

xError Run() {
	xError result = kNoError;

	if (result == kNoError) {
		if (xArguments::shared()->contains(DIR_ARG, &result)) {
			result = HandleDirectory();
		}
	}

	return result;
}