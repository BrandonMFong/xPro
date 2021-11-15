/*
 * AppDriver.cpp
 *
 *  Created on: Nov 14, 2021
 *      Author: brandonmfong
 */

#include "AppDriver.hpp"
#include "Commands/Commands.h"

AppDriver * globalAppDriver = xNull;

AppDriver::AppDriver(
	xInt8 		argc,
	char ** 	argv,
	xError * 	err
) : args(argc, argv, err) {
	xError result = kNoError;

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
}


void AppDriver::help(xBool moreInfo) {
	xError result 			= kNoError;
	char * executableName 	= xNull;

	if (result == kNoError) {
		executableName = this->args.argAtIndex(0, &result);
	}

	if (result == kNoError) {
		executableName = xBasename(executableName, &result);
	}

	if (result == kNoError) {
		printf("usage: %s\t[ %s ] [ %s ] <command> [<args>] \n\n",
				executableName,
				VERSION_ARG,
				HELP_ARG);
		free(executableName);

		printf("List of commands:\n");

		printf("\t%s\treturns directory for alias\n", DIR_ARG);

		printf("\n");
	}

	if (result != kNoError) {
		DLog("help ended in %d", result);
	}
}

xError AppDriver::run() {
	xError 	result 			= kNoError;
	xBool 	okayToContinue 	= xTrue;

	// See if the user wants help
	if (result == kNoError) {
		if (this->args.count() == 1) {
			printf("No arguments\n");

			this->help(xFalse);
			okayToContinue = xFalse;
		} else if (this->args.contains(HELP_ARG, &result) && (this->args.count() > 2)) {
			printf("Too many arguments for %s\n", HELP_ARG);

			this->help(xFalse);
			okayToContinue = xFalse;
		} else if (this->args.contains(HELP_ARG, &result)) {
			this->help(xTrue);
			okayToContinue = xFalse;
		}
	}

	// Run application
	if (okayToContinue && (result == kNoError)) {
		if (this->args.contains(DIR_ARG, &result)) {
			if (result == kNoError) result = HandleDirectory();
		} else if (this->args.contains(CREATE_ARG, &result)) {
			if (result == kNoError) result = HandleCreate();
		}
	}

	return result;
}


AppDriver * AppDriver::shared() {
	return globalAppDriver;
}

xError AppDriver::setup() {
	xError 	result 		= kNoError;
	xXML 	* envConfig = xNull;
	char 	* homeDir 	= xNull,
			* envPath 	= xNull;

	homeDir = xHomePath(&result);

	if (result == kNoError) {
		envPath = (char *) malloc(
				strlen(homeDir)
			+ 	strlen(ENV_CONFIG_NAME)
			+ 	1
		);

		result = envPath != xNull ? kNoError : kUnknownError;
	}

	if (result == kNoError) {
		sprintf(envPath, "%s/.xpro/%s", homeDir, ENV_CONFIG_NAME);
		xFree(homeDir);

		if (strlen(envPath) == 0) {
			DLog("Unknown behavior, resulted in empty string");
			result = kEmptyStringError;
		}
	}

	if (result == kNoError) {
		envConfig = new xXML(envPath, &result);

		if (result != kNoError) {
			DLog("Error initializing xml object for path, %s, please check that file exists", envPath);
		}
	}

	if (result == kNoError) {
		this->_userInfo.username = envConfig->getValue(
			USERNAME_XML_PATH,
			&result
		);

		if (result != kNoError) {
			DLog("Could not find path: %s", USERNAME_XML_PATH);
		}
	}

	if (result == kNoError) {
		this->_userInfo.configPath = envConfig->getValue(
			USERCONFIGPATH_XML_PATH,
			&result
		);

		if (result != kNoError) {
			DLog("Could not find path: %s", USERCONFIGPATH_XML_PATH);
		}
	}

	xDelete(envConfig);

	return result;
}
