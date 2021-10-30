/*
 * xFileSystemUtil.c
 *
 *  Created on: Oct 30, 2021
 *      Author: brandonmfong
 */

#include "xUtilities.h"
#include <sys/syslimits.h>

char * xHomePath(xError * err) {
	char * 	result 	= xNull;
	xError 	error 	= kNoError;
	char 	tempPath[PATH_MAX];

	if (error == kNoError) {
#if defined(__WINDOWS__)
		sprintf(tempPath, "%s%s", getenv("HOMEDRIVE"), getenv("HOMEPATH"));
#elif defined(__MACOS__)
		sprintf(tempPath, "%s", getenv("HOME"));
#elif defined(__LINUX__)
		sprintf(tempPath, "%s", getenv("HOME"));
#else
		DLog("No architecture defined for build\n");
		error = kOSError;
#endif

		if (strlen(tempPath) == 0) {
			error = kEmptyStringError;
		}
	}

	if (error == kNoError) {
		result = xCopyString(tempPath, &error);
	}

	if (err != xNull) {
		*err = error;
	}

	return result;
}

xBool xIsFile(const char * path) {
	xBool result = access(path, F_OK) == 0;

	if (!result) {
		DLog("'%s' does not exist\n", path);
	}

	return result;
}
