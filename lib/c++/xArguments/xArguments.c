/*
 * ArgsReader.c
 *
 *  Created on: Sep 16, 2021
 *      Author: BrandonMFong
 */

#include <xArguments/xArguments.h>

xError readFlags(char * arg, xFlag ** flags, xUInt8 count) {
	xError result = kNoError;
	xFlag * flag = xNull;

	if (result == kNoError) {
		result = arg != xNull ? kNoError : kArgError;
	}

	if (result == kNoError) {
		for (xUInt8 i = 0; i < count; i++) {
			if (result == kNoError) {
				flag = flags[i];
				result = flag != xNull ? kNoError : xFlagError;
			}

			// Make sure string values are not null before try to compare them

			if (result == kNoError) {
				result = flag->name != xNull ? kNoError : xFlagError;
			}

			// If the arg is one of the flags, consider it as an argument that was passed
			if (result == kNoError) {
				// If the passed flag=true then we have already found this flag.  We throw an error when this happens
				if (!strcmp(arg, flag->name)) {
					if (flag->passed) {
						result = xRepeatedFlagError;
					} else {
						flag->passed = TRUE;
					}
				}
			}

			if (result != kNoError) {
				break;
			}
		}
	}

	return result;
}

xError readSwtiches(char * arg, xSwitch ** switches, xUInt8 switchCount) {
	xError result = kNoError;
	xSwitch * argSwitch = xNull;

	if (result == kNoError) {
		result = arg != xNull ? kNoError : kArgError;
	}

	if (result == kNoError) {
		for (xUInt8 i = 0; i < switchCount; i++) {
			if (result == kNoError) {
				argSwitch = switches[i];
				result = argSwitch != xNull ? kNoError : xSwitchError;
			}

			if (result == kNoError) {
				result = argSwitch->key != xNull ? kNoError : xSwitchError;
			}

			if (result == kNoError) {
				if (!strcmp(arg, argSwitch->key)) {
					if (argSwitch->passed) {
						result = xRepeatedFlagError;
					} else {
						argSwitch->passed = TRUE;
					}
				}
			}

			if (argSwitch->passed && (result == kNoError)) {

			}

			if (result != kNoError) {
				break;
			}
		}
	}

	return result;
}

xError readArgs(int argc, char ** argv, xArgs args) {
	xError result = kNoError;

	if (result == kNoError) {
		for (xUInt8 i = 0; i < argc; i++) {
			if (result == kNoError) {
				result = readFlags(argv[i], args.flags, args.flagCount);
			}

			if (result != kNoError) {
				break;
			}
		}
	}

	return result;
}
