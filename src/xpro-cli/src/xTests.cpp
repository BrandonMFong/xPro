/*
 * xTests.cpp
 *
 *  Created on: Oct 30, 2021
 *      Author: brandonmfong
 */

#include <Commands/Directory/Directory_Tests.h>
#include <xPro-CLI.h>
#include <xTests/xUtilities_Tests.h>

int xTests() {
	xUtilities_Tests();
	Directory_Tests();
	return 0;
}
