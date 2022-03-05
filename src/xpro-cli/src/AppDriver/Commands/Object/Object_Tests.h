/*
 * Object_Tests.h
 *
 *  Created on: Mar 2, 2022
 *      Author: brandonmfong
 */

#include "Object.hpp"

#ifdef TESTING

#ifndef object_h
#define object_h

void TestHandleObjectWithNoAppDriver(void) {
	xBool success = xTrue;
	xError error = kNoError;

	error = HandleObject();
	success = error != kNoError;

	PRINT_TEST_RESULTS(success);
}

void TestHandleObjectWithAppDriver(void) {
	xBool success = xTrue;
	xError error = kNoError;
	const char * argv[3] = {"xp", "obj", "--create"};

	// Init with no arguments
	AppDriver ad((xInt8) (sizeof(argv) / sizeof(argv[0])), (char **) argv, &error);
	success = error == kNoError;

	if (success) {
		error = HandleObject();
		success = error != kNoError;
	}

	PRINT_TEST_RESULTS(success);
}

void TestHandlingObjectIndex(void) {
	xBool success = xTrue;
	xError error = kNoError;

	const char * argv[5] = {"xp", "obj", "-index", "0", "--value"};

	// Init with no arguments
	AppDriver ad((xInt8) (sizeof(argv) / sizeof(argv[0])), (char **) argv, &error);

	error = HandleObjectIndex();

	PRINT_TEST_RESULTS(success);
}

void TestHandlingObjectIndexWithoutIndexValue(void) {
	xBool success = xTrue;
	xError error = kNoError;

	const char * argv[4] = {"xp", "obj", "-index", "--value"};

	// Init with no arguments
	AppDriver ad((xInt8) (sizeof(argv) / sizeof(argv[0])), (char **) argv, &error);

	success = HandleObjectIndex() != kNoError;

	PRINT_TEST_RESULTS(success);
}

void TestHandlingObjectWithLittleArguments(void) {
	xBool success = xTrue;
	xError error = kNoError;

	const char * argv[3] = {"xp", "obj", "-index"};

	// Init with no arguments
	AppDriver ad((xInt8) (sizeof(argv) / sizeof(argv[0])), (char **) argv, &error);

	success = HandleObjectIndex() != kNoError;

	PRINT_TEST_RESULTS(success);
}

void Object_Tests() {
	INTRO_TEST_FUNCTION;

	TestHandleObjectWithNoAppDriver();
	TestHandleObjectWithAppDriver();
	TestHandlingObjectIndex();
	TestHandlingObjectIndexWithoutIndexValue();
	TestHandlingObjectWithLittleArguments();

	printf("\n");
}

#endif // object_h

#endif // TESTING

