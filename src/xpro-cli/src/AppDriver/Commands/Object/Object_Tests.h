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
	Object * obj = new Object(&error);

	success = error == kNoError;

	if (success) {
		//error = HandleObject();
		error = obj->exec();
		success = error != kNoError;
	}

	PRINT_TEST_RESULTS(success);
}

void TestHandleObjectWithAppDriver(void) {
	xBool success = xTrue;
	xError error = kNoError;
	const char * argv[3] = {"xp", "obj", "--create"};
	Object * obj = xNull;

	// Init with no arguments
	AppDriver ad((xInt8) (sizeof(argv) / sizeof(argv[0])), (char **) argv, &error);
	success = error == kNoError;
	
	if (success) {
		obj = new Object(&error);
		success = error == kNoError;
	}

	if (success) {
		// error = HandleObject();
		error = obj->exec();
		success = error != kNoError;
	}

	PRINT_TEST_RESULTS(success);
}

void Object_Tests() {
	INTRO_TEST_FUNCTION;

	TestHandleObjectWithNoAppDriver();
	TestHandleObjectWithAppDriver();

	printf("\n");
}

#endif // object_h

#endif // TESTING

