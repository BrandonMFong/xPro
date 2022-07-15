/*
 * Describe.cpp
 *
 *  Created on: Mar 5, 2022
 *      Author: brandonmfong
 */

#include "Describe.hpp"
#include <AppDriver/AppDriver.hpp>

const char * const COMMAND = "describe";
const char * const BRIEF = "Returns xpro information";
const char * const XPRO_HOME_ARG = "home";
const char * const USER_CONF_ARG = "uconf";
const char * const ENV_CONF_ARG = "uenv";

void Describe::help() {
	printf("Command: %s %s <arg>\n", AppDriver::shared()->execName(), COMMAND);
	printf("\nBrief: %s\n", BRIEF);
	printf("\nDiscussion:\n");
	printf("  Helps user to query environment xpro information\n");
	printf("\nArguments:\n");
	printf("  %s: Path to .xpro where all xPro sources live\n", XPRO_HOME_ARG);
	printf("  %s: Path to active user config\n", USER_CONF_ARG);
	printf("  %s: Path to env.xml\n", ENV_CONF_ARG);
}

xBool Describe::invoked() {
	AppDriver * appDriver = 0;

	if ((appDriver = AppDriver::shared())) {
		return appDriver->args.contains(COMMAND);
	} else {
		return xFalse;
	}
}

const char * Describe::command() {
	return COMMAND;
}

const char * Describe::brief() {
	return BRIEF;
}

Describe::Describe(xError * err) : Command(err) {

}

Describe::~Describe() {

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
			ELog("Please provide argument for %s", COMMAND);
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

