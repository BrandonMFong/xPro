/*
 * Directory.cpp
 *
 *  Created on: Oct 30, 2021
 *      Author: BrandonMFong
 */

#include "Directory.hpp"
#include <AppDriver/AppDriver.hpp>

static rapidxml::xml_node<> * rootNode = xNull;

xError HandleDirectory() {
	xError result = kNoError;
	const char * dirKey = xNull;
	AppDriver * appDriver = xNull;

	appDriver 	= AppDriver::shared();
	result 		= appDriver != xNull ? kNoError : kDriverError;

	if (result == kNoError) {
		result = appDriver->args.count() >= 3 ? kNoError : kArgError;

		if (result != kNoError) {
			DLog("Does not have correct count of arguments, actual: %d\n", appDriver->args.count());
		}
	}

	// Get the key from command line
	if (result == kNoError) {
		dirKey = appDriver->args.argAtIndex(2, &result);
	}

#ifndef TESTING
	if (result == kNoError) {
		rootNode = appDriver->rootNode();
		result = rootNode != xNull ? kNoError : kXMLError;

		if (result != kNoError) {
			DLog("Root node is null");
		}
	}
#endif

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
		ELog("[%d]\n", result);
	}

	return result;
}

xError PrintDirectoryForKey(const char * key) {
	xError result = kNoError;
	char * directory = xNull;
	const char * username = xNull;
	rapidxml::xml_node<> * node = xNull,
			* directoryNode = xNull,
			* valueNode = xNull;
	AppDriver * appDriver = AppDriver::shared();

	if (key == xNull) {
		result = kDirectoryKeyError;
		DLog("key is null");
	}

	if (result == kNoError) {
		username 	= AppDriver::shared()->username();
		result 		= username != xNull ? kNoError : kStringError;

		if (result != kNoError) {
			DLog("User name is null");
		}
	}

	if (!(node = rootNode->first_node("Directories"))) {
		result = kXMLError;
		DLog("Can't find Directories");
	} else if (!(directoryNode = node->first_node("Directory"))) {
		result = kXMLError;
		DLog("No directory nodes");
	} else {
		DLog("Found first directory node");
		// Sweep through object nodes
		for (; directoryNode; directoryNode = directoryNode->next_sibling()) {
			rapidxml::xml_attribute<> * attrKey = xNull;

			// Make sure the directory node has a key
			if (!(attrKey = directoryNode->first_attribute("key"))) {
				result = kXMLError;
				DLog("directory key missing");
			} else if (strcmp(attrKey->value(), key)) {
				DLog("key: %s != %s", attrKey->value(), key);
			} else {
				// make sure it has a value node
				if (!(valueNode = directoryNode->first_node())) {
					result = kXMLError;
					DLog("No value node");
					break;
				} else {
					DLog("Found first value node");
					// Sweep through the value nodes
					for (; valueNode; valueNode = valueNode->next_sibling()) {
						xBool validValue = xTrue;
						rapidxml::xml_attribute<> * attrUsername = xNull;

						// Check if user name was specified
						if (!(attrUsername = valueNode->first_attribute("username"))) {
							if (!strcmp(attrUsername->value(), appDriver->username())) {
								validValue = xTrue;
								DLog("Key does match, %s == %s", attrKey->value(), key);
							} else {
								validValue = xFalse;
								DLog("Key does not match, %s != %s", attrKey->value(), key);
							}
						}

						// Record count if this value node is acceptable
						if (validValue) {
							directory = valueNode->value();
							break;
						}
					}
				}
			}

			if (directory) break;
		}
	}

	if (result == kNoError) {
		if (directory != xNull) {
			if (!xIsDir(directory)) {
				Log("%s is not a directory.  Please make sure that it exists and that is a directory, not a file", directory);
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
