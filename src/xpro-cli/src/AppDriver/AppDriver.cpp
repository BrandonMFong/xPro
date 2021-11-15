/*
 * AppDriver.cpp
 *
 *  Created on: Nov 14, 2021
 *      Author: brandonmfong
 */

#include "AppDriver.hpp"

AppDriver * globalAppDriver = xNull;

AppDriver::AppDriver(xInt8 argc, char ** argv, xError * err) : args(argc, argv, err) {
	xError result = kNoError;

	if (err != xNull) {
		result = *err;
	}

	if (result != kNoError) {
		DLog("Shared args is null");
	} else {
		globalAppDriver = this;
	}

	if (err != xNull) {
		*err = result;
	}
}

AppDriver::~AppDriver() {
	// TODO Auto-generated destructor stub
}


void AppDriver::help(xBool moreInfo) {
	xError result 			= kNoError;
	char * executableName 	= xNull;

	if (result == kNoError) {
		executableName = this->args.argAtIndex(0, &result);
	}

	if (result == kNoError) {
		executableName = xBasename(executableName, &result);
	}

	if (result == kNoError) {
		printf("usage: %s\t[ %s ] [ %s ] <command> [<args>] \n\n",
				executableName,
				VERSION_ARG,
				HELP_ARG);
		free(executableName);

		printf("List of commands:\n");

		printf("\t%s\treturns directory for alias\n", DIR_ARG);

		printf("\n");
	}

	if (result != kNoError) {
		DLog("help ended in %d", result);
	}
}

xError AppDriver::run() {
	xError result = kNoError;
	xBool 			okayToContinue 	= xTrue;

	// See if the user wants help
	if (result == kNoError) {
		if (this->args.count() == 1) {
			printf("No arguments\n");

			this->help(xFalse);
			okayToContinue 	= xFalse;
		} else if (this->args.contains(HELP_ARG, &result) && (this->args.count() > 2)) {
			printf("Too many arguments for %s\n", HELP_ARG);

			this->help(xFalse);
			okayToContinue 	= xFalse;
		} else if (this->args.contains(HELP_ARG, &result)) {
			this->help(xTrue);
			okayToContinue 	= xFalse;
		}
	}

	// Run application
	if (okayToContinue && (result == kNoError)) {
		if (this->args.contains(DIR_ARG, &result)) {
			result = HandleDirectory();
		}
	}

	return result;
}


AppDriver * AppDriver::shared() {
	return globalAppDriver;
}
