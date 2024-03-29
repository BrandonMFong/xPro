/*
 * xTests.cpp
 *
 *  Created on: Oct 30, 2021
 *      Author: brandonmfong
 */

#ifdef TESTING

#include <xLib.h>

/// xLib tests
#include <Lib/Utilities/Utilities_Tests.h>

/// App tests
#include <AppDriver/Commands/Directory/Directory_Tests.h>
#include <AppDriver/Commands/Object/Object_Tests.h>
#include <AppDriver/Commands/Describe/Describe_Tests.h>

int xTests(int argc, char ** argv) {
	printf("\n");

	// Setup test path
	strcpy(testPath, dirname(argv[0]));

	xUtilities_Tests();
	Directory_Tests();
	Object_Tests();
	Describe_Tests();

	return 0;
}

#endif
