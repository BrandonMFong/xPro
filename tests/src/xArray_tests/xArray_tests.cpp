/*
 * xArray_tests.cpp
 *
 *  Created on: Sep 2, 2021
 *      Author: BrandonMFong
 */

#include "xArray_tests.hpp"

void xArrayRunTests(void)
{
	testInitializer();
}

void testInitializer(void)
{
	xAssert(false, "Test assert");
	xAssert(false, "Test assert");
	xUTResults(false, "Testing initializer");
}
