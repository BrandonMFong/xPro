/*
 * Utilities.c
 *
 *  Created on: Nov 4, 2021
 *      Author: brandonmfong
 */

#include "Utilities.h"

char * ConfigFilePath(xError * err) {
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