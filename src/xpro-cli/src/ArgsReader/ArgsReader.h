/*
 * ArgsReader.h
 *
 *  Created on: Sep 16, 2021
 *      Author: BrandonMFong
 */

#ifndef ARGSREADER_ARGSREADER_H_
#define ARGSREADER_ARGSREADER_H_

#include <xLib.h>
#include <stdio.h>
#include <string.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
	const char * name;
	xBool passed;
	xUInt8 position;
} xFlag;

typedef struct {
	const char * name;
	char * value;
	xUInt8 position;
} xSwitch;

typedef struct {
	xFlag ** flags;
	xUInt8 flagCount;

	xSwitch ** switches;
	xUInt8 switchCount;

	char ** other;
	xUInt8 otherCount;
} xArgs;

xError readArgs(int argc, char ** argv, xArgs args);

#ifdef __cplusplus
}
#endif

#endif /* ARGSREADER_ARGSREADER_H_ */
