/*
 * xStringUtil.c
 *
 *  Created on: Oct 30, 2021
 *      Author: brandonmfong
 */

#include "xUtilities.h"

char * xMallocString(xUInt64 length, xError * err) {
	char * result = xNull;
	xError error = kNoError;

	result	= (char *) malloc(length + 1);
	error 	= result != xNull ? kNoError : kUnknownError;

	if (error == kNoError) {
		strcpy(result, "");
	}

	if (err != xNull) {
		*err = error;
	}

	return result;
}

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

char ** xSplitString(
	const char *	string,
	const char * 	sep,
	xUInt8 *		size,
	xError * 		err
) {
	char 	** result 		= xNull,
			* tempString 	= xNull,
			* stringCopy	= xNull;
	xError 	error 			= kNoError;
	xBool 	okayToContinue 	= xTrue;
	xUInt64 index 			= 0,
			stringLength	= 0,
			resultSize 		= 0,
			sepIndex 		= 0,
			sepLength 		= 0;

	if ((string == xNull) || (sep == xNull)) {
		error = kStringError;
		DLog("Must provide a nonull string");
	} else {
		stringLength 	= strlen(string);
		sepLength		= strlen(sep);
	}

	if (error == kNoError) {
		result 	= (char **) malloc(sizeof(char *));
		error 	= result != xNull ? kNoError : kUnknownError;
	}

	if (error == kNoError) {
		// If we could not find the sub string, then we will just
		// return a single element array containing a copy of the
		// the input string
		if (!xContainsSubString(string, sep, &error)) {
			tempString = xCopyString(string, &error);

			if (error == kNoError) {
				result[0] 		= tempString;
				okayToContinue 	= xFalse;
			}
		} else {
			tempString = xMallocString(1, &error);
		}
	}

	if (okayToContinue) {

		// Sweep the entire string
		while ((index <= stringLength) && (error == kNoError)) {

			// For every character match between separator and
			// string, increment the separator index.  We want to
			// make sure that we identify the substring
			if (string[index] == sep[sepIndex]) {
				sepIndex++;
			} else {
				sepIndex = 0;
			}

			// If we have no more of the string left to sweep, i.e. index == stringLength,
			// then we need to finish inserting the last string
			if ((sepIndex < sepLength) && (index < stringLength)) {
				// Add 2 more spots, 1 for new and another for null character
				tempString 	= (char *) realloc(tempString, strlen(tempString) + 2);
				error 		= tempString != xNull ? kNoError : kUnknownError;

				if (error == kNoError) {
					stringCopy = xCopyString(tempString, &error);
				}

				// Add new character
				if (error == kNoError){
					sprintf(tempString, "%s%c", stringCopy, string[index]);
					xFree(stringCopy);
				}

			// If we found the substring, then add string tempString
			// into array
			} else {
				sepIndex = 0; // Reset index

				// Add string to array.  Keep the memory to the string
				result[resultSize] = tempString;
				resultSize++;

				// If we have more string to sweep, create new string, and another
				// index to the string array
				if (index < stringLength) {
					// Create empty string
					tempString = xMallocString(1, &error);

					// Add another index to the array for the next iteraction
					if (error == kNoError) {
						result 	= (char **) realloc(result, (sizeof(char *) * (resultSize + 1)));
						error 	= result != xNull ? kNoError : kUnknownError;
					}
				}
			}

			index++;
		}
	}

	if (size != xNull)
	{
		*size = resultSize;
	}

	if (err != xNull) {
		*err = error;
	}

	return result;
}
