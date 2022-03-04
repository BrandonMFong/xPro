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
#include <AppDriver/AppDriver.hpp>

void TestHandleDirectoryWithNoAppDriver() {
	xBool success = xTrue;

	xError error = HandleDirectory();
	success = error != kNoError;

	PRINT_TEST_RESULTS(success);
}

void TestHandleDirectoryWithNoArguments() {
	xBool success = xTrue;
	xError error = kNoError;

	// Init with no arguments
	AppDriver ad(0, xNull, &error);
	success = error == kNoError;

	if (success) {
		error = HandleDirectory();
		success = error != kNoError;
	}

	PRINT_TEST_RESULTS(success);
}

void TestHandleDirectoryWithOnlyDirArg() {
	xBool success = xTrue;
	xError error = kNoError;
	const char * argv[2] = {"xp", "dir"};

	// Init with no arguments
	AppDriver ad((xInt8) (sizeof(argv) / sizeof(argv[0])), (char **) argv, &error);
	success = error == kNoError;

	if (success) {
		error = HandleDirectory();
		success = error != kNoError;
	}

	PRINT_TEST_RESULTS(success);
}

void TestHandleDirectory() {
	xBool success = xTrue;
	xError error = kNoError;
	const char * argv[3] = {"xp", "dir", "asdf"};

	// Init with no arguments
	AppDriver ad((xInt8) (sizeof(argv) / sizeof(argv[0])), (char **) argv, &error);
	success = error == kNoError;

	if (success) {
		error = HandleDirectory();
		success = error == kNoError;
	}

	PRINT_TEST_RESULTS(success);
}

void TestPrintDirectoryWithNullKey() {
	xBool success = xTrue;
	xError error = kNoError;

	error = PrintDirectoryForKey(xNull);
	success = error != kNoError;

	PRINT_TEST_RESULTS(success);
}

void TestPrintDirectoryWithKey() {
	xBool success = xTrue;
	xError error = kNoError;

	error = PrintDirectoryForKey("docs");
	success = error != kNoError;

	PRINT_TEST_RESULTS(success);
}

void Directory_Tests() {
	INTRO_TEST_FUNCTION;

	TestHandleDirectoryWithNoAppDriver();
	TestHandleDirectoryWithNoArguments();
	TestHandleDirectoryWithOnlyDirArg();
	TestHandleDirectory();
	TestPrintDirectoryWithNullKey();
	TestPrintDirectoryWithKey();

	printf("\n");
}

#endif /* SRC_COMMANDS_DIRECTORY_DIRECTORY_TESTS_H_ */

#endif // TESTING
