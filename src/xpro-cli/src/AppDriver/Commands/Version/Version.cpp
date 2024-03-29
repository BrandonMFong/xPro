/*
 * Version.cpp
 *
 *  Created on: Nov 29, 2021
 *      Author: brandonmfong
 */

#include "Version.hpp"
#include <AppDriver/AppDriver.hpp>

const char * const LONG_ARG = "--long";
const char * const SHORT_ARG = "--short";
const char * const COMMAND = "version";
const char * const BRIEF = "Displays app version";

void Version::help() {
	printf("Command: %s %s <arg>\n", AppDriver::shared()->execName(), COMMAND);
	printf("\nBrief: %s\n", BRIEF);
	printf("\nDiscussion:\n");
	printf("  Displays version with or without build hash\n");
	printf("\nArguments:\n");
	printf("  %s: Displays version with full build hash\n", LONG_ARG);
	printf("  %s: Displays veresion with short build hash\n", SHORT_ARG);
}

const char * Version::command() {
	return COMMAND;
}

const char * Version::brief() {
	return BRIEF;
}

xBool Version::invoked() {
	AppDriver * appDriver = 0;

	if ((appDriver = AppDriver::shared())) {
		return appDriver->args.contains(COMMAND);
	} else {
		return xFalse;
	}
}

Version::Version(xError * err) : Command(err) {

}

Version::~Version() {

}

xError Version::exec() {
	xError 			result 			= kNoError;
	const char *	argString 		= xNull;
	char * 			buildHashString = xNull;

	AppDriver * appDriver 	= AppDriver::shared();
	result 					= appDriver != xNull ? kNoError : kDriverError;

	if (result == kNoError) {
		result = appDriver->args.count() <= 3 ? kNoError : kArgError;
	}

	// Get the build hash string if we have 3 arguments,
	// the 3rd being the short/long arg
	if (result == kNoError) {
		if (appDriver->args.count() == 3) {
			argString = appDriver->args.objectAtIndex(2);

			if (argString == xNull) {
				// make sure we are aware of this
				if (strlen(BUILD) < BUILD_HASH_LENGTH) {
					DLog(
						"The build macro is less than %d "
						"characters.  Please check implmentation.",
						BUILD_HASH_LENGTH
					);

					DLog("actual length: %ld", strlen(BUILD));
				}

				buildHashString = xCopyString(BUILD, &result);
			}

			if (result == kNoError) {
				if (!strcmp(argString, SHORT_ARG)) {

					// Only modify length if we have enough to modify
					if (strlen(buildHashString) >= 10) {
						buildHashString[10] = '\0';
					}
				}

				printf("%s-%s\n", VERSION, buildHashString);
			}

			xFree(buildHashString);
		} else {
			printf("%s\n", VERSION);
		}
	}

	if (result != kNoError) {
		DLog("Error in version handling, %d\n", result);
	}

	return result;
}
