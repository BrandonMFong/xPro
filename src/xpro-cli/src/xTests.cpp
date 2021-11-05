/*
 * xTests.cpp
 *
 *  Created on: Oct 30, 2021
 *      Author: brandonmfong
 */

#include <xLib/Tests/xUtilities_Tests.h>
#include <Commands/Directory/Directory_Tests.h>
#include <xPro-CLI.h>

int xTests() {
	xUtilities_Tests();
	Directory_Tests();
	return 0;
}
