/*
 * AppDriver.hpp
 *
 *  Created on: Nov 14, 2021
 *      Author: brandonmfong
 */

#ifndef SRC_APPDRIVER_APPDRIVER_HPP_
#define SRC_APPDRIVER_APPDRIVER_HPP_

#include <xLib.h>

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
#define USERNAME_XML_PATH "/xPro/Users/User.active(true)/username"

/**
 * Path to user's config path in ENV_CONFIG_NAME
 */
#define USERCONFIGPATH_XML_PATH "/xPro/Users/User.active(true)/ConfigPath"

/**
 * Default name for a user config file
 */
#define DEFAULT_CONFIG_NAME "user.xml"

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
	 * Shows help
	 */
	void help(xBool moreInfo);

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
	xArguments args;

	/**
	 * Sets up the app environment, like reading config files
	 */
	xError setup();

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
		return (const char *) this->_xProHomePath;
	}

	/// Returns executable name from command line (arg 0)
	const char * execName() {
		char * result	= xNull;
		xError error 	= kNoError;
		result 			= this->args.argAtIndex(0, &error);

		if (error != kNoError) {
			DLog("Error getting executable name, %d", error);
		} else {
			result = basename(result);
		}

		return (const char *) result;
	}

private:
	/**
	 * Path to .xpro
	 */
	char * _xProHomePath;

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
};

#endif /* SRC_APPDRIVER_APPDRIVER_HPP_ */