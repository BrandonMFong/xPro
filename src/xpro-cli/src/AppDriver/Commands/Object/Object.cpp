/*
 * Object.cpp
 *
 *  Created on: Mar 2, 2022
 *      Author: brandonmfong
 */

#include "Object.hpp"
#include <AppDriver/AppDriver.hpp>
#include <AppDriver/Commands/Commands.h>

xError HandleObject(void) {
	xError 		result = kNoError;
	AppDriver * appDriver = xNull;
	const char * arg = xNull;

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

	return result;
}

xError HandleObjectCount(void) {
	xError result = kNoError;

	xLog("count");

	return result;
}

xError HandleObjecValueForIndex(void) {
	xError result = kNoError;

	xLog("index");

	return result;
}
