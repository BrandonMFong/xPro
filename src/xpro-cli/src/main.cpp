//============================================================================
// Name        : main.cpp
// Author      :
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C++, Ansi-style
//============================================================================

#include "xLib.h"

#define kHelpArg "--help"
#define kDirArg "dir"

xUInt8 numArg = 0;
char ** arguments = xNull;

xError SaveArgs(int argc, char ** argv);
bool ArgsContain(const char * arg, xError * err);

xError run(void);
xError help(void);

int main(int argc, char ** argv) {
	xError result = kNoError;

	if (result == kNoError) {
		result = SaveArgs(argc, argv);
	}

	return run();
}

xError run() {
	xError result = kNoError;

	if (result == kNoError) {

	}

	return result;
}

xError help() {
	xError result = kNoError;

	if (result == kNoError) {
		result = arguments[0] != xNull ? kNoError : kArgError;
	}

	if (result == kNoError) {
		printf("");
	}

	return result;
}

xError SaveArgs(int argc, char ** argv)
{
	xError result = kNoError;

	if (result == kNoError) {
		arguments 	= (char **) malloc(sizeof(char *) * argc);
		result 		= arguments != xNull ? kNoError : kUnknownError;
	}

	for (xUInt8 i = 0; i < argc; i++) {
//		if (result == kNoError) {
//			arguments[i] 	= (char *) malloc(sizeof(char) * (strlen(argv[i]) + 1));
//			result 			= arguments[i] != xNull ? kNoError : kUnknownError;
//		}
//
//		if (result == kNoError) {
//			if (strcpy(arguments[i], argv[i]) == xNull) {
//				result = kArgError;
//				DLog("Error trying to copy argument");
//			}
//		}
//
//		if (result == kNoError) {
//			if (strcmp(arguments[i], argv[i])) {
//				result = kArgError;
//				DLog("Strings do not match, %s != %s", arguments[i], argv[i]);
//			}
//		}

		if (result == kNoError) {
			arguments[i] = xCopyString(argv[i], &result);
		}

		if (result != kNoError) break;
	}

	if (result == kNoError) {
		numArg = argc; // Save count
	}

	return result;
}

bool ArgsContain(const char * arg, xError * err) {
	bool result = false;
	xError error = kNoError;
	char * tempArg = xNull;

	for (xUInt8 i = 0; i < numArg; i++) {
		if (error == kNoError) {
			tempArg = arguments[i];
			error = tempArg != xNull ? kNoError : kArgError;
		}

		if (error == kNoError) {
			result = !strcmp(arg, tempArg);
		}

		// Move on if there was an error or if we found the arg
		if ((error != kNoError) || result) break;
	}

	return result;
}
