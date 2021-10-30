/*
 * xUtilities.c
 *
 *  Created on: Oct 16, 2021
 *      Author: brandonmfong
 */

#include "xUtilities.h"

char * xCopyString(
		const char * 	string,
		xError * 		err
) {
	char * result 	= xNull;
	xError error 	= kNoError;

	if (error == kNoError) {
		result	= (char *) malloc(sizeof(char) * (strlen(string) + 1));
		error 	= result != xNull ? kNoError : kUnknownError;
	}

	if (error == kNoError) {
		strcpy(result, string);

		if (strcmp(result, string)) {
			error = kStringError;
		}
	}

	if (err != xNull) {
		*err = error;
	}

	return result;
}

char * xBasename(
		const char * 	path,
		xError * 		err
) {
	char * 	result 		= xNull;
	xError 	error 		= kNoError;
	char * 	tempString 	= xNull;

	if (error == kNoError) {
		error = path != xNull ? kNoError : kStringError;
	}

	if (error == kNoError) {
		result 	= (char *) malloc(sizeof(char) * (strlen(path) + 1));
		error 	= result != xNull ? kNoError : kUnknownError;
	}

	if (error == kNoError) {
		tempString 	= (char *) malloc(sizeof(char) * (strlen(path) + 1));
		error 		= tempString != xNull ? kNoError : kUnknownError;
	}

	if (error == kNoError) {
		for (xUInt64 i = strlen(path); i >= 0; i--) {
			if (path[i] == FILE_SYSTEM_SEPARATOR) break;
			else {
				strcpy(tempString, result);
				sprintf(result, "%c%s", path[i], tempString);
			}
		}
	}

	if (tempString != xNull) {
		free(tempString);
	}

	if (err != xNull) {
		*err = error;
	}

	return result;
}

char * xConfigFilePath(xError * err) {
	char * result 	= xNull;
	xError error 	= kNoError;
	char * homeDir 	= xNull;

	if (error == kNoError) {
		homeDir = xHomePath(&error);
	}

	if (error == kNoError) {
		result = (char *) malloc(strlen(homeDir) + 1);
		error = result != xNull ? kNoError : kUnknownError;
	}

	if (error == kNoError) {
		sprintf(result, "%s/.xpro/config.xml", homeDir);
		free(homeDir);

		if (strlen(result) == 0) {
			DLog("Unknown behavior, resulted in empty string");
			error = kEmptyStringError;
		}
	}

	if (err != xNull) {
		*err = error;
	}
	return result;
}

char * xHomePath(xError * err) {
	char * 	result 	= xNull;
	xError 	error 	= kNoError;
	char 	tempPath[PATH_MAX];

	if (error == kNoError) {
#if defined(__WINDOWS__)
		sprintf(tempPath, "%s%s", getenv("HOMEDRIVE"), getenv("HOMEPATH"));
#elif defined(__MACOS__)
		sprintf(tempPath, "%s", getenv("HOME"));
#else
		tempPath = ""; // Empty string
		DLog("No architecture defined for build");
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
