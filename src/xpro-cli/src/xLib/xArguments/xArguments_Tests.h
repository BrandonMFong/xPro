/*
 * xArguments_Tests.h
 *
 *  Created on: Nov 14, 2021
 *      Author: brandonmfong
 */

#ifndef SRC_XLIB_XARGUMENTS_XARGUMENTS_TESTS_H_
#define SRC_XLIB_XARGUMENTS_XARGUMENTS_TESTS_H_

#include <xLib.h>

void TestInitializer(void) {
	xInt8 argc = 3;
	char * argv[argc];
	xBool success = xTrue;
	xError error = kNoError;
	xArguments * args = xNull;

	if (success) {
		argv[0] = xCopyString("Hello", &error);
		success = (error == kNoError);
	}

	if (success) {
		argv[1] = xCopyString("World", &error);
		success = (error == kNoError);
	}

	if (success) {
		argv[2] = xCopyString("Yes", &error);
		success = (error == kNoError);
	}

	if (success) {
		args = new xArguments(argc, argv, &error);
		if (args == xNull) {
			success = xFalse;
			printf("Argument object is NULL\n");
		} else if (error != kNoError) {
			success = xFalse;
			printf("Error %d\n", error);
		}
	}

	if (success) {
		success = (args->count() == argc);

		if (!success) {
			printf("Count does not match, %d != %d", args->count(), argc);
		}

		PRINT_TEST_RESULTS(success);
	}

	delete args;
}

void TestGettingIndexForArgument(void) {
	const char * argv[3] = {"hello", "world", "Brando"};
	xError error = kNoError;

	xArguments args((sizeof(argv) / sizeof(argv[0])), (char **) argv, &error);
	xBool success = error == kNoError;

	xInt8 i = 0;

	if (success) {
		i = args.indexForArg("world", &error);
		success = error == kNoError;
	}

	if (success) {
		success = i == 1;
	}

	if (success) {
		i = args.indexForArg("worlds", &error);
		success = error == kNoError;
	}

	if (success) {
		success = i == -1;
	}

	PRINT_TEST_RESULTS(success);
}

void xArguments_Tests(void) {
	INTRO_TEST_FUNCTION;

	TestInitializer();
	TestGettingIndexForArgument();

	printf("\n");
}

#endif /* SRC_XLIB_XARGUMENTS_XARGUMENTS_TESTS_H_ */
