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

	success = xContainsSubString(string, substring, &error);

	printf("String containing substring: [ %s ]", success ? PASS : FAIL);
}

void xUtilities_Tests(void) {
	TestStringContainsSubString();
}

#endif /* SRC_XUTILITIES_TESTS_H_ */
