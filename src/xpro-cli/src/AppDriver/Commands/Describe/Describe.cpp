/*
 * Describe.cpp
 *
 *  Created on: Mar 5, 2022
 *      Author: brandonmfong
 */


#include "Describe.hpp"
#include <AppDriver/AppDriver.hpp>
#include <AppDriver/Commands/Commands.h>

xError HandleDescribe() {
	xError 			result 		= kNoError;
	const xUInt8 	argCount 	= 3;
	const char * 	argString 	= xNull;

	AppDriver * appDriver 	= AppDriver::shared();
	result 					= appDriver != xNull ? kNoError : kDriverError;

	if (result == kNoError) {
		result = appDriver->args.count() == argCount ? kNoError : kArgError;

		if (result != kNoError) {
			ELog("Please provide argument for %s", DESCRIBE_ARG);
		}
	}

	if (result == kNoError) {
		argString = appDriver->args.argAtIndex(2, &result);
	}

	if (result == kNoError) {
		if (!strcmp(argString, XPRO_HOME_ARG)) {
			printf("%s\n", appDriver->xProHomePath());
		} else if (!strcmp(argString, USER_CONF_ARG)) {
			printf("%s\n", appDriver->configPath());
		} else if (!strcmp(argString, ENV_CONF_ARG)) {
			printf("%s/%s\n", appDriver->xProHomePath(), ENV_CONFIG_NAME);
		} else {
			result = kArgError;
			ELog("Unknown argument '%s'", argString);
		}
	}

	if (result != kNoError) {
		DLog("Error with %s, %d", __FUNCTION__, result);
	}

	return result;
}

