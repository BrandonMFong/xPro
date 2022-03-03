/*
 * AppDriver.cpp
 *
 *  Created on: Nov 14, 2021
 *      Author: brandonmfong
 */

#include "AppDriver.hpp"
#include <AppDriver/Commands/Commands.h>
#include <Utilities/Utilities.h>

AppDriver * globalAppDriver = xNull;

AppDriver::AppDriver(
	xInt8 		argc,
	char ** 	argv,
	xError * 	err
) : args(argc, argv, err) {
	xError result = *err;

	this->_userInfo.configPath 	= xNull;
	this->_userInfo.username 	= xNull;

	if (err != xNull) {
		result = *err;
	}

	if (result == kNoError) {
		result = this->setup();
	}

	if (result != kNoError) {
		DLog("Shared args is null");
	} else {
		globalAppDriver = this;
	}

	if (err != xNull) {
		*err = result;
	}
}

AppDriver::~AppDriver() {
	xFree(this->_userInfo.username);
	xFree(this->_userInfo.configPath);

	globalAppDriver = xNull;
}

AppDriver * AppDriver::shared() {
	return globalAppDriver;
}

xError AppDriver::setup() {
	xError 	result 		= kNoError;
	xXML 	* envConfig = xNull;
	char 	* homeDir 	= xNull,
			* envPath 	= xNull;

	// Get home path for current user
	homeDir = xHomePath(&result);

	if (result == kNoError) {
		this->_xProHomePath = (char *) malloc(
			strlen(homeDir) +
			strlen(XPRO_HOME_DIR_NAME)
			+ 2
		);

		result = this->_xProHomePath != xNull ? kNoError : kUnknownError;
	}

	// construct path to the .xpro directory.  It should live in the user's home directory
	if (result == kNoError) {
		sprintf(this->_xProHomePath, "%s/%s", homeDir, XPRO_HOME_DIR_NAME);
		xFree(homeDir);

		if (strlen(this->_xProHomePath) == 0) {
			DLog("Unknown behavior, resulted in empty string");
			result = kEmptyStringError;
		}
	}

	if (result == kNoError) {
		envPath = (char *) malloc(
				strlen(this->_xProHomePath)
			+ 	strlen(ENV_CONFIG_NAME)
			+ 	2
		);

		result = envPath != xNull ? kNoError : kUnknownError;
	}

	// Construct path the env.xml file
	if (result == kNoError) {
		sprintf(envPath, "%s/%s", this->_xProHomePath, ENV_CONFIG_NAME);

		if (strlen(envPath) == 0) {
			DLog("Unknown behavior, resulted in empty string");
			result = kEmptyStringError;
		}
	}

	// Only do the following if the env.xml exists. Otherwise the user has
	// to create it
	if (xIsFile(envPath)) {
		// init object to read env.xml
		if (result == kNoError) {
			envConfig = new xXML(envPath, &result);

			if (result != kNoError) {
				DLog("Error initializing xml object for path, %s, please check that file exists", envPath);
			}
		}

		// Get active user name
		if (result == kNoError) {
			this->_userInfo.username = envConfig->getValue(
				USERNAME_XML_PATH,
				&result
			);

			if (result != kNoError) {
				DLog("Could not find path: %s", USERNAME_XML_PATH);
			}
		}

		// Get active config path
		if (result == kNoError) {
			this->_userInfo.configPath = envConfig->getValue(
				USERCONFIGPATH_XML_PATH,
				&result
			);

			if (result != kNoError) {
				DLog("Could not find path: %s", USERCONFIGPATH_XML_PATH);
			}
		}
	} else {
		// Only split out error if user didn't pass create
		if (!this->args.contains(CREATE_ARG, &result)) {
			xError("%s does not exist", envPath);
			xLog(
				"Please run '%s %s %s' to create",
				this->execName(),
				CREATE_ARG,
				CREATE_ENV_CONF_ARG
			);
		}
	}

	xDelete(envConfig);

	return result;
}

void AppDriver::help(xUInt8 printType) {
	printf(
		"usage: %s [ %s ] [ %s ] <command> [<args>] \n",
		this->execName(),
		VERSION_ARG,
		HELP_ARG
	);

	printf("\n");

	switch (printType) {
	case 2:
		if (this->args.contains(DIR_ARG, xNull)) {
			printf("Command: %s\n", DIR_ARG);
			printf("\nBrief: %s\n", DIR_ARG_BRIEF);
			printf("\nDiscussion:\n");
			printf("%s\n", DIR_ARG_DISCUSSION);
			printf("\nArguments: %s\n", DIR_ARG_INFO);
		} else if (this->args.contains(CREATE_ARG, xNull)) {
			printf("Command: %s\n", CREATE_ARG);
			printf("\nBrief: %s\n", CREATE_ARG_BRIEF);
			printf("\nDiscussion:\n");
			printf("%s\n", CREATE_ARG_DISCUSSION);
			printf("\nArguments:\n");
			printf("  %s: %s\n", CREATE_XPRO_ARG, CREATE_XPRO_ARG_INFO);
			printf("  %s: %s\n", CREATE_USER_CONF_ARG, CREATE_USER_CONF_ARG_INFO);
			printf("  %s: %s\n", CREATE_ENV_CONF_ARG, CREATE_ENV_CONF_ARG_INFO);
		} else if (this->args.contains(OBJ_ARG, xNull)) {
			printf("Command: %s\n", OBJ_ARG);
			printf("\nBrief: %s\n", OBJ_ARG_BRIEF);
			printf("\nDiscussion:\n");
			printf("%s\n", OBJ_ARG_DISCUSSION);
		}

		printf("\n");

		break;

	// Prints brief descriptions on commands and entire application
	case 1:
		printf("List of commands:\n");

		// Directory arg
		printf("\t%s\t%s\n", DIR_ARG, DIR_ARG_BRIEF);

		// Create arg
		printf("\t%s\tCreates based arguments\n", CREATE_ARG);
		printf("\t  args:\n");
		printf("\t    - '%s' Creates .xpro at home path\n", CREATE_XPRO_ARG);
		printf("\t    - '%s' Creates the %s user config file with a basic template\n", CREATE_USER_CONF_ARG, DEFAULT_CONFIG_NAME);
		printf("\t    - '%s' Creates the %s environment config file\n", CREATE_ENV_CONF_ARG, ENV_CONFIG_NAME);

		// Object arg
		printf("\t%s\tReturns object\n", OBJ_ARG);
		printf("\t  args:\n");
		printf("\t    - '%s' Returns count of objects in user's config\n", OBJ_COUNT_ARG);
		printf("\n");

		break;
	case 0:
	default:

		break;
	}

	printf("Use '%s %s' to see more information\n", this->execName(), HELP_ARG);
	printf("%s-v%c copyright %s\n", APP_NAME, VERSION[0], &__DATE__[7]);
}

xError AppDriver::run() {
	xError 	result 			= kNoError;
	xBool 	okayToContinue 	= xTrue;

	// See if the user wants help
	if (result == kNoError) {

		// Print default help
		if (this->args.count() == 1) {
			xLog("No arguments\n");

			this->help(0);
			okayToContinue = xFalse;

		// Print default help
		} else if (this->args.contains(HELP_ARG, &result) && (this->args.count() > 2)) {
			xLog("Too many arguments for %s\n", HELP_ARG);

			this->help(0);
			okayToContinue = xFalse;

		// Print help for command
		} else if (		this->args.contains(DESCRIBE_COMMAND_HELP_ARG, &result)
					&& 	(this->args.count() > 2)) {
			this->help(2);
			okayToContinue = xFalse;

		// Print help for all commands and app info
		} else if (this->args.contains(HELP_ARG, &result)) {
			this->help(1);
			okayToContinue = xFalse;
		}
	}

	// Run application
	if (okayToContinue && (result == kNoError)) {
		if (this->args.contains(DIR_ARG, &result)) {
			result = HandleDirectory();
		} else if (this->args.contains(CREATE_ARG, &result)) {
			result = HandleCreate();
		} else if (this->args.contains(VERSION_ARG, &result)) {
			HandleVersion();
		} else if (this->args.contains(OBJ_ARG, &result)) {
			result = HandleObject();
		} else {
			xLog("Unknown command");
			this->help(xFalse);
		}
	}

	return result;
}
