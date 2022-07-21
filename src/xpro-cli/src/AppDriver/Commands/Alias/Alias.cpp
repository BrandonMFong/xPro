/*
 * Alias.cpp
 *
 *  Created on: Mar 15, 2022
 *      Author: brandonmfong
 */


#include "Alias.hpp"
#include <AppDriver/AppDriver.hpp>
#include <AppDriver/Commands/Help/Help.hpp>
#include <ctype.h>

//static rapidxml::xml_node<> * rootNode = xNull;

const char * const COMMAND = "alias";
const char * const BRIEF = "Returns aliases defined in user config";

void Alias::help() {
	printf(
		"Command: %s %s [ %s ] [ %s <num> ] [ %s | %s ] \n",
		AppDriver::shared()->execName(),
		COMMAND,
		Alias::countArg(),
		Alias::indexArg(),
		Alias::valueArg(),
		Alias::keyArg()
	);

	printf("\nBrief: %s\n", BRIEF);
	printf("\nDiscussion:\n");
	printf("  Returns alias name or alias value\n");
	printf("\nArguments:\n");
	printf("  %s: Returns count of aliases in user's config\n", Alias::countArg());
	printf("  %s: Indexes the list of arguments in user config\n", Alias::indexArg());
	printf("  %s: Returns value at index\n", Alias::valueArg());
	printf("  %s: Returns name at index\n", Alias::keyArg());
}

const char * Alias::command() {
	return COMMAND;
}

const char * Alias::brief() {
	return BRIEF;
}

xBool Alias::invoked() {
	AppDriver * appDriver = 0;

	if ((appDriver = AppDriver::shared())) {
		return appDriver->args.contains(COMMAND);
	} else {
		return xFalse;
	}
}

Alias::Alias(xError * err) : Dictionary(err) {
	DLog("%s command invoked", COMMAND);
	strcpy(this->_baseNodeString, "Aliases");
	strcpy(this->_individualNodeString, "Alias");
}

Alias::~Alias() {

}
