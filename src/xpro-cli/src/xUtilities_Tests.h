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

	printf("String containing substring: [ %s ]\n", success ? PASS : FAIL);
}

void xUtilities_Tests(void) {
	TestStringContainsSubString();
}

#endif /* SRC_XUTILITIES_TESTS_H_ */
