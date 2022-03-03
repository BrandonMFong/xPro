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
	char 		* dirKey 		= xNull;
	const char 	* configPath	= xNull;
	AppDriver 	* appDriver		= xNull;

	appDriver 	= AppDriver::shared();
	result 		= appDriver != xNull ? kNoError : kDriverError;

	if (result == kNoError) {
		result = appDriver->args.count() >= 3 ? kNoError : kArgError;

		if (result != kNoError) {
#ifndef TESTING
			DLog("Does not have correct count of arguments, actual: %d\n", appDriver->args.count());
#endif
		}
	}

	// Get the key from command line
	if (result == kNoError) {
		dirKey = appDriver->args.argAtIndex(2, &result);
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
		// If user passed 3 arguments: <tool> dir <key>
		// then we just need to print the key definition
		if (appDriver->args.count() == 3) {
#ifndef TESTING
			result = PrintDirectoryForKey(dirKey);
#endif
		} else {
			result = kDirectoryKeyError;
			DLog("Unexpected number of arguments, %d\n", appDriver->args.count());
		}
	}

	if (result != kNoError) {
		// Don't print this out because we test it
#ifndef TESTING
		xError("[%d]\n", result);
#endif
	}

	xDelete(xProConfig);

	return result;
}

xError PrintDirectoryForKey(const char * key) {
	xError 		result 			= kNoError;
	char 		* elementPath 	= xNull,
				* directory 	= xNull;
	const char 	* username 		= xNull;

	if (key == xNull) {
		result = kDirectoryKeyError;
	} else {
		elementPath = xMallocString(
				strlen(key)
			+ 	strlen(DIRECTORY_ELEMENT_PATH_FORMAT)
			+	strlen(ALL_USERS)
			+ 	1,
			&result
		);

		if (result == kNoError) {
			sprintf(
				elementPath,
				DIRECTORY_ELEMENT_PATH_FORMAT,
				key,
				ALL_USERS
			);
		}
	}

	if (result == kNoError) {
		if (xProConfig == xNull) {
			result = kNullError;
#ifndef TESTING
			DLog("the xpro config object is null");
#endif
		}
	}

	// See if user has specified a default path with __ALL__
	if (result == kNoError) {
		directory = xProConfig->getValue(elementPath, &result);

		if (result != kNoError) {
			DLog("Directory is NULL\n");
		}
	}

	// If directory was NULL, then __ALL__ was not specified, now we use the user name
	if (directory == xNull) {
		if (result == kNoError) {
			username 	= AppDriver::shared()->username();
			result 		= username != xNull ? kNoError : kStringError;
		}

		if (result == kNoError) {
			xFree(elementPath);

			elementPath = xMallocString(
					strlen(key)
				+ 	strlen(DIRECTORY_ELEMENT_PATH_FORMAT)
				+	strlen(username)
				+ 	1,
				&result
			);

			if (result == kNoError) {
				sprintf(
					elementPath,
					DIRECTORY_ELEMENT_PATH_FORMAT,
					key,
					username
				);
			}
		}
	}

	// Get value for user
	if (result == kNoError) {
		directory = xProConfig->getValue(elementPath, &result);

		if (result != kNoError) {
			DLog("Directory is NULL\n");
		}
	}

	if (result == kNoError) {
		if (directory != xNull) {
			if (!xIsDir(directory)) {
				xLog("%s is not a directory.  Please make sure that it exists and that is a directory, not a file", directory);
				result = kDirectoryError;
			}
		}
	}

	// If directory is still null then will not print out anything
	if (result == kNoError) {
		if (directory != xNull) {
			printf("%s\n", directory);
		}
	}

	return result;
}
