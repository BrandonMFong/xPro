/*
 * Alias.cpp
 *
 *  Created on: Mar 15, 2022
 *      Author: brandonmfong
 */


#include "Alias.hpp"
#include <AppDriver/AppDriver.hpp>
#include <AppDriver/Commands/Commands.h>
#include <ctype.h>

static rapidxml::xml_node<> * rootNode = xNull;

xError HandleAlias(void) {
	xError result = kNoError;
	const char * arg = xNull;
	const xUInt8 argCount = 5; // max arg count

	AppDriver * appDriver 	= AppDriver::shared();
	result 					= appDriver != xNull ? kNoError : kDriverError;

	if (result == kNoError) {
		result = appDriver->args.count() <= argCount ? kNoError : kArgError;

		if (result != kNoError) {
			DLog("The amount of arguments must be %d", argCount);
		}
	}

	// Get the argument after 'obj'
	//
	// this is the argument we are going to use to determine
	// what we are doing next
	if (result == kNoError) {
		arg = appDriver->args.argAtIndex(2, &result);
	}

#ifndef TESTING

	if (result == kNoError) {
		rootNode = appDriver->rootNode();
		result = rootNode != xNull ? kNoError : kXMLError;

		if (result != kNoError) {
			DLog("root node is null");
		}
	}

#endif

	if (result == kNoError) {
		if (!strcmp(arg, COUNT_ARG)) {
#ifndef TESTING
			result = HandleAliasCount();
#endif
		} else if (!strcmp(arg, INDEX_ARG)) {
#ifndef TESTING
			result = HandleAliasIndex();
#endif
		} else {
			result = kArgError;

			Log("Argument '%s' is not acceptable", arg);
			Log("Please see '%s' for more information", HELP_ARG);
		}
	}

	return result;
}

xError HandleAliasCount(void) {
	xError result = kNoError;
	rapidxml::xml_node<> * node = xNull,
			* aliasNode = xNull,
			* valueNode = xNull;
	xUInt64 count = 0;
	AppDriver * appDriver = AppDriver::shared();
	rapidxml::xml_attribute<> * attr = xNull;

	if (!(node = rootNode->first_node("Aliases"))) {
		result = kXMLError;
	} else if (!(aliasNode = node->first_node("Alias"))) {
		result = kXMLError;
		DLog("No object nodes");
	} else {
		// Sweep through object nodes
		for (; aliasNode; aliasNode = aliasNode->next_sibling()) {
			// make sure it has a value node
			if (!(valueNode = aliasNode->first_node())) {
				result = kXMLError;
				DLog("No value node");
				break;
			} else {
				// Sweep through the value nodes
				for (; valueNode; valueNode = valueNode->next_sibling()) {
					xBool validValue = xTrue;

					// Check if user name was specified
					if (!(attr = valueNode->first_attribute("username"))) {
						validValue = !strcmp(attr->value(), appDriver->username());
					}

					// Record count if this value node is acceptable
					if (validValue) {
						count++;
					}
				}
			}
		}
	}

	if(result != kNoError) {
		count = 0;
		DLog("Could not count for path: '%s'", OBJECT_TAG_PATH);
	}

	printf("%llu\n", count);

	return result;
}

xError HandleAliasIndex(void) {
	xError result = kNoError;
	char * xmlValue = xNull;
	const char * indexString = xNull;
	xInt8 argIndex = 0, nodeIndex;
	xUInt8 type = 0; // Default 0
	const xUInt8 valueType = 1,
			nameType = 2;
	rapidxml::xml_node<> * aliasNode, * valueNode, * node = xNull;

	AppDriver * appDriver 	= AppDriver::shared();
	result 					= appDriver != xNull ? kNoError : kDriverError;

	// Get the index for the -index argument
	if (result == kNoError) {
		argIndex = appDriver->args.indexForArg(INDEX_ARG, &result);

		if (result != kNoError) {
			DLog("Error finding index for arg: %s", INDEX_ARG);
		}
	}

	// Get the value for that switch argument
	if (result == kNoError) {
		if ((argIndex + 1) < appDriver->args.count()) {
			indexString = appDriver->args.argAtIndex(argIndex + 1, &result);
		} else {
			result = kOutOfRangeError;

			DLog(
				"There are not enough arguments. We cannot get value for %s",
				INDEX_ARG
			);
			Log("Please provide value for '%s'", INDEX_ARG);
		}
	}

	// See if index string is a number
	if (result == kNoError) {
		for (
			xUInt8 i = 0;
			(i < strlen(indexString)) && (result == kNoError);
			i++
		) {
			if (!isdigit(indexString[i])) {
				result = kArgError;
			}
		}

		// Get the index for the node
		if (result != kNoError) {
			Log("Argument '%s' is not valid", indexString);
			Log("Please provide a positive integer for '%s'", INDEX_ARG);
		} else {
			nodeIndex = atoi(indexString);
		}
	}

	// Check for supporting argument to determine if we are
	// trying to get the value or name
	if (result == kNoError) {
		if (appDriver->args.contains(VALUE_ARG, &result)) {
			if (result == kNoError) {
				type = valueType;
			}
		} else if (appDriver->args.contains(NAME_ARG, &result)) {
			if (result == kNoError) {
				type = nameType;
			}
		} else {
			result = kArgError;
			Log(
				"Please pass the arguments '%s' or '%s'",
				VALUE_ARG,
				NAME_ARG
			);
		}
	}

	if (!(node = rootNode->first_node("Aliases"))) {
		result = kXMLError;
		DLog("Can't find aliases");
	} else if (!(aliasNode = node->first_node("Alias"))) {
		result = kXMLError;
		DLog("No alias nodes");
	} else {
		DLog("first Alias node found");
		xUInt8 i = 0;
		xBool foundAlias = xFalse;

		// Sweep through object nodes
		for (; aliasNode; aliasNode = aliasNode->next_sibling()) {
			// make sure it has a value node
			if (!(valueNode = aliasNode->first_node())) {
				result = kXMLError;
				DLog("No value node");
				break;
			} else {
				DLog("Found value node");
				// Sweep through the value nodes
				for (; valueNode; valueNode = valueNode->next_sibling()) {
					DLog("Value node: %s", valueNode->value());
					xBool validValue = xTrue;
					rapidxml::xml_attribute<> * usernameAttr = xNull;

					// Check if user name was specified
					if (!(usernameAttr = valueNode->first_attribute("username"))) {
						validValue = !strcmp(usernameAttr->value(), appDriver->username());
					}

					// Record count if this value node is acceptable
					if (validValue) {
						DLog("Comparing %d and %d", i, nodeIndex);
						if (i == nodeIndex) {
							foundAlias = xTrue;
							break;
						}

						i++;
					} else {
						DLog("Value node does not belong to user %s", appDriver->username());
					}
				}
			}

			if (foundAlias) break;
		}
	}

	if (result == kNoError) {
		if (aliasNode == xNull) {
			result = kXMLError;
			DLog("alias node is null");
		} else if (valueNode == xNull) {
			result = kXMLError;
			DLog("value node is null");
		}
	}

	if (result == kNoError) {
		if (type == valueType) { // TODO: fix
#ifndef TESTING
			xmlValue = xCopyString(valueNode->value(), &result);
#endif
		} else if (type == nameType) { // TODO: fix
#ifndef TESTING
			rapidxml::xml_attribute<> * attr = xNull;
			if (!(attr = aliasNode->first_attribute("name"))) {
				result = kXMLError;
			} else {
				xmlValue = xCopyString(attr->value(), &result);
			}
#endif
		} else {
			// This should have been checked earlier but
			// will throw error either way
			result = kArgError;
			DLog("Error with type variable.  Value is %d", type);
		}
	}

	// Print value from xml if successful
	if (result == kNoError) {
		if (xmlValue == xNull) {
			result = kNullError;

			Log("Nothing found");
			DLog("XML value was returned null");
		}
	}

	if (result == kNoError) {
#ifndef TESTING
		printf("%s\n", xmlValue);
#endif
		xFree(xmlValue);
	}

	return result;
}


