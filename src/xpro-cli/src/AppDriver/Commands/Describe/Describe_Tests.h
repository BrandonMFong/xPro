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

void Describe_Tests(void) {
	INTRO_TEST_FUNCTION;

	TestHandleDescribeNoAppDriver();

	printf("\n");
}


#endif /* SRC_APPDRIVER_COMMANDS_DESCRIBE_DESCRIBE_TESTS_H_ */

#endif // TESTING
