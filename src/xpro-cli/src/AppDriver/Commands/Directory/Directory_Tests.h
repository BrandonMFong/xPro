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
	xError error = kNoError;
	Directory * dir = new Directory(&error);
	success = error == kNoError;

	if (success) {
		error = dir->exec();
		success = error != kNoError;
	}

	xDelete(dir);

	PRINT_TEST_RESULTS(success);
}

void TestHandleDirectoryWithNoArguments() {
	xBool success = xTrue;
	xError error = kNoError;
	Directory * dir = xNull;

	// Init with no arguments
	AppDriver ad(0, xNull, &error);
	success = error == kNoError;

	if (success) {
		dir = new Directory(&error);
		success = error == kNoError;
	}

	if (success) {
		error = dir->exec();
		success = error != kNoError;
	}

	xDelete(dir);

	PRINT_TEST_RESULTS(success);
}

void TestHandleDirectoryWithOnlyDirArg() {
	xBool success = xTrue;
	xError error = kNoError;
	const char * argv[2] = {"xp", "dir"};
	Directory * dir = xNull;

	// Init with no arguments
	AppDriver ad((xInt8) (sizeof(argv) / sizeof(argv[0])), (char **) argv, &error);
	success = error == kNoError;
	
	if (success) {
		dir = new Directory(&error);
		success = error == kNoError;
	}

	if (success) {
		error = dir->exec();
		success = error != kNoError;
	}

	xDelete(dir);

	PRINT_TEST_RESULTS(success);
}

void TestHandleDirectory() {
	xBool success = xTrue;
	xError error = kNoError;
	const char * argv[3] = {"xp", "dir", "asdf"};
	Directory * dir = xNull;

	// Init with no arguments
	AppDriver ad((xInt8) (sizeof(argv) / sizeof(argv[0])), (char **) argv, &error);
	success = error == kNoError;
	
	if (success) {
		dir = new Directory(&error);
		success = error == kNoError;
	}

	if (success) {
		error = dir->exec();
		success = error == kNoError;
	}

	xDelete(dir);

	PRINT_TEST_RESULTS(success);
}

void Directory_Tests() {
	INTRO_TEST_FUNCTION;

	TestHandleDirectoryWithNoAppDriver();
	TestHandleDirectoryWithNoArguments();
	TestHandleDirectoryWithOnlyDirArg();
	TestHandleDirectory();

	printf("\n");
}

#endif /* SRC_COMMANDS_DIRECTORY_DIRECTORY_TESTS_H_ */

#endif // TESTING
