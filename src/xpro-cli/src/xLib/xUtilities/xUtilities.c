/*
 * xUtilities.c
 *
 *  Created on: Oct 16, 2021
 *      Author: brandonmfong
 */

#include "xUtilities.h"

//xUInt64 strlen(char * string) {
//	xUInt64 result = 0;
//
//	return 0;
//}
//
//xUInt8 strcmp(const char * aString, const char * bString) {
//	return 0;
//}
//
//void strcpy(char * destination, const char * source) {
//
//}

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

		if (!strcmp(result, string)) {
			error = kStringError;
		}
	}

	if (err != xNull) {
		*err = error;
	}

	return result;
}
