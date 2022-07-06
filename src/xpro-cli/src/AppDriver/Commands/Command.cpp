/*
 * Command.cpp
 *
 *  Created on: Jun 29, 2022
 *      Author: brandonmfong
 */

#include "Command.hpp"
#include "Commands.h"
#include <xLib.h>
#include <AppDriver/AppDriver.hpp>
#include "Alias/Alias.hpp"
#include "Create/Create.hpp"
#include "Describe/Describe.hpp"
#include "Directory/Directory.hpp"
#include "Help/Help.hpp"
#include "Object/Object.hpp"
#include "Version/Version.hpp"

Command * Command::createCommand(xError * err) {
	Command * result = xNull;
	xError error = kNoError;
	xBool okayToContinue = xTrue;
	AppDriver * appDriver = AppDriver::shared();

	// See if the user wants help

	// Print default help
	if (appDriver->args.count() == 1) {
		HandleHelp(0);
		okayToContinue = xFalse;

	// Print default help
	} else if (appDriver->args.contains(HELP_ARG) && (appDriver->args.count() > 2)) {
		Log("Too many arguments for %s\n", HELP_ARG);

		HandleHelp(0);
		okayToContinue = xFalse;

	// Print help for command
	} else if (		appDriver->args.contains(DESCRIBE_COMMAND_HELP_ARG)
				&& 	(appDriver->args.count() > 2)) {
		HandleHelp(2);
		okayToContinue = xFalse;

	// Print help for all commands and app info
	} else if (appDriver->args.contains(HELP_ARG)) {
		HandleHelp(1);
		okayToContinue = xFalse;
	}

	// Run application
	if (okayToContinue) {
		if (appDriver->args.contains(DIR_ARG)) {
//			result = HandleDirectory();
			result = new Directory(&error);
		} else if (appDriver->args.contains(CREATE_ARG)) {
//			result = HandleCreate();
			result = new Create(&error);
		} else if (appDriver->args.contains(VERSION_ARG)) {
//			result = HandleVersion();
			result = new Version(&error);
		} else if (appDriver->args.contains(OBJ_ARG)) {
//			result = HandleObject();
			result = new Object(&error);
		} else if (appDriver->args.contains(DESCRIBE_ARG)) {
//			result = HandleDescribe();
			result = new Describe(&error);
		} else if (appDriver->args.contains(ALIAS_ARG)) {
//			result = HandleAlias();
			result = new Alias(&error);
		} else {
			Log("Unknown command");
			HandleHelp(0);
		}
	}

	if (err != xNull) {
		*err = error;
	}

	return result;
}

Command::Command(xError * err) {

}

Command::~Command() {

}

