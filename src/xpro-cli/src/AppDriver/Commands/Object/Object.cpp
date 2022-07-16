/*
 * Object.cpp
 *
 *  Created on: Mar 2, 2022
 *      Author: brandonmfong
 */

#include "Object.hpp"
#include <AppDriver/AppDriver.hpp>
#include <AppDriver/Commands/Help/Help.hpp>
#include <ctype.h>
#include <string.h>

const char * const COMMAND = "obj";
const char * const BRIEF = "Returns object";
//static rapidxml::xml_node<> * rootNode = xNull;

void Object::help() {
	printf(
		"Command: %s %s [ %s ] [ %s <num> ] [ %s | %s ] \n",
		AppDriver::shared()->execName(),
		COMMAND,
		Object::countArg(),
		Object::indexArg(),
		Object::valueArg(),
		Object::keyArg()
	);
	printf("\nBrief: %s\n", BRIEF);
	printf("\nDiscussion:\n");
	printf("  Returns object name or object value\n");
	printf("\nArguments:\n");
	printf("  %s: Returns count of objects in user's config\n", Object::countArg());
	printf("  %s: Indexes the list of arguments in user config\n", Object::indexArg());
	printf("  %s: Returns value at index\n", Object::valueArg());
	printf("  %s: Returns name at index\n", Object::keyArg());
}

const char * Object::command() {
	return COMMAND;
}

const char * Object::brief() {
	return BRIEF;
}

xBool Object::invoked() {
	AppDriver * appDriver = 0;

	if ((appDriver = AppDriver::shared())) {
		return appDriver->args.contains(COMMAND);
	} else {
		return xFalse;
	}
}

Object::Object(xError * err) : Dictionary(err) {
	strcpy(this->_baseNodeString, "Objects");
	strcpy(this->_individualNodeString, "Object");
}

Object::~Object() {

}
