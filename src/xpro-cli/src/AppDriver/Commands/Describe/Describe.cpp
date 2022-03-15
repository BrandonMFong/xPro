/*
 * Describe.cpp
 *
 *  Created on: Mar 5, 2022
 *      Author: brandonmfong
 */


#include "Describe.hpp"
#include <AppDriver/AppDriver.hpp>

xError HandleDescribe() {
	xError result = kNoError;
	const xUInt8 argCount = 3;
	const char * argString = xNull;

	AppDriver * appDriver 	= AppDriver::shared();
	result 					= appDriver != xNull ? kNoError : kDriverError;

	if (result == kNoError) {
		result = appDriver->args.count() <= argCount ? kNoError : kArgError;
	}

	if (result == kNoError) {
		argString = appDriver->args.argAtIndex(2, &result);
	}

	if (result == kNoError) {

	}

	return result;
}

