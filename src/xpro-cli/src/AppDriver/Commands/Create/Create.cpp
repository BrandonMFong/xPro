/*
 * Create.cpp
 *
 *  Created on: Nov 14, 2021
 *      Author: brandonmfong
 */

#include "Create.hpp"
#include <AppDriver/AppDriver.hpp>
#include <AppDriver/Commands/Commands.h>

xError HandleCreate(void) {
	xError result = kNoError;
	AppDriver * appDriver = xNull;
	const char * subCommand = xNull;

	appDriver = AppDriver::shared();
	result = appDriver != xNull ? kNoError : kNullError;

	if (result == kNoError) {
		result = appDriver->args.count() <= 3 ? kNoError : kNullError;
	}

	if (result == kNoError) {
		subCommand = appDriver->args.argAtIndex(2, &result);
	}

	if (result == kNoError) {
		if (!strcmp(subCommand, CREATE_XPRO_ARG)) {

		}
	}

	return result;
}

xError CreateXProHomePath() {
	xError result = kNoError;

	return result;
}
