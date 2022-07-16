/*
 * Help.cpp
 *
 *  Created on: Mar 15, 2022
 *      Author: brandonmfong
 */


#include "Help.hpp"
#include <AppDriver/AppDriver.hpp>
#include <AppDriver/Commands/Alias/Alias.hpp>
#include <AppDriver/Commands/Create/Create.hpp>
#include <AppDriver/Commands/Describe/Describe.hpp>
#include <AppDriver/Commands/Directory/Directory.hpp>
#include <AppDriver/Commands/Object/Object.hpp>
#include <AppDriver/Commands/Version/Version.hpp>

const char * const DESCRIBE_COMMAND_HELP_ARG = "help";
const char * const COMMAND = "--help";

const char * Help::command() {
	return COMMAND;
}

xBool Help::invoked() {
	AppDriver * appDriver = AppDriver::shared();

	if (appDriver == 0) {
		DLog("The app driver object is null");
		return xFalse;

	// Print default help
	} else if (appDriver->args.count() == 1) {
		return xTrue;

	// Print default help
	} else if (appDriver->args.contains(COMMAND) && (appDriver->args.count() > 2)) {
		return xTrue;

	// Print help for command
	} else if (		appDriver->args.contains(DESCRIBE_COMMAND_HELP_ARG)
				&& 	(appDriver->args.count() > 2)) {
		return xTrue;

	// Print help for all commands and app info
	} else if (appDriver->args.contains(COMMAND)) {
		DLog("%s was passed", COMMAND);
		return xTrue;
	} else {
		DLog("Defaulting to false case");
		DLog("Does args contain %s? %d", COMMAND, appDriver->args.contains(COMMAND));
		return xFalse;
	}
}

Help::Help(xError * err) : Command(err) {

}

Help::~Help() {

}

xError Help::exec() {
	AppDriver * appDriver = AppDriver::shared();

	// See if the user wants help

	// Print default help
	if (appDriver->args.count() == 1) {
		HandleHelp(0);

	// Print default help
	} else if (appDriver->args.contains(COMMAND) && (appDriver->args.count() > 2)) {
		Log("Too many arguments for %s\n", COMMAND);

		HandleHelp(0);

	// Print help for command
	} else if (		appDriver->args.contains(DESCRIBE_COMMAND_HELP_ARG)
				&& 	(appDriver->args.count() > 2)) {
		HandleHelp(2);

	// Print help for all commands and app info
	} else if (appDriver->args.contains(COMMAND)) {
		HandleHelp(1);
	} else {
		DLog("Unknown error occurred");
	}

	return kNoError;
}

xError Help::HandleHelp(xUInt8 printType) {
	xError result = kNoError;

	if (result == kNoError) {
		PrintHeader();

		printf("\n");

		switch (printType) {

		// Display info about commands
		case 2:
			if (AppDriver::shared()->args.contains(Version::command())) {
				Version::help();
			} else if (AppDriver::shared()->args.contains(Directory::command())) {
				Directory::help();
			} else if (AppDriver::shared()->args.contains(Create::command())) {
				Create::help();
			} else if (AppDriver::shared()->args.contains(Object::command())) {
				Object::help();
			} else if (AppDriver::shared()->args.contains(Describe::command())) {
				Describe::help();
			} else if (AppDriver::shared()->args.contains(Alias::command())) {
				Alias::help();
			} else {
				printf("No description\n");
			}

			printf("\n");

			break;

		// Prints brief descriptions on commands and entire application
		case 1:
			printf("List of commands:\n");

			// Version arg
			printf("\t%s\t\t%s\n", Version::command(), Version::brief());

			// Directory arg
			printf("\t%s\t\t%s\n", Directory::command(), Directory::brief());

			// Create arg
			printf("\t%s\t\t%s\n", Create::command(), Create::brief());

			// Object arg
			printf("\t%s\t\t%s\n", Object::command(), Object::brief());

			// Describe arg
			printf("\t%s\t%s\n", Describe::command(), Describe::brief());

			// Alias arg
			printf("\t%s\t\t%s\n", Alias::command(), Alias::brief());

			printf("\n");

			break;
		case 0:
		default:

			break;
		}

		PrintFooter();
	}

	return result;
}

void Help::PrintHeader(void) {
	printf(
		"usage: %s [ %s ] <command> [<args>] \n",
		AppDriver::shared()->execName(),
		COMMAND
	);
}

void Help::PrintFooter(void) {

	printf(
		"Use '%s %s <cmd>' to see more information on the above commands\n",
		AppDriver::shared()->execName(),
		DESCRIBE_COMMAND_HELP_ARG
	);

	printf(
		"%s-v%c copyright %s. All rights reserved.\n",
		APP_NAME,
		VERSION[0],
		&__DATE__[7]
	);
}

