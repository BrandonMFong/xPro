/*
 * Object.cpp
 *
 *  Created on: Mar 2, 2022
 *      Author: brandonmfong
 */

#include "Object.hpp"
#include <AppDriver/AppDriver.hpp>
#include <AppDriver/Commands/Commands.h>

/**
 * Xml object for the xpro config file
 *
 * This should be allocated and deallocated in HandleObject()
 */
static xXML * xProConfig = xNull;

xError HandleObject(void) {
	xError result = kNoError;
	AppDriver * appDriver = xNull;
	const char * arg = xNull;
	const char * configPath = xNull;

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

	if (result == kNoError) {
		if (!strcmp(arg, OBJ_COUNT_ARG)) {
			result = HandleObjectCount();
		} else if (!strcmp(arg, OBJ_INDEX_VALUE_ARG)) {
			result = HandleObjecValueForIndex();
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

	xUInt64 count = xProConfig->countTags(OBJECT_TAG_PATH, &result);

	if(result != kNoError) {
		count = 0;
		DLog("Could not count for path: '%s'", OBJECT_TAG_PATH);
	}

	printf("%llu\n", count);

	xLog("count");

	return result;
}

xError HandleObjecValueForIndex(void) {
	xError result = kNoError;
	AppDriver * appDriver = xNull;

	appDriver 	= AppDriver::shared();
	result 		= appDriver != xNull ? kNoError : kDriverError;

	xLog("index");

	return result;
}
