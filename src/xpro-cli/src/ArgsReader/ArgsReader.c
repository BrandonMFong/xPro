/*
 * ArgsReader.c
 *
 *  Created on: Sep 16, 2021
 *      Author: BrandonMFong
 */

#include <ArgsReader/ArgsReader.h>

xError readFlags(char * arg, xFlag ** flags, xUInt8 count) {
	xError result = kNoError;
	xFlag * flag = xNull;

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

			if (result == kNoError) {
				result = arg != xNull ? kNoError : kArgError;
			}

			// If the arg is one of the flags, consider it as an argument that was passed
			if (result == kNoError) {
				flag->passed = !strcmp(arg, flag->name) ? TRUE : FALSE;
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

	for (xUInt8 i = 0; i < argc; i++) {
		if (result == kNoError) {
			result = readFlags(argv[i], args.flags, args.flagCount);
		}

		if (result != kNoError) {
			break;
		}
	}

	return result;
}
