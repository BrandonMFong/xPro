/*
 * Directory.cpp
 *
 *  Created on: Oct 30, 2021
 *      Author: BrandonMFong
 */

#include "Directory.hpp"
#include <AppDriver/AppDriver.hpp>

rapidxml::xml_node<> * rootNode = xNull;

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

	if (result == kNoError) {
		rootNode = appDriver->rootNode();
		result = rootNode != xNull ? kNoError : kXMLError;
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

	if (key == xNull) {
		result = kDirectoryKeyError;
	}

	if (result == kNoError) {
		username 	= AppDriver::shared()->username();
		result 		= username != xNull ? kNoError : kStringError;
	}

	if (!(node = rootNode->first_node("Objects"))) {
		result = kXMLError;
	} else if (!(directoryNode = node->first_node("Object"))) {
		result = kXMLError;
		DLog("No object nodes");
	} else {
		// Sweep through object nodes
		for (; directoryNode; directoryNode = directoryNode->next_sibling()) {
			// make sure it has a value node
			if (!(valueNode = directoryNode->first_node())) {
				result = kXMLError;
				DLog("No value node");
				break;
			} else {
				// Sweep through the value nodes
				for (; valueNode; valueNode = valueNode->next_sibling()) {
					xBool validValue = xTrue;
					rapidxml::xml_attribute<> * attrKey = xNull;

					// Check if user name was specified
					if (!(attrKey = valueNode->first_attribute("key"))) {
						validValue = !strcmp(attrKey->value(), key);
					}

					// Record count if this value node is acceptable
					if (validValue) {
						directory = valueNode->value();
						break;
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
