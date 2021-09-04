/*
 * xArray_tests.cpp
 *
 *  Created on: Sep 2, 2021
 *      Author: BrandonMFong
 */

#include "xArray_tests.hpp"

void xArrayRunTests(void) {
	testInitializer();
}

void testInitializer(void) {
	xArray * array = new xArray();

	xAssert(true, "Test assert");
	xAssert(true, "Test assert");
	xUTResults(true, "Testing initializer");
}
