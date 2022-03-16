/*
 * Alias.cpp
 *
 *  Created on: Mar 15, 2022
 *      Author: brandonmfong
 */


#include "Alias.hpp"
#include <AppDriver/AppDriver.hpp>
#include <AppDriver/Commands/Commands.h>

xError HandleAlias(void) {
	xError result = kNoError;
	const char 		* arg 			= xNull,
					* configPath	= xNull;
	const xUInt8	argCount 		= 5; // max arg count

	AppDriver * appDriver 	= AppDriver::shared();
	result 					= appDriver != xNull ? kNoError : kDriverError;

	if (result == kNoError) {
		result = appDriver->args.count() <= argCount ? kNoError : kArgError;

		if (result != kNoError) {
			DLog("The amount of arguments must be %d", argCount);
		}
	}

	return result;
}

