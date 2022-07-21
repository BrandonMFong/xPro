/*
 * Command.cpp
 *
 *  Created on: Jun 29, 2022
 *      Author: brandonmfong
 */

#include "Command.hpp"
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

	// Run application
	if (Help::invoked()) {
		result = new Help(&error);
	} else if (Directory::invoked()) {
		result = new Directory(&error);
	} else if (Create::invoked()) {
		result = new Create(&error);
	} else if (Version::invoked()) {
		result = new Version(&error);
	} else if (Object::invoked()) {
		result = new Object(&error);
	} else if (Describe::invoked()) {
		result = new Describe(&error);
	} else if (Alias::invoked()) {
		result = new Alias(&error);
	} else {
		Log("Unknown command");
		result = new Help(&error);
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

