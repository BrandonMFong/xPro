/*
 * xUtilities_Tests.h
 *
 *  Created on: Oct 30, 2021
 *      Author: brandonmfong
 */

#ifndef SRC_XUTILITIES_TESTS_H_
#define SRC_XUTILITIES_TESTS_H_

#include <xPro-CLI.h>
#include <stdio.h>

void TestStringContainsSubString(void) {
	xBool success = xTrue;

	const char * string = "Hello world, this is xPro!";
	const char * substring = "world";
	xError error = kNoError;

	if (!xContainsSubString(string, substring, &error)) {
		printf("%s should be in %s\n", substring, string);
		success = xFalse;
	} else {
		success = error == kNoError;

		if (!success) {
			printf("Error %d\n", error);
		}
	}

	if (success) {
		substring = "no sub string";
		if (xContainsSubString(string, substring, &error)) {
			success = xFalse;
			printf("%s should not be in %s\n", substring, string);
		} else {
			success = error == kNoError;
		}
	}

	PRINT_TEST_RESULTS(success);
}

void TestCopyString(void) {
	xError error = kNoError;
	const char * string = "Hello world";
	char * result = xCopyString(string, &error);

	xBool success = xTrue;
	if (error == kNoError) {
		if (strcmp(result, string)) {
			success = xFalse;
			printf("%s != %s\n", result, string);
		} else {
			free(result);
		}
	} else {
		success = xFalse;
		printf("Copying string failed, %d\n", error);
	}

	PRINT_TEST_RESULTS(success);
}

void TestBasename(void) {
	xBool success = xTrue;
	const char * path = xNull;

#if defined(__MACOS__) || defined(__LINUX__)
	path = "/Path/To/Executable";
#elif defined(__WINDOWS__)
	path = "C:\\Path\\To\\Executable";
#else
	success = xFalse;
	printf("No os defined in build\nPlease check config\n");
#endif
	xError error = kNoError;
	char * result = xBasename(path, &error);

	if (success) {
		if (strcmp(result, "Executable")) {
			success = xFalse;
			printf("'%s' is not the executable name from '%s'\n", result, path);
		} else if (error != kNoError) {
			success = xFalse;
			printf("Error %d\n", error);
		}
	}

	PRINT_TEST_RESULTS(success);
}

void TestSplitString(void) {
	xBool success = xTrue;

	const char 	* sep 		= "|",
				* Is 		= "Is",
				* A 		= "A",
				* String 	= "String";
	char string[	strlen(sep)
				+ 	strlen(Is)
				+ 	strlen(sep)
				+ 	strlen(A)
				+ 	strlen(sep)
				+ 	strlen(String)
				+ 	1];
	char * tempString 	= xNull;
	xUInt8 expectedSize = 4; // 4 because we start with the separator
	xUInt8 actualSize 	= 0;

	sprintf(string, "%s%s%s%s%s%s", sep, Is, sep, A, sep, String);

	xError error = kNoError;
	char ** result = xSplitString(string, sep, &actualSize, &error);

	if (error != kNoError) {
		printf("Error getting split string %d\n", error);
		success = xFalse;
	}

	if (success) {

		success = expectedSize == actualSize;
		if (!success) {
			printf("Size of split string array is %d, expected is %d\n", actualSize, expectedSize);
		}
	}

	if (success) {
		tempString = result[1];
		success = !strcmp(tempString, Is);
		if (!success) {
			printf("(1) %s != %s\n", tempString, Is);
		}
	}

	if (success) {
		tempString = result[2];
		success = !strcmp(tempString, A);
		if (!success) {
			printf("(2) %s != %s\n", tempString, A);
		}
	}

	if (success) {
		tempString = result[3];
		success = !strcmp(tempString, String);
		if (!success) {
			printf("(3) %s != %s\n", tempString, String);
		}
	}

	PRINT_TEST_RESULTS(success);
}

void xUtilities_Tests(void) {
	TestStringContainsSubString();
	TestCopyString();
	TestBasename();
	TestSplitString();
}

#endif /* SRC_XUTILITIES_TESTS_H_ */
