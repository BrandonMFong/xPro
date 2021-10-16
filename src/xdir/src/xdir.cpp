//============================================================================
// Name        : xdir.cpp
// Author      : 
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C++, Ansi-style
//============================================================================

#include "xLib.h"

typedef struct
{
	xUInt8 position;
	const char * name;
	char * value;
} xSwitch;

typedef struct
{
	xUInt8 position;
	const char * name;
	xBool passed;
} xFlag;

typedef struct
{
	xUInt8 switchCount;
	xSwitch ** switches;
	xUInt8 flagCount;
	xFlag ** flags;
} xArgs;

xError ReadArgs(int argc, char ** argv, xArgs arguments) {
	xError result = kNoError;
	xSwitch ** switches = xNull;
	xFlag ** flags = xNull;

	if (result == kNoError) {
		switches = arguments.switches;
		result = switches != xNull ? kNoError : kSwitchError;
	}

	if (result == kNoError) {
		for (xUInt8 i = 0; i < argc; i++) {
			if (result == kNoError) {

			}

			if (result != kNoError) break;
		}
	}

	return result;
}

#pragma mark - Switches

#define kSwtichArgCount 2
xSwitch keyArg = {
		.position = 0,
		.name = "-key",
		.value = xNull
};

xSwitch valueArg = {
		.position = 0,
		.name = "-value",
		.value = xNull
};
xSwitch  * switches[kSwtichArgCount] = {
		&keyArg,
		&valueArg
};

xArgs arguments = {
		.switchCount = kSwtichArgCount,
		.switches = switches,
		.flagCount = 0,
		.flags = xNull
};

int main(int argc, char ** argv) {
	xError result = kNoError;

	if (result == kNoError) {

	}

	return result;
}
