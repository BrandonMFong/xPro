/*
 * AppDriver.cpp
 *
 *  Created on: Nov 14, 2021
 *      Author: brandonmfong
 */

#include "AppDriver.hpp"
#include <AppDriver/Commands/Commands.h>

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
			this->_userInfo.configPath = envConfig->getValue( // TODO: fix
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
			ELog("%s does not exist", envPath);
			Log(
				"Please run '%s %s %s' to create",
				this->execName(),
				CREATE_ARG,
				ENV_CONF_ARG
			);
		}
	}

	xDelete(envConfig);

	return result;
}

xError AppDriver::run() {
	xError 	result 			= kNoError;
	xBool 	okayToContinue 	= xTrue;

	// See if the user wants help

	// Print default help
	if (this->args.count() == 1) {
		HandleHelp(0);
		okayToContinue = xFalse;

	// Print default help
	} else if (this->args.contains(HELP_ARG, &result) && (this->args.count() > 2)) {
		Log("Too many arguments for %s\n", HELP_ARG);

		HandleHelp(0);
		okayToContinue = xFalse;

	// Print help for command
	} else if (		this->args.contains(DESCRIBE_COMMAND_HELP_ARG, &result)
				&& 	(this->args.count() > 2)) {
		HandleHelp(2);
		okayToContinue = xFalse;

	// Print help for all commands and app info
	} else if (this->args.contains(HELP_ARG, &result)) {
		HandleHelp(1);
		okayToContinue = xFalse;
	}

	// Run application
	if (okayToContinue && (result == kNoError)) {
		if (this->args.contains(DIR_ARG, &result)) {
			result = HandleDirectory();
		} else if (this->args.contains(CREATE_ARG, &result)) {
			result = HandleCreate();
		} else if (this->args.contains(VERSION_ARG, &result)) {
			result = HandleVersion();
		} else if (this->args.contains(OBJ_ARG, &result)) {
			result = HandleObject();
		} else if (this->args.contains(DESCRIBE_ARG, &result)) {
			result = HandleDescribe();
		} else if (this->args.contains(ALIAS_ARG, &result)) {
			result = HandleAlias();
		} else {
			Log("Unknown command");
			HandleHelp(0);
		}
	}

	return result;
}
