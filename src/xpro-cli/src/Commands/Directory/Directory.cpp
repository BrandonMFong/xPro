/*
 * Directory.cpp
 *
 *  Created on: Oct 30, 2021
 *      Author: BrandonMFong
 */

#include "Directory.hpp"

xError HandleDirectory() {
	xError result = kNoError;
	char * dirAlias = xNull;
	xArguments * arguments = xNull;

	if (result == kNoError) {
		arguments = xArguments::shared();
		result = arguments != xNull ? kNoError : kArgError;
	}

	if (result == kNoError) {
		result = arguments->count() >= 3 ? kNoError : kArgError;

		if (result != kNoError) {
			DLog("Does not have correct count of arguments, actual: %d", arguments->count());
		}
	}

	if (result == kNoError) {
		dirAlias = arguments->argAtIndex(2, &result);
	}

	if (result == kNoError) {
		DLog("Finding path for alias %s", dirAlias);
	}

	return result;
}
