/*
 * xStringUtil.c
 *
 *  Created on: Oct 30, 2021
 *      Author: brandonmfong
 */

#include "xUtilities.h"

char * xCopyString(
		const char * 	string,
		xError * 		err
) {
	char * result 	= xNull;
	xError error 	= kNoError;

	result	= (char *) malloc((strlen(string) + 1));
	error 	= result != xNull ? kNoError : kUnknownError;

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

xBool xContainsSubString (
	const char * 	string,
	const char * 	subString,
	xError * 		err
) {
	xBool 	result 			= xFalse;
	xError 	error 			= kNoError;
	xUInt64 stringIndex 	= 0,
			subStringIndex 	= 0,
			stringLength 	= 0,
			subStringLength = 0;
	xBool 	foundSubString 	= xFalse;

	if ((string == xNull) || (subString == xNull)) {
		error = kStringError;
		DLog("Must provide a nonull string");
	} else {
		stringLength 	= strlen(string);
		subStringLength = strlen(subString);
	}

	if (error == kNoError) {
		// Sweep the string to find each character of the sub string sequentially
		while (		(stringIndex < stringLength)
				&& 	(subStringIndex < subStringLength)
		) {
			// If we found a match, keep track of the sub string match in
			// the subStringIndex
			if (string[stringIndex] == subString[subStringIndex]) {
				subStringIndex++;
			} else { // Otherwise reset the index
				subStringIndex = 0;
			}

			stringIndex++;
		}

		// If substring index equals sub string length then we have found each character
		// consecutively
		result = (subStringIndex == subStringLength);
	}

	if (err != xNull) {
		*err = error;
	}

	return result;
}

char ** xSplitString(char * string, char * separator, xError * err) {
	char ** result = xNull;
	xError error = kNoError;
	char * tempString = xNull;
	xBool okayToContinue = xTrue;
	xUInt64 index = 0, stringLength = 0;

	if ((string == xNull) || (separator == xNull)) {
		error = kStringError;
		DLog("Must provide a nonull string");
	} else {
		stringLength = strlen(string);
	}

	if (error == kNoError) {
		result = (char **) malloc(sizeof(char *));
		error = result != xNull ? kNoError : kUnknownError;
	}

	if (error == kNoError) {
		// If we could not find the sub string, then we will just
		// return a single element array containing a copy of the
		// the input string
		if (!xContainsSubString(string, separator)) {
			tempString = xCopyString(string, &error);

			if (error == kNoError) {
				result[0] 		= tempString;
				okayToContinue 	= xFalse;
			}
		} else {
			tempString = (char *) malloc(1); // Create empty string
			error = tempString != xNull ? kNoError : kUnknownError;
		}
	}

	if (okayToContinue && (error == kNoError)) {
		while ((index < stringLength)) {

			index++;
		}
	}

	if (err != xNull) {
		*err = error;
	}

	return result;
}
