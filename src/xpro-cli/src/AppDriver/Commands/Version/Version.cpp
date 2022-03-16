/*
 * Version.cpp
 *
 *  Created on: Nov 29, 2021
 *      Author: brandonmfong
 */

#include "Version.hpp"
#include <Utilities/Utilities.h>
#include <AppDriver/AppDriver.hpp>
#include <AppDriver/Commands/Commands.h>

xError HandleVersion() {
	xError 			result 			= kNoError;
	const char *	argString 		= xNull;
	char * 			buildHashString = xNull;
	xBool			printWithHash	= xFalse;

	AppDriver * appDriver 	= AppDriver::shared();
	result 					= appDriver != xNull ? kNoError : kDriverError;

	if (result == kNoError) {
		result = appDriver->args.count() <= 3 ? kNoError : kArgError;
	}

	// Get the build hash string if we have 3 arguments,
	// the 3rd being the short/long arg
	if (result == kNoError) {
		if (appDriver->args.count() == 3) {
			argString = appDriver->args.argAtIndex(2, &result);

			if (result == kNoError) {
				buildHashString = xCopyString(BUILD, &result);
			}

			if (result == kNoError) {
				if (!strcmp(argString, SHORT_ARG)) {
					buildHashString[10] = '\0';
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
