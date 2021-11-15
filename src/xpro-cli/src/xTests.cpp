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

int xTests() {
	printf("\n");

	xUtilities_Tests();
	xXML_Tests();
	xArguments_Tests();

	return 0;
}

#endif
