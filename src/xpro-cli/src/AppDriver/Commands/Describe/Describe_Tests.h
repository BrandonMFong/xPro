/*
 * Describe_Tests.h
 *
 *  Created on: Mar 14, 2022
 *      Author: brandonmfong
 */

#ifdef TESTING

#ifndef SRC_APPDRIVER_COMMANDS_DESCRIBE_DESCRIBE_TESTS_H_
#define SRC_APPDRIVER_COMMANDS_DESCRIBE_DESCRIBE_TESTS_H_

#include "Describe.hpp"

void TestHandleDescribeNoAppDriver(void) {
	xBool success = xTrue;

	xError error = HandleDescribe();
	success = error != kNoError;

	PRINT_TEST_RESULTS(success);
}

void TestDescribeWithNoArguments(void) {
	xBool success = xTrue;
	xError error = kNoError;

	// Init with no arguments
	AppDriver ad(0, xNull, &error);
	success = error == kNoError;

	if (success) {
		error = HandleDescribe();
		success = error != kNoError;
	}

	PRINT_TEST_RESULTS(success);
}

void Describe_Tests(void) {
	INTRO_TEST_FUNCTION;

	TestHandleDescribeNoAppDriver();
	TestDescribeWithNoArguments();

	printf("\n");
}


#endif /* SRC_APPDRIVER_COMMANDS_DESCRIBE_DESCRIBE_TESTS_H_ */

#endif // TESTING
