/*
 * Directory.cpp
 *
 *  Created on: Oct 30, 2021
 *      Author: BrandonMFong
 */

#include "Directory.hpp"
#include <AppDriver/AppDriver.hpp>

/**
 * Xml object for the xpro config file
 *
 * This should be allocated and deallocated in HandleDirectory()
 */
xXML * xProConfig = xNull;

xError HandleDirectory() {
	xError 		result 			= kNoError;
	char 		* dirAlias 		= xNull;
	const char 	* configPath	= xNull;
	AppDriver 	* appDriver		= xNull;

	appDriver 	= AppDriver::shared();
	result 		= appDriver != xNull ? kNoError : kArgError;

	if (result == kNoError) {
		result = appDriver->args.count() >= 3 ? kNoError : kArgError;

		if (result != kNoError) {
			DLog("Does not have correct count of arguments, actual: %d\n", appDriver->args.count());
		}
	}

	// Get the alias from command line
	if (result == kNoError) {
		dirAlias = appDriver->args.argAtIndex(2, &result);
	}

	// Get the config file
	if (result == kNoError) {
		configPath 	= appDriver->configPath();
		result 		= configPath != xNull ? kNoError : kUserConfigPathError;
	}

	if (result == kNoError) {
		if (xProConfig == xNull) {
			xProConfig = new xXML(configPath, &result);
		} else {
			result = kXMLError;
			DLog("xPro config has already been read unexpectedly\n");
		}
	}

	if (result == kNoError) {
		// If user passed 3 arguments: <tool> dir <alias>
		// then we just need to print the alias definition
		if (appDriver->args.count() == 3) {
			result = PrintDirectoryForAlias(dirAlias);
		} else {
			result = kDirectoryAliasError;
			DLog("Unexpected number of arguments, %d\n", appDriver->args.count());
		}
	}

	if (result != kNoError) {
		xError("Error occured: %d\n", result);
	}

	xDelete(xProConfig);

	return result;
}

xError PrintDirectoryForAlias(const char * alias) {
	xError 		result 			= kNoError;
	char 		* elementPath 	= xNull,
				* directory 	= xNull;
	const char 	* username 		= xNull;

	username 	= AppDriver::shared()->username();
	result 		= username != xNull ? kNoError : kStringError;

	if (result == kNoError) {
		if (alias == xNull) {
			result = kDirectoryAliasError;
		} else {
			elementPath = xMallocString(
					strlen(alias)
				+ 	strlen(DIRECTORY_ELEMENT_PATH_FORMAT)
				+	strlen(username)
				+ 	1,
				&result
			);

			if (result == kNoError) {
				sprintf(
					elementPath,
					DIRECTORY_ELEMENT_PATH_FORMAT,
					alias,
					username
				);
			}
		}
	}

	if (result == kNoError) {
		directory = xProConfig->getValue(elementPath, &result);

		if (result != kNoError) {
			DLog("Directory is NULL\n");
		}
	}

	if (result == kNoError) {
		printf("%s\n", directory);
	}

	return result;
}
