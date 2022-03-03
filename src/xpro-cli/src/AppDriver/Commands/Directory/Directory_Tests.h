/*
 * Directory_Tests.h
 *
 *  Created on: Nov 4, 2021
 *      Author: brandonmfong
 */

#ifdef TESTING

#ifndef SRC_COMMANDS_DIRECTORY_DIRECTORY_TESTS_H_
#define SRC_COMMANDS_DIRECTORY_DIRECTORY_TESTS_H_

#include "Directory.hpp"

void TestHandleDirectory() {
	xBool success = xTrue;

	PRINT_TEST_RESULTS(success);
}

void Directory_Tests() {
	INTRO_TEST_FUNCTION;

	TestHandleDirectory();
}

#endif /* SRC_COMMANDS_DIRECTORY_DIRECTORY_TESTS_H_ */

#endif // TESTING
