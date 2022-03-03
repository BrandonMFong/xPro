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

void TestHandleObjectWithNoAppDriver() {
	xBool success = xTrue;
	xError error = kNoError;

	error = HandleObject();
	success = error != kNoError;

	PRINT_TEST_RESULTS(success);
}

void Object_Tests() {
	INTRO_TEST_FUNCTION;

	TestHandleObjectWithNoAppDriver();

	printf("\n");
}

#endif // object_h

#endif // TESTING

