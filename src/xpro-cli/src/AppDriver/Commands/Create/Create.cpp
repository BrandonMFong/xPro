/*
 * Create.cpp
 *
 *  Created on: Nov 14, 2021
 *      Author: brandonmfong
 */

#include "Create.hpp"
#include <AppDriver/AppDriver.hpp>
#include <AppDriver/Commands/Commands.h>

xError HandleCreate(void) {
	xError 			result 		= kNoError;
	AppDriver * 	appDriver 	= xNull;
	const char * 	subCommand 	= xNull;

	appDriver 	= AppDriver::shared();
	result 		= appDriver != xNull ? kNoError : kNullError;

	if (result == kNoError) {
		result = appDriver->args.count() <= 3 ? kNoError : kNullError;
	}

	if (result == kNoError) {
		subCommand = appDriver->args.argAtIndex(2, &result);
	}

	if (result == kNoError) {
		if (!strcmp(subCommand, CREATE_XPRO_ARG)) {
			result = CreateXProHomePath();
		} else if (!strcmp(subCommand, CREATE_USER_CONF_ARG)) {
			result = CreateUserConfig();
		} else {
			xLog("Unknown argument: %s", subCommand);
			xLog(
				"Please run '%s %s' for help",
				AppDriver::shared()->execName(),
				HELP_ARG
			);
		}
	}

	return result;
}

xError CreateXProHomePath(void) {
	xError 		result 		= kNoError;
	AppDriver * appDriver 	= xNull;

	appDriver 	= AppDriver::shared();
	result 		= appDriver != xNull ? kNoError : kNullError;

	if (xIsDir(appDriver->xProHomePath())) {
		printf("%s already exists\n", appDriver->xProHomePath());
	} else {
		result = xMkDir(appDriver->xProHomePath());

		if (result == kNoError) {
			printf("Successfully created %s\n", appDriver->xProHomePath());
		}
	}

	return result;
}

xError CreateUserConfig(void) {
	xError result = kNoError;
	char * homePath = xNull;
	char * configPath = xNull;

	// Get copy for us
	homePath = xCopyString(AppDriver::shared()->xProHomePath(), &result);

	if (result == kNoError) {
		configPath = (char *) malloc(
				strlen(homePath)
			+ 	strlen(DEFAULT_CONFIG_NAME)
			+ 	2
		);

		result = configPath != xNull ? kNoError : kUnknownError;
	}

	if (result == kNoError) {
		sprintf(configPath, "%s/%s", homePath, DEFAULT_CONFIG_NAME);

		DLog("Creating path %s", configPath);
	}

	xFree(configPath);
	xFree(homePath);

	if (result != kNoError) {
		DLog("%s Error %d", __func__, result);
	}

	return result;
}
