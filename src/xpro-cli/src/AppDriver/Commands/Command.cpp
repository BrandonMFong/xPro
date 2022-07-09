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

//	 See if the user wants help
//
//	// Print default help
//	if (appDriver->args.count() == 1) {
//		HandleHelp(0);
//		okayToContinue = xFalse;
//
//	// Print default help
//	} else if (appDriver->args.contains(HELP_ARG) && (appDriver->args.count() > 2)) {
//		Log("Too many arguments for %s\n", HELP_ARG);
//
//		HandleHelp(0);
//		okayToContinue = xFalse;
//
//	// Print help for command
//	} else if (		appDriver->args.contains(DESCRIBE_COMMAND_HELP_ARG)
//				&& 	(appDriver->args.count() > 2)) {
//		HandleHelp(2);
//		okayToContinue = xFalse;
//
//	// Print help for all commands and app info
//	} else if (appDriver->args.contains(HELP_ARG)) {
//		HandleHelp(1);
//		okayToContinue = xFalse;
//	}

	// Run application
	if (okayToContinue) {
		if (Help::commandInvoked()) {
			result = new Help(&error);
		} else if (Directory::commandInvoked()) {
//			result = HandleDirectory();
			result = new Directory(&error);
		} else if (Create::commandInvoked()) {
//			result = HandleCreate();
			result = new Create(&error);
		} else if (Version::commandInvoked()) {
//			result = HandleVersion();
			result = new Version(&error);
		} else if (Object::commandInvoked()) {
//			result = HandleObject();
			result = new Object(&error);
		} else if (Describe::commandInvoked()) {
//			result = HandleDescribe();
			result = new Describe(&error);
		} else if (Alias::commandInvoked()) {
//			result = HandleAlias();
			result = new Alias(&error);
		} else {
			Log("Unknown command");
			result = new Help(&error);
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

