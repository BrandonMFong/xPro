/*
 * Dictionary.cpp
 *
 *  Created on: Jul 15, 2022
 *      Author: brandonmfong
 */

#include "Dictionary.hpp"
#include <AppDriver/AppDriver.hpp>
#include <AppDriver/Commands/Help/Help.hpp>

const char * const COUNT_ARG = "--count";
const char * const INDEX_ARG = "-index";
const char * const VALUE_ARG = "--value";
const char * const NAME_ARG = "--name";
static rapidxml::xml_node<> * rootNode = xNull;

Dictionary::Dictionary(xError * err) : Command(err) {


}

Dictionary::~Dictionary() {

}

const char * Dictionary::countArg() {
	return COUNT_ARG;
}

const char * Dictionary::indexArg() {
	return INDEX_ARG;
}

const char * Dictionary::valueArg() {
	return VALUE_ARG;
}

const char * Dictionary::keyArg() {
	return NAME_ARG;
}

xError Dictionary::exec() {
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
		arg = appDriver->args.objectAtIndex(2);
		result = arg != xNull ? kNoError : kArgError;
	}

#ifndef TESTING

	if (result == kNoError) {
		rootNode = appDriver->rootNode();
		result = rootNode != xNull ? kNoError : kXMLError;
	}

#endif

	if (result == kNoError) {
		if (!strcmp(arg, this->countArg())) {
#ifndef TESTING
			result = this->handleCount();
#endif
		} else if (!strcmp(arg, this->indexArg())) {
#ifndef TESTING
			result = this->handleIndex();
#endif
		} else {
			result = kArgError;

			Log("Argument '%s' is not acceptable", arg);
			Log("Please see '%s' for more information", Help::command());
		}
	}

	return result;
}


xError Dictionary::handleCount() {
	xError result = kNoError;
	rapidxml::xml_node<> * node = xNull,
			* objectNode = xNull,
			* valueNode = xNull;
	xUInt64 count = 0;
	AppDriver * appDriver = AppDriver::shared();
	rapidxml::xml_attribute<> * attr = xNull;

	if (!(node = rootNode->first_node(this->_baseNodeString))) {
		DLog("No objects");
	} else if (!(objectNode = node->first_node(this->_individualNodeString))) {
		DLog("No object nodes");
	} else {
		// Sweep through object nodes
		for (; objectNode; objectNode = objectNode->next_sibling()) {
			// make sure it has a value node
			if (!(valueNode = objectNode->first_node())) {
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
		DLog("Could not count");
	}

	printf("%llu\n", count);

	return result;
}

xError Dictionary::handleIndex() {
	xError result = kNoError;
	char * xmlValue = xNull;
	const char * indexString = xNull;
	xInt8 argIndex = 0, nodeIndex;
	xUInt8 type = 0; // Default 0
	const xUInt8 valueType = 1,
			nameType = 2;
	rapidxml::xml_node<> * objectNode, * valueNode, * node = xNull;

	AppDriver * appDriver 	= AppDriver::shared();
	result 					= appDriver != xNull ? kNoError : kDriverError;

	// Get the index for the -index argument
	if (result == kNoError) {
		argIndex = appDriver->args.indexForObject(this->indexArg());
		result = argIndex != -1 ? kNoError : kArgError;

		if (result != kNoError) {
			DLog("Error finding index for arg: %s", this->indexArg());
#ifdef DEBUG
			appDriver->args.print();
#endif // DEBUG
		}
	}

	// Get the value for that switch argument
	if (result == kNoError) {
		if ((argIndex + 1) < appDriver->args.count()) {
			indexString = appDriver->args.objectAtIndex(argIndex + 1);
			result = indexString != xNull ? kNoError : kArgError;
		} else {
			result = kOutOfRangeError;

			DLog(
				"There are not enough arguments. We cannot get value for %s",
				this->indexArg()
			);
			Log("Please provide value for '%s'", this->indexArg());
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
			Log("Please provide a positive integer for '%s'", this->indexArg());
		} else {
			nodeIndex = atoi(indexString);
		}
	}

	// Check for supporting argument to determine if we are
	// trying to get the value or name
	if (result == kNoError) {
		if (appDriver->args.contains(this->valueArg())) {
			type = valueType;
		} else if (appDriver->args.contains(this->keyArg())) {
			type = nameType;
		} else {
			result = kArgError;
			Log(
				"Please pass the arguments '%s' or '%s'",
				this->valueArg(),
				this->keyArg()
			);
		}
	}

	if (!(node = rootNode->first_node(this->_baseNodeString))) {
		DLog("No objects found");
	} else if (!(objectNode = node->first_node(this->_individualNodeString))) {
		DLog("The objects node has no children");
	} else {
		xUInt8 i = 0;
		xBool foundObject = xFalse;

		// Sweep through object nodes
		for (; objectNode; objectNode = objectNode->next_sibling()) {
			// make sure it has a value node
			if (!(valueNode = objectNode->first_node())) {
				result = kXMLError;
				DLog("No value node");
				break;
			} else {
				// Sweep through the value nodes
				for (; valueNode; valueNode = valueNode->next_sibling()) {
					xBool validValue = xTrue;
					rapidxml::xml_attribute<> * usernameAttr = xNull;

					// Check if user name was specified
					if (!(usernameAttr = valueNode->first_attribute("username"))) {
						validValue = !strcmp(usernameAttr->value(), appDriver->username());
					}

					// Record count if this value node is acceptable
					if (validValue) {
						if (i == nodeIndex) {
							foundObject = xTrue;
							break;
						}

						i++;
					}
				}
			}

			if (foundObject) break;
		}
	}

	if (result == kNoError) {
		if (objectNode == xNull) {
			result = kXMLError;
			DLog("object node is null");
		} else if (valueNode == xNull) {
			result = kXMLError;
			DLog("value node is null");
		}
	}

	if (result == kNoError) {
		if (type == valueType) {
			xmlValue = xCopyString(valueNode->value(), &result);
		} else if (type == nameType) {
			rapidxml::xml_attribute<> * attr = xNull;
			if (!(attr = objectNode->first_attribute("name"))) {
				result = kXMLError;
			} else {
				xmlValue = xCopyString(attr->value(), &result);
			}
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
		printf("%s\n", xmlValue);
		xFree(xmlValue);
	}

	return result;
}

