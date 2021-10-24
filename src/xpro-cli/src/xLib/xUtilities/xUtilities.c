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
