/*
 * xTests.cpp
 *
 *  Created on: Oct 30, 2021
 *      Author: brandonmfong
 */

#ifdef TESTING

#include <xLib.h>

/// xLib tests
#include <xLib/xUtilities/xUtilities_Tests.h>
#include <xLib/xArguments/xArguments_Tests.h>
#include <xLib/xXML/xXML_Tests.h>

#include <AppDriver/Commands/Directory/Directory_Tests.h>

int xTests(int argc, char ** argv) {
	printf("\n");

	// Setup test path
	strcpy(testPath, dirname(argv[0]));

//	xUtilities_Tests();
//	xXML_Tests();
//	xArguments_Tests();
	Directory_Tests();

	return 0;
}

#endif
