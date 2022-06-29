/*
 * AppDriver.cpp
 *
 *  Created on: Nov 14, 2021
 *      Author: brandonmfong
 */

#include "AppDriver.hpp"
#include <AppDriver/Commands/Commands.h>
#include <xLib/External/RapidXml/rapidxml.hpp>
#include <fstream>
#include <sstream>

AppDriver * globalAppDriver = xNull;

AppDriver::AppDriver(
	xInt8 		argc,
	char ** 	argv,
	xError * 	err
) : args(argc, argv, err) {
	xError result = err != xNull ? *err : kNoError;

	this->_userInfo.configPath = xNull;
	this->_userInfo.username = xNull;
	this->_userConfig = xNull;

	if (result == kNoError) {
		result = this->parseEnv();
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
	xFree(this->_xproHomePath);
	xFree(this->_envPath);

	globalAppDriver = xNull;
}

AppDriver * AppDriver::shared() {
	return globalAppDriver;
}

xError AppDriver::parseEnv() {
	xError result = kNoError;
	rapidxml::xml_document<> xml;
	std::ifstream * stream = xNull;
	char * homeDir = xNull;
	std::stringstream buffer;
	rapidxml::xml_node<> * nodeA = xNull, * nodeB = xNull;
	bool foundUser = xFalse;

	// Get home path for current user
	homeDir = xHomePath(&result);

	if (result == kNoError) {
		this->_xproHomePath = (char *) malloc(
			strlen(homeDir) +
			strlen(XPRO_HOME_DIR_NAME)
			+ 2
		);

		result = this->_xproHomePath != xNull ? kNoError : kUnknownError;
	}

	// construct path to the .xpro directory.  It should live in the user's home directory
	if (result == kNoError) {
		sprintf(this->_xproHomePath, "%s/%s", homeDir, XPRO_HOME_DIR_NAME);
		xFree(homeDir);

		if (strlen(this->_xproHomePath) == 0) {
			DLog("Unknown behavior, resulted in empty string");
			result = kEmptyStringError;
		}
	}

	if (result == kNoError) {
		this->_envPath = (char *) malloc(
				strlen(this->_xproHomePath)
			+ 	strlen(ENV_CONFIG_NAME)
			+ 	2
		);

		result = this->_envPath != xNull ? kNoError : kUnknownError;
	}

	// Construct path the env.xml file
	if (result == kNoError) {
		sprintf(this->_envPath, "%s/%s", this->_xproHomePath, ENV_CONFIG_NAME);

		if (strlen(this->_envPath) == 0) {
			DLog("Unknown behavior, resulted in empty string");
			result = kEmptyStringError;
		}
	}

	if (!xIsFile(this->_envPath)) {
		// Only split out error if user didn't pass create
		if (!this->args.contains(CREATE_ARG, &result)) {
			ELog("%s does not exist", this->_envPath);
			Log(
				"Please run '%s %s %s' to create",
				this->execName(),
				CREATE_ARG,
				ENV_CONF_ARG
			);
		}
	} else {
		if (result == kNoError) {
			stream = new std::ifstream(this->_envPath);
			result = stream != xNull ? kNoError : kXMLError;
		}

		if (result == kNoError) {
			buffer << stream->rdbuf();
			xml.parse<0>(&buffer.str()[0]);
			nodeA = xml.first_node("xPro");
			result = nodeA != xNull ? kNoError : kXMLError;
		}

		if (result == kNoError) {
			nodeA = nodeA->first_node("Users");
			result = nodeA != xNull ? kNoError : kXMLError;
		}

		if (result == kNoError) {
			nodeA = nodeA->first_node("User");
			result = nodeA != xNull ? kNoError : kXMLError;
		}

		if (result == kNoError) {
			// find an active user
			for (; nodeA; nodeA = nodeA->next_sibling()) {

				// Look to through the attributes to find the 'active' attr
				for (
					rapidxml::xml_attribute<> * attr = nodeA->first_attribute();
					attr;
					attr = attr->next_attribute()
				) {
					// If we find an active user
					if (!strcmp(attr->name(), "active") && !strcmp(attr->value(), "true")) {
						// Get username
						if (!(nodeB = nodeA->first_node("username"))) {
							result = kXMLError;
						} else {
							this->_userInfo.username = xCopyString(nodeB->value(), &result);
						}

						// Get config path
						if (result == kNoError) {
							if (!(nodeB = nodeA->first_node("ConfigPath"))) {
								result = kXMLError;
							} else {
								this->_userInfo.configPath = xCopyString(nodeB->value(), &result);
							}
						}

						foundUser = result == kNoError;
					}
				}

				if (foundUser) break;
			}

			if (!foundUser) {
				result = kXMLError;
				DLog("Could not find user");
			}
		}

		if (result == kNoError) {
			if (!this->_userInfo.configPath || !this->_userInfo.username) {
				result = kXMLError;
				DLog("User name or config path could not be found");
			}
		}
	}

	xDelete(stream);
	xFree(homeDir);

	return result;
}

xError AppDriver::readConfig() {
	xError result = kNoError;
	std::ifstream * stream = xNull;
	std::stringstream buffer;

	if (!(stream = new std::ifstream(this->_userInfo.configPath))) {
		result = kUserConfigPathError;
	} else {
		buffer << stream->rdbuf();
		this->_userConfig.buffer = buffer.str();
		this->_userConfig.xml.parse<0>(&this->_userConfig.buffer[0]);
	}

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
