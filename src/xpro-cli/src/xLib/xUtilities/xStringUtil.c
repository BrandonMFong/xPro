/*
 * xStringUtil.c
 *
 *  Created on: Oct 30, 2021
 *      Author: brandonmfong
 */

#include "xUtilities.h"

char * xMallocString(xUInt64 length, xError * err) {
	char * result 	= xNull;
	xError error 	= kNoError;

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
			* tempCharPtr	= xNull;
	xError 	error 			= kNoError;
	xBool 	okayToContinue 	= xTrue;
	xUInt64 index 			= 0,
			stringLength	= 0,
			resultSize 		= 0,
			sepIndex 		= 0,
			sepLength 		= 0;

	if ((string == xNull) || (sep == xNull)) {
		error = kStringError;
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
				resultSize		= 1;
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
				tempCharPtr = xCharToString(string[index], &error);

				if (error == kNoError) {
					// Append the char to string
					error = xApendToString(&tempString, tempCharPtr);

					xFree(tempCharPtr);
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

xError xApendToString(
	char ** 		string,
	const char * 	stringToAppend
) {
	xError result 		= kNoError;
	char * stringCopy 	= xNull;

	// reallocating space for both strings
	*string = (char *) realloc(*string, strlen(*string) + strlen(stringToAppend) + 1);
	result 	= *string  != xNull ? kNoError : kUnknownError;

	if (result == kNoError) {
		stringCopy = xCopyString(*string, &result);
	}

	// Add new character
	if (result == kNoError){
		sprintf(
			*string, "%s%s",
			stringCopy, stringToAppend
		);

		xFree(stringCopy);
	}

	return result;
}

char * xCharToString(char ch, xError * err) {
	char * result = xMallocString(2, err);

	if (*err == kNoError) {
		result[0] = ch;
		result[1] = '\0';
	}

	return result;
}

char * xStringBetweenTwoStrings(
	const char * 	string,
	const char * 	firstString,
	const char * 	secondString,
	xError * 		err
) {
	char 	* result 		= xNull,
			* mainString 	= xNull;
	xError 	error 			= kNoError;
	xUInt64 index 			= 0,
			count 			= 0,
			subIndex 		= 0,
			subCount 		= 0,
			offset 			= -1;
	xBool 	okayToContinue 	= xFalse;

	if (	(firstString 	== xNull)
		|| 	(secondString 	== xNull)
		|| 	(string 		== xNull)) {
		error = kStringError;
	} else {
		mainString 	= (char *) string; // Save to new variable so that we can increment string
		count 		= strlen(mainString);
	}

	if (error == kNoError) {
		// Get the start of the string after firstString
		subCount = strlen(firstString);
		while (		(index 		< count)
				&& 	(subIndex 	< subCount)) {
			if (mainString[0] == firstString[subIndex]) subIndex++;
			else subIndex = 0;

			mainString++;
			index++;
		}

		// Find the index where the second string starts
		index 		= 0;
		subIndex 	= 0;
		count 		= strlen(mainString);
		subCount 	= strlen(secondString);
		while (		(index 		< count)
				&& 	(subIndex 	< subCount)) {
			if (mainString[index] == secondString[subIndex]) {
				subIndex++;

				// Save the index to insert null character if it wasn't already set
				if (offset == -1) offset = index;
			} else {
				subIndex 	= 0;
				offset 		= -1;
			}

			index++;
		}

		// If index == count then we found sub string
		okayToContinue = (subIndex == subCount);
	}

	if (okayToContinue && (error == kNoError)) {
		// We need to make sure we have a copy of the string because we originally
		// set this mainString var to hold the address where the param string is
		mainString = xCopyString(mainString, &error);
	}

	if (okayToContinue && (error == kNoError)) {
		mainString[offset] = '\0'; // Terminate string where the second string started

		// Copy string only up to where the null character is
		result = xCopyString(mainString, &error);
		xFree(mainString);
	}

	// If there is an error, make sure that we return null
	if (error != kNoError) {
		xFree(result);
	}

	if (err != xNull) {
		*err = error;
	}

	return result;
}
