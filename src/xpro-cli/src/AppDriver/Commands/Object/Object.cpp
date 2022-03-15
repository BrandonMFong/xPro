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
	xError 			result 			= kNoError;
	const char 		* arg 			= xNull,
					* configPath	= xNull;
	const xUInt8	argCount 		= 5; // max arg count

	AppDriver * appDriver 	= AppDriver::shared();
	result 					= appDriver != xNull ? kNoError : kDriverError;

	if (result == kNoError) {
		result = appDriver->args.count() <= argCount ? kNoError : kArgError;

		if (result != kNoError) {
			DLog("The amount of arguments must be %d", argCount);
		}
	}

	// Get the argument after 'obj'
	//
	// this is the argument we are going to use to determine
	// what we are doing next
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

			Log("Argument '%s' is not acceptable", arg);
			Log("Please see '%s' for more information", HELP_ARG);
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
	xError 			result 			= kNoError;
	char 			* tagPath 		= xNull,
					* xmlValue  	= xNull;
	const char 		* indexString 	= xNull,
					* tagPathFormat = xNull;
	xInt8 			argIndex 		= 0;
	xUInt8 			type 			= 0; // Default 0
	const xUInt8 	valueType 		= 1,
					nameType 		= 2;

	AppDriver * appDriver 	= AppDriver::shared();
	result 					= appDriver != xNull ? kNoError : kDriverError;

	// Get the index for the -index argument
	if (result == kNoError) {
		argIndex = appDriver->args.indexForArg(OBJ_INDEX_ARG, &result);

		if (result != kNoError) {
			DLog("Error finding index for arg: %s", OBJ_INDEX_ARG);
		}
	}

	// Get the value for that switch argument
	if (result == kNoError) {
		if ((argIndex + 1) < appDriver->args.count()) {
			indexString = appDriver->args.argAtIndex(argIndex + 1, &result);
		} else {
			result = kOutOfRangeError;

			DLog(
				"There are not enough arguments. We cannot get value for %s",
				OBJ_INDEX_ARG
			);
			Log("Please provide value for '%s'", OBJ_INDEX_ARG);
		}
	}

	// See if index string is a number
	if (result == kNoError) {
		for (
			xUInt8 i = 0;
			(i < strlen(indexString)) && (result == kNoError);
			i++
		) {
			if (!isdigit(indexString[i])) {
				result = kArgError;
			}
		}

		if (result != kNoError) {
			Log("Argument '%s' is not valid", indexString);
			Log("Please provide a positive integer for '%s'", OBJ_INDEX_ARG);
		}
	}

	// Check for supporting argument to determine if we are
	// trying to get the value or name
	if (result == kNoError) {
		if (appDriver->args.contains(OBJ_VALUE_ARG, &result)) {
			if (result == kNoError) {
				type 			= valueType;
				tagPathFormat 	= OBJECT_VALUE_TAG_PATH;
			}
		} else if (appDriver->args.contains(OBJ_NAME_ARG, &result)) {
			if (result == kNoError) {
				type 			= nameType;
				tagPathFormat 	= OBJECT_NAME_TAG_PATH;
			}
		} else {
			Log(
				"Please pass the arguments '%s' or '%s'",
				OBJ_VALUE_ARG,
				OBJ_NAME_ARG
			);
		}
	}

	// Create tag path string
	if (result == kNoError) {
		tagPath = xMallocString(strlen(tagPathFormat) + 20, &result);
	}

	// Construct path with command line arg
	if (result == kNoError) {
		if (type == valueType) {
			if (sprintf(tagPath, tagPathFormat, indexString, appDriver->username()) == -1) {
				result = kStringError;
			}
		} else if (type == nameType) {
			if (sprintf(tagPath, tagPathFormat, indexString) == -1) {
				result = kStringError;
			}
		}
	}

	if (result == kNoError) {
		if (type == valueType) {
#ifndef TESTING
			xmlValue = xProConfig->getValue(
				tagPath,
				&result
			);
#endif
		} else if (type == nameType) {
#ifndef TESTING
			xmlValue = xProConfig->getValue(
				tagPath,
				&result
			);
#endif
		} else {
			// This should have been checked earlier but
			// will throw error either way
			result = kArgError;
			DLog("Error with type variable.  Value is %d", type);
		}

		// Print value from xml if successful
		if (result == kNoError) {
			if (xmlValue == xNull) {
				result = kNullError;

				Log("Nothing found");
				DLog("XML value was returned null");
			}
		}
	}

	if (result == kNoError) {
#ifndef TESTING
		printf("%s\n", xmlValue);
#endif
		xFree(xmlValue);
	}

	xFree(tagPath);

	return result;
}
