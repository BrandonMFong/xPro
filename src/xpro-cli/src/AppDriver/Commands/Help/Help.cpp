/*
 * Help.cpp
 *
 *  Created on: Mar 15, 2022
 *      Author: brandonmfong
 */


#include "Help.hpp"
#include <AppDriver/AppDriver.hpp>
#include <AppDriver/Commands/Commands.h>

xBool Help::commandInvoked() {
	AppDriver * appDriver = AppDriver::shared();

	if (appDriver == 0) {
		DLog("The app driver object is null");
		return xFalse;

	// Print default help
	} else if (appDriver->args.count() == 1) {
		return xTrue;

	// Print default help
	} else if (appDriver->args.contains(HELP_ARG) && (appDriver->args.count() > 2)) {
		return xTrue;

	// Print help for command
	} else if (		appDriver->args.contains(DESCRIBE_COMMAND_HELP_ARG)
				&& 	(appDriver->args.count() > 2)) {
		return xTrue;

	// Print help for all commands and app info
	} else if (appDriver->args.contains(HELP_ARG)) {
		DLog("%s was passed", HELP_ARG);
		return xTrue;
	} else {
		DLog("Defaulting to false case");
		DLog("%d", appDriver->args.contains(HELP_ARG));
		appDriver->args.print();
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
	} else if (appDriver->args.contains(HELP_ARG) && (appDriver->args.count() > 2)) {
		Log("Too many arguments for %s\n", HELP_ARG);

		HandleHelp(0);

	// Print help for command
	} else if (		appDriver->args.contains(DESCRIBE_COMMAND_HELP_ARG)
				&& 	(appDriver->args.count() > 2)) {
		HandleHelp(2);

	// Print help for all commands and app info
	} else if (appDriver->args.contains(HELP_ARG)) {
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
			if (AppDriver::shared()->args.contains(VERSION_ARG)) {
				PrintVersionHelp();
			} else if (AppDriver::shared()->args.contains(DIR_ARG)) {
				PrintDirectoryHelp();
			} else if (AppDriver::shared()->args.contains(CREATE_ARG)) {
				PrintCreateHelp();
			} else if (AppDriver::shared()->args.contains(OBJ_ARG)) {
				PrintObjectHelp();
			} else if (AppDriver::shared()->args.contains(DESCRIBE_ARG)) {
				PrintDescribeHelp();
			} else if (AppDriver::shared()->args.contains(ALIAS_ARG)) {
				//PrintAliasHelp();
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
			printf("\t%s\t\t%s\n", VERSION_ARG, VERSION_ARG_BRIEF);

			// Directory arg
			printf("\t%s\t\t%s\n", DIR_ARG, DIR_ARG_BRIEF);

			// Create arg
			printf("\t%s\t\t%s\n", CREATE_ARG, CREATE_ARG_BRIEF);

			// Object arg
			printf("\t%s\t\t%s\n", OBJ_ARG, OBJ_ARG_BRIEF);

			// Describe arg
			printf("\t%s\t%s\n", DESCRIBE_ARG, DESCRIBE_ARG_BRIEF);

			// Alias arg
			printf("\t%s\t\t%s\n", ALIAS_ARG, ALIAS_ARG_BRIEF);

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
		HELP_ARG
	);
}

void Help::PrintVersionHelp(void) {
	printf("Command: %s %s <arg>\n", AppDriver::shared()->execName(), VERSION_ARG);
	printf("\nBrief: %s\n", VERSION_ARG_BRIEF);
	printf("\nDiscussion:\n");
	printf("  %s\n", VERSION_ARG_DISCUSSION);
	printf("\nArguments:\n");
	printf("  %s: %s\n", LONG_ARG, LONG_ARG_INFO);
	printf("  %s: %s\n", SHORT_ARG, SHORT_ARG_INFO);
}

void Help::PrintDirectoryHelp(void) {
	printf("Command: %s %s <key>\n", AppDriver::shared()->execName(), DIR_ARG);
	printf("\nBrief: %s\n", DIR_ARG_BRIEF);
	printf("\nDiscussion:\n");
	printf("%s\n", DIR_ARG_DISCUSSION);
	printf("\nArguments: %s\n", DIR_ARG_INFO);
}

void Help::PrintCreateHelp(void) {
	printf("Command: %s %s <arg>\n", AppDriver::shared()->execName(), CREATE_ARG);
	printf("\nBrief: %s\n", CREATE_ARG_BRIEF);
	printf("\nDiscussion:\n");
	printf("  %s\n", CREATE_ARG_DISCUSSION);
	printf("\nArguments:\n");
	printf("  %s: %s\n", XPRO_HOME_ARG, CREATE_XPRO_ARG_INFO);
	printf("  %s: %s\n", USER_CONF_ARG, CREATE_USER_CONF_ARG_INFO);
	printf("  %s: %s\n", ENV_CONF_ARG, CREATE_ENV_CONF_ARG_INFO);
}

void Help::PrintObjectHelp(void) {
	printf(
		"Command: %s %s [ %s ] [ %s <num> ] [ %s | %s ] \n",
		AppDriver::shared()->execName(),
		OBJ_ARG,
		COUNT_ARG,
		INDEX_ARG,
		VALUE_ARG,
		NAME_ARG
	);
	printf("\nBrief: %s\n", OBJ_ARG_BRIEF);
	printf("\nDiscussion:\n");
	printf("  %s\n", OBJ_ARG_DISCUSSION);
	printf("\nArguments:\n");
	printf("  %s: %s\n", COUNT_ARG, OBJ_COUNT_ARG_INFO);
	printf("  %s: %s\n", INDEX_ARG, OBJ_INDEX_ARG_INFO);
	printf("  %s: %s\n", VALUE_ARG, OBJ_VALUE_ARG_INFO);
	printf("  %s: %s\n", NAME_ARG, OBJ_NAME_ARG_INFO);
}

void Help::PrintDescribeHelp(void) {
	printf("Command: %s %s <arg>\n", AppDriver::shared()->execName(), DESCRIBE_ARG);
	printf("\nBrief: %s\n", DESCRIBE_ARG_BRIEF);
	printf("\nDiscussion:\n");
	printf("  %s\n", DESCRIBE_ARG_DISCUSSION);
	printf("\nArguments:\n");
	printf("  %s: %s\n", XPRO_HOME_ARG, DESCRIBE_XPRO_ARG_INFO);
	printf("  %s: %s\n", USER_CONF_ARG, DESCRIBE_USER_CONF_ARG_INFO);
	printf("  %s: %s\n", ENV_CONF_ARG, DESCRIBE_ENV_CONF_ARG_INFO);
}

void Help::PrintAliasHelp(void) {
	printf(
		"Command: %s %s [ %s ] [ %s <num> ] [ %s | %s ] \n",
		AppDriver::shared()->execName(),
		ALIAS_ARG,
		COUNT_ARG,
		INDEX_ARG,
		VALUE_ARG,
		NAME_ARG
	);
	printf("\nBrief: %s\n", ALIAS_ARG_BRIEF);
	printf("\nDiscussion:\n");
	printf("  %s\n", ALIAS_ARG_DISCUSSION);
	printf("\nArguments:\n");
	printf("  %s: %s\n", COUNT_ARG, ALIAS_COUNT_ARG_INFO);
	printf("  %s: %s\n", INDEX_ARG, ALIAS_INDEX_ARG_INFO);
	printf("  %s: %s\n", VALUE_ARG, ALIAS_VALUE_ARG_INFO);
	printf("  %s: %s\n", NAME_ARG, ALIAS_NAME_ARG_INFO);
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
