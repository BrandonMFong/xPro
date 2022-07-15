/*
 * Describe.cpp
 *
 *  Created on: Mar 5, 2022
 *      Author: brandonmfong
 */

#include "Describe.hpp"
#include <AppDriver/AppDriver.hpp>
#include <AppDriver/Commands/Commands.h>

const char * const XPRO_HOME_ARG = "home";
const char * const USER_CONF_ARG = "uconf";
const char * const ENV_CONF_ARG = "uenv";

xBool Describe::commandInvoked() {
	AppDriver * appDriver = 0;

	if ((appDriver = AppDriver::shared())) {
		return appDriver->args.contains(DESCRIBE_ARG);
	} else {
		return xFalse;
	}
}

Describe::Describe(xError * err) : Command(err) {

}

Describe::~Describe() {

}

void Describe::help() {
	printf("Command: %s %s <arg>\n", AppDriver::shared()->execName(), DESCRIBE_ARG);
	printf("\nBrief: %s\n", DESCRIBE_ARG_BRIEF);
	printf("\nDiscussion:\n");
	printf("  %s\n", DESCRIBE_ARG_DISCUSSION);
	printf("\nArguments:\n");
	printf("  %s: %s\n", XPRO_HOME_ARG, DESCRIBE_XPRO_ARG_INFO);
	printf("  %s: %s\n", USER_CONF_ARG, DESCRIBE_USER_CONF_ARG_INFO);
	printf("  %s: %s\n", ENV_CONF_ARG, DESCRIBE_ENV_CONF_ARG_INFO);
}

xError Describe::exec() {
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
		argString = appDriver->args.objectAtIndex(2);
		result = argString != xNull ? kNoError : kArgError;
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

