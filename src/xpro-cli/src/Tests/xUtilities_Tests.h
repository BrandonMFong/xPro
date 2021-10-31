/*
 * xUtilities_Tests.h
 *
 *  Created on: Oct 30, 2021
 *      Author: brandonmfong
 */

#ifndef SRC_XUTILITIES_TESTS_H_
#define SRC_XUTILITIES_TESTS_H_

#include <xPro-CLI.h>

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
	path = "C:\Path\To\Executable";
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

void xUtilities_Tests(void) {
	TestStringContainsSubString();
	TestCopyString();
	TestBasename();
}

#endif /* SRC_XUTILITIES_TESTS_H_ */
