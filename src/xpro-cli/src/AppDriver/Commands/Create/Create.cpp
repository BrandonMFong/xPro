/*
 * Create.cpp
 *
 *  Created on: Nov 14, 2021
 *      Author: brandonmfong
 */

#include "Create.hpp"
#include <AppDriver/AppDriver.hpp>
#include <AppDriver/Commands/Commands.h>
#include "UserConfigTemplate.h"

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
	xError 	result 			= kNoError;
	char * 	homePath 		= xNull;
	char * 	configPath 		= xNull;
	FILE * 	file 			= xNull;
	xBool 	okayToContinue 	= xTrue;
	char 	buf[10];

	// Get copy for us
	homePath = xCopyString(
		AppDriver::shared()->xProHomePath(),
		&result
	);

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

		if (strlen(configPath) == 0) result = kStringError;

		// Make sure the home directory exists
		else if (!xIsDir(dirname(configPath))) {
			result = kDirectoryError;
			xLog(
				"%s does not exist. Please run '%s %s' to create xpro home environment",
				dirname(configPath),
				AppDriver::shared()->execName(),
				CREATE_XPRO_ARG
			);
		}
	}

	// If the config file already exists then we need to ask the user what we should do
	if (result == kNoError) {
		if (xIsFile(configPath)) {
			printf("\n%s already exists.", configPath);
			printf("\nYou can either:");
			printf("\n\t- Move the file away from this path");
			printf("\n\t- Continue to overwrite");

			printf("\n\nWould you like to continue [y/N]? ");
			scanf("%9s", buf);

			okayToContinue = !strcmp(buf, "y");
		}
	}

	// Write to file if we can continue
	if (okayToContinue) {
		if (result == kNoError) {
			file 	= fopen(configPath, "w");
			result 	= file != xNull ? kNoError : kFileError;
		}

		if (result == kNoError) {
			if (fputs(USER_CONFIG_TEMPLATE, file) == EOF) {
				result = kWriteError;
				DLog("Could not write to file %s", configPath);
			}

			if (fclose(file) == EOF) {
				DLog("Error closing file %s", configPath);
			}
		}

		if (result == kNoError) {
			xLog("Successfully created: %s", configPath);
		}
	}

	xFree(configPath);
	xFree(homePath);

	if (result != kNoError) {
		DLog("%s Error %d", __func__, result);
	}

	return result;
}
