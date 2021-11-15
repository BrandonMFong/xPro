/*
 * AppDriver.hpp
 *
 *  Created on: Nov 14, 2021
 *      Author: brandonmfong
 */

#ifndef SRC_APPDRIVER_APPDRIVER_HPP_
#define SRC_APPDRIVER_APPDRIVER_HPP_

#include <xLib.h>
#include <Commands/Directory/Directory.hpp>
#include <Commands/Commands.h>

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

private:

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
