/*
 * AppDriver.hpp
 *
 *  Created on: Nov 14, 2021
 *      Author: brandonmfong
 */

#ifndef SRC_APPDRIVER_APPDRIVER_HPP_
#define SRC_APPDRIVER_APPDRIVER_HPP_

#include <string> // TODO: typedef
#include "../Lib/External/RapidXml/rapidxml.hpp" // TODO: only typedef
#include "../Lib/Log.h"
#include "../Lib/xLib.h"

/**
 * directory name at home path
 */
#define XPRO_HOME_DIR_NAME ".xpro"

/**
 * Environment config name
 */
#define ENV_CONFIG_NAME "env.xml"

/**
 * Path to user's user name in ENV_CONFIG_NAME
 */
#define USERNAME_XML_PATH "xPro/Users/User.active(true)/username"

/**
 * Path to user's config path in ENV_CONFIG_NAME
 */
#define USERCONFIGPATH_XML_PATH "xPro/Users/User.active(true)/ConfigPath"

/**
 * Default name for a user config file
 */
#define DEFAULT_CONFIG_NAME "user.xml"

/**
 * Default app name
 */
#define APP_NAME "xPro"

/**
 * If this is specified in the username in the above format, then the path with this attribute will take precedence
 */
#define ALL_USERS "__ALL__"

/**
 * Main class for xPro CLI
 */
class AppDriver {
public:

	/**
	 * Passes argc and argv to xArguments to initialize the argument parsing
	 */
	AppDriver(xInt8 argc, char ** argv, xError * err);

	virtual ~AppDriver();

	/**
	 * Reads through arguments and executes command that cam from caller
	 */
	xError run();

	/**
	 * Returns global reference to AppDriver
	 */
	static AppDriver * shared();

	/**
	 * Parses command line arguments
	 */
	Arguments args;

	/**
	 * returns _userInfo.configPath
	 */
	const char * configPath() {
		return (const char *) this->_userInfo.configPath;
	}

	/// Returns _userInfo.username
	const char * username() {
		return (const char *) this->_userInfo.username;
	}

	/// Returns _xProHomePath
	const char * xProHomePath() {
		return (const char *) this->_xproHomePath;
	}

	/// Returns executable name from command line (arg 0)
	const char * execName() {
		const char * 	result	= xNull;
		xError 			error 	= kNoError;

		result = this->args.argAtIndex(0, &error);

		if (error != kNoError) {
			DLog("Error getting executable name, %d", error);
		} else {
			result = basename((char *) result);
		}

		return result;
	}

	/// Returns the xPro root node. caller does not own
	rapidxml::xml_node<> * rootNode() {
		return this->_userConfig.xml.first_node("xPro");
	}

private:
	/**
	 * Reads the environment config
	 */
	xError parseEnv();

	xError readConfig();

	/**
	 * Path to .xpro
	 */
	char * _xproHomePath;

	/**
	 * Path to env.xml
	 */
	char * _envPath;

	/**
	 * Contains user information from env.xml
	 */
	struct {
		/**
		 * User name is used to uniquely identify the user using xpro cli
		 */
		char * username;

		/**
		 * Path to the user's config xml
		 */
		char * configPath;
	} _userInfo;

	/**
	 * Holds user xml data
	 */
	struct {
		/// Holds buffer for xml
		std::string buffer;

		/// Parser
		rapidxml::xml_document<> xml;
	} _userConfig;
};

#endif /* SRC_APPDRIVER_APPDRIVER_HPP_ */
