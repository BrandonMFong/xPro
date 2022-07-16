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


