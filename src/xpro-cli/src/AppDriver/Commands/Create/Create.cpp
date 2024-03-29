/*
 * Create.cpp
 *
 *  Created on: Nov 14, 2021
 *      Author: brandonmfong
 */

#include "Create.hpp"
#include <AppDriver/AppDriver.hpp>
#include <AppDriver/Commands/Help/Help.hpp>
#include "ConfigTemplate.h"

const char * const XPRO_HOME_ARG = "home";
const char * const USER_CONF_ARG = "uconf";
const char * const ENV_CONF_ARG = "uenv";
const char * const COMMAND = "create";
const char * const BRIEF = "Creates based arguments";

void Create::help() {
	printf("Command: %s %s <arg>\n", AppDriver::shared()->execName(), COMMAND);
	printf("\nBrief: %s\n", BRIEF);
	printf("\nDiscussion:\n");
	printf("  Helps user create their xpro environment\n");
	printf("\nArguments:\n");
	printf("  %s: Creates .xpro at home path\n", XPRO_HOME_ARG);
	printf("  %s: Creates the 'user.xml' user config file with a basic template\n", USER_CONF_ARG);
	printf("  %s: Creates the '%s' environment config file\n", ENV_CONF_ARG, ENV_CONFIG_NAME);
}

const char * Create::command() {
	return COMMAND;
}

const char * Create::brief() {
	return BRIEF;
}

const char * Create::environmentConfigName() {
	return ENV_CONF_ARG;
}

xBool Create::invoked() {
	AppDriver * appDriver = 0;

	if ((appDriver = AppDriver::shared())) {
		return appDriver->args.contains(COMMAND);
	} else {
		return xFalse;
	}
}

Create::Create(xError * err) : Command(err) {

}

Create::~Create() {

}

xError Create::exec() {
	xError 			result 		= kNoError;
	AppDriver * 	appDriver 	= xNull;
	const char * 	subCommand 	= xNull;

	appDriver 	= AppDriver::shared();
	result 		= appDriver != xNull ? kNoError : kDriverError;

	if (result == kNoError) {
		result = appDriver->args.count() <= 3 ? kNoError : kArgError;
	}

	if (result == kNoError) {
		subCommand = appDriver->args.objectAtIndex(2);
		result = subCommand != xNull ? kNoError : kArgError;
	}

	if (result == kNoError) {
		if (!strcmp(subCommand, XPRO_HOME_ARG)) {
			result = CreateXProHomePath();
		} else if (!strcmp(subCommand, USER_CONF_ARG)) {
			result = CreateUserConfig();
		} else if (!strcmp(subCommand, ENV_CONF_ARG)) {
			result = CreateEnvironmentConfig();
		} else {
			Log("Unknown argument: %s", subCommand);
			Log(
				"Please run '%s %s' for help",
				AppDriver::shared()->execName(),
				Help::command()
			);
		}
	}

	return result;
}

xError Create::CreateXProHomePath(void) {
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

xError Create::CreateUserConfig(void) {
	xError 	result 			= kNoError;
	char * 	homePath 		= xNull;
	char * 	configPath 		= xNull;

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

		result = WriteToFile(USER_CONFIG_TEMPLATE, configPath);
	}

	xFree(configPath);
	xFree(homePath);

	if (result != kNoError) {
		DLog("%s Error %d", __func__, result);
	}

	return result;
}

xError Create::CreateEnvironmentConfig(void) {
	xError 	result 			= kNoError;
	char * 	homePath 		= xNull;
	char * 	envPath 		= xNull;

	// Get copy for us
	homePath = xCopyString(
		AppDriver::shared()->xProHomePath(),
		&result
	);

	if (result == kNoError) {
		envPath = (char *) malloc(
				strlen(homePath)
			+ 	strlen(ENV_CONFIG_NAME)
			+ 	2
		);

		result = envPath != xNull ? kNoError : kUnknownError;
	}

	if (result == kNoError) {
		sprintf(envPath, "%s/%s", homePath, ENV_CONFIG_NAME);

		result = WriteToFile(ENV_CONFIG_TEMPLATE, envPath);
	}

	xFree(envPath);
	xFree(homePath);

	if (result != kNoError) {
		DLog("%s Error %d", __func__, result);
	}

	return result;
}

xError Create::WriteToFile(
	const char * content,
	const char * filePath
) {
	xError 	result 			= kNoError;
	FILE * 	file 			= xNull;
	xBool 	okayToContinue 	= xTrue;
	char *	filePathCopy	= xNull;
	char 	buf[10];

	if (strlen(filePath) == 0) result = kStringError;

	// Create copy so that dirname does not modify param
	if (result == kNoError) {
		filePathCopy = xCopyString(filePath, &result);
	}

	// Make sure the home directory exists
	else if (!xIsDir(dirname(filePathCopy))) {
		result = kDirectoryError;
		Log(
			"%s does not exist. Please run '%s %s' to create xpro home environment",
			dirname((char *) filePath),
			AppDriver::shared()->execName(),
			XPRO_HOME_ARG
		);
	}

	xFree(filePathCopy);

	// If the config file already exists then we need to ask the user what we should do
	if (result == kNoError) {
		if (xIsFile((char *) filePath)) {
			printf("\n%s already exists.", filePath);
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
			file 	= fopen(filePath, "w");
			result 	= file != xNull ? kNoError : kFileError;
		}

		if (result == kNoError) {
			if (fputs(content, file) == EOF) {
				result = kWriteError;
				DLog("Could not write to file %s", filePath);
			}

			if (fclose(file) == EOF) {
				DLog("Error closing file %s", filePath);
			}
		}

		if (result == kNoError) {
			Log("Successfully created: %s", filePath);
		}
	}

	if (result != kNoError) {
		DLog("%s Error %d", __func__, result);
	}

	return result;
}
