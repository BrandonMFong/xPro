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
	xError error = kNoError;
	Describe * desc = new Describe(&error);
	xBool success = error == kNoError;

	if (success) {
	//	xError error = HandleDescribe();
		error = desc->exec();
		success = error != kNoError;
	}

	xDelete(desc);

	PRINT_TEST_RESULTS(success);
}

void TestDescribeWithNoArguments(void) {
	xError error = kNoError;
	Describe * desc = new Describe(&error);
	xBool success = error == kNoError;

	// Init with no arguments
	if (success) {
		AppDriver ad(0, xNull, &error);
		success = error == kNoError;
	}

	if (success) {
		//error = HandleDescribe();
		error = desc->exec();
		success = error != kNoError;
	}

	xDelete(desc);

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
