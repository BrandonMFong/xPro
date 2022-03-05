/*
 * xFileSystemUtil.c
 *
 *  Created on: Oct 30, 2021
 *      Author: brandonmfong
 */

#include "xUtilities.h"

#if defined(__MACOS__)
#include <sys/syslimits.h>
#endif

char * xHomePath(xError * err) {
	char * 	result 	= xNull;
	xError 	error 	= kNoError;
	char 	tempPath[MAX_PATH_LENGTH];

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
	return access(path, F_OK) == 0;
}

xBool xIsDir(const char * path) {
	xBool 	result 	= xFalse;
	DIR * 	d 		= xNull;

	d = opendir(path);
	if (d != NULL) {
		closedir(d);
		result = xTrue;
	}

	return result;
}

xError xMkDir(const char * path) {
	xError result = kNoError;

	if (!xIsDir(path)) {
		if (MAKE_DIR(path) == -1) {
			result = kDirectoryError;
			DLog("Could not create %s", path);
		}

		if (result == kNoError) {
			if (!xIsDir(path)) {
				result = kDirectoryError;
				DLog("Directory still does not exist, %s", path);
			}
		}
	}

	return result;
}
