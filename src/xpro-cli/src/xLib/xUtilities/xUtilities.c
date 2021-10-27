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

char * xBasename(const char * path, xError * err) {
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
			if (path[i] == '\\') break;
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
