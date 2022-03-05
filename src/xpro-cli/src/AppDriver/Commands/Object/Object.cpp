/*
 * Object.cpp
 *
 *  Created on: Mar 2, 2022
 *      Author: brandonmfong
 */

#include "Object.hpp"
#include <AppDriver/AppDriver.hpp>
#include <AppDriver/Commands/Commands.h>
#include <ctype.h>

/**
 * Xml object for the xpro config file
 *
 * This should be allocated and deallocated in HandleObject()
 */
static xXML * xProConfig = xNull;

xError HandleObject(void) {
	xError 		result 			= kNoError;
	AppDriver 	* appDriver 	= xNull;
	const char 	* arg 			= xNull;
	const char 	* configPath 	= xNull;

	appDriver 	= AppDriver::shared();
	result 		= appDriver != xNull ? kNoError : kDriverError;

	if (result == kNoError) {
		result = appDriver->args.count() <= 5 ? kNoError : kArgError;

		if (result != kNoError) {
#ifndef TESTING
			DLog("The amount of arguments must be 3");
#endif
		}
	}

	if (result == kNoError) {
		arg = appDriver->args.argAtIndex(2, &result);
	}

#ifndef TESTING

	// Get the config file
	if (result == kNoError) {
		configPath 	= appDriver->configPath();
		result 		= configPath != xNull ? kNoError : kUserConfigPathError;
	}

	if (result == kNoError) {
		if (xProConfig == xNull) {
			xProConfig = new xXML(configPath, &result);
		} else {
			result = kXMLError;
			DLog("xPro config has already been read unexpectedly\n");
		}
	}

#endif

	if (result == kNoError) {
		if (!strcmp(arg, OBJ_COUNT_ARG)) {
#ifndef TESTING
			result = HandleObjectCount();
#endif
		} else if (!strcmp(arg, OBJ_INDEX_ARG)) {
#ifndef TESTING
			result = HandleObjectIndex();
#endif
		} else {
			result = kArgError;

#ifndef TESTING
			xLog("Argument '%s' is not acceptable", arg);
			xLog("Please see '%s' for more information", HELP_ARG);
#endif
		}
	}

	xDelete(xProConfig);

	return result;
}

xError HandleObjectCount(void) {
	xError result = kNoError;

	xUInt64 count = xProConfig->countTags(
		OBJECT_TAG_PATH,
		&result
	);

	if(result != kNoError) {
		count = 0;
		DLog("Could not count for path: '%s'", OBJECT_TAG_PATH);
	}

	printf("%llu\n", count);

	return result;
}

xError HandleObjectIndex(void) {
	xError result = kNoError;
	char * tagPath = xNull;
	char * name  = xNull;
	const char * indexString = NULL;
	xInt8 argIndex = 0;

	AppDriver * appDriver 	= AppDriver::shared();
	result 					= appDriver != xNull ? kNoError : kDriverError;

	if (result == kNoError) {
		argIndex = appDriver->args.indexForArg(OBJ_INDEX_ARG, &result);

		if (result != kNoError) {
			DLog("Error finding index for arg: %s", OBJ_INDEX_ARG);
		}
	}

	if (result == kNoError) {
		if ((argIndex + 1) < appDriver->args.count()) {
			indexString = appDriver->args.argAtIndex(argIndex + 1, &result);
		} else {
			result = kOutOfRangeError;
			DLog(
				"There is not enough arguments. We cannot get value for %s",
				OBJ_INDEX_ARG
			);
		}
	}

	// See if index string is a number
	if (result == kNoError) {
		for (
			xUInt8 i = 0;
			i < strlen(indexString) && (result == kNoError);
			i++
		) {
			if (!isdigit(indexString[i])) {
				result = kArgError;
			}
		}

		if (result != kNoError) {
#ifndef TESTING
			xLog("Argument '%s' is not valid", indexString);
			xLog("Please provide a positive integer for '%s'", OBJ_INDEX_ARG);
#endif
		}
	}

	if (result == kNoError) {
		tagPath = xMallocString(strlen(OBJECT_NAME_TAG_PATH) + 10, &result);
	}

	if (result == kNoError) {
		if (sprintf(tagPath, OBJECT_NAME_TAG_PATH, "0") == -1) {
			result = kStringError;
		}
	}

	if (result == kNoError) {
#ifndef TESTING
		name = xProConfig->getValue(
			tagPath,
			&result
		);

		if (result == kNoError) {
			xFree(name);
		}
#endif
	}

	xFree(tagPath);

	return result;
}
