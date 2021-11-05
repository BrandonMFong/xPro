/*
 * Directory.cpp
 *
 *  Created on: Oct 30, 2021
 *      Author: BrandonMFong
 */

#include "Directory.hpp"
#include <Utilities/Utilities.h>

/**
 * Xml object for the xpro config file
 *
 * This should be allocated and deallocated in HandleDirectory()
 */
xXML * xProConfig = xNull;

xError HandleDirectory() {
	xError 		result 			= kNoError;
	char 		* dirAlias 		= xNull,
				* configPath 	= xNull;
	xArguments 	* arguments 	= xNull;

	arguments 	= xArguments::shared();
	result 		= arguments != xNull ? kNoError : kArgError;

	if (result == kNoError) {
		result = arguments->count() >= 3 ? kNoError : kArgError;

		if (result != kNoError) {
			DLog("Does not have correct count of arguments, actual: %d\n", arguments->count());
		}
	}

	// Get the alias from command line
	if (result == kNoError) {
		dirAlias = arguments->argAtIndex(2, &result);
	}

	// Get the config file
	if (result == kNoError) {
		configPath = ConfigFilePath(&result);
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
		if (arguments->count() == 3) {
			result = PrintDirectoryForAlias(dirAlias);
		} else {
			result = kDirectoryAliasError;
			DLog("Unexpected number of arguments, %d\n", arguments->count());
		}
	}

	// Delete the object
	if (xProConfig != xNull) {
		xDelete(xProConfig);
	}

	return result;
}

xError PrintDirectoryForAlias(const char * alias) {
	xError result = kNoError;
	char * elementPath = xNull;
	char ** values = xNull;
	xUInt8 size = 0;
	char * directory = xNull;

	if (alias == xNull) {
		result = kDirectoryAliasError;
	} else {
		elementPath = xMallocString(
				strlen(alias)
			+ 	strlen(DIRECTORY_ELEMENT_PATH_FORMAT)
			+ 	1,
			&result
		);

		if (result == kNoError) {
			sprintf(
				elementPath,
				DIRECTORY_ELEMENT_PATH_FORMAT,
				alias
			);
		}
	}

	if (result == kNoError) {
		values = xProConfig->getValue(elementPath, &size, &result);
	}

	if (result == kNoError) {
		if (size != 1) {
			DLog("Received an unexpected amount of values from config, %d\n", size);
			result = kSizeError;
		} else {
			directory = values[0];
			result = directory != xNull ? kNoError : kStringError;

			if (result != kNoError) {
				DLog("Directory is NULL\n");
			}
		}
	}

	if (result == kNoError) {
		printf("%s\n", directory);
	}

	if (values != xNull) {
		for (xUInt8 i = 0; i < size; i++) {
			xFree(values[i]);
		}
		xFree(values);
	}

	return result;
}
