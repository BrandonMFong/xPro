/*
 * xArray_tests.cpp
 *
 *  Created on: Sep 2, 2021
 *      Author: BrandonMFong
 */

#include <xLinkedList_tests/xLinkedList_tests.hpp>

void xArrayRunTests(void) {
	testInitializer();
}

void testInitializer(void) {
	xLinkedList * array = new xLinkedList();
	xAssertNotNull(array, "Array object is null");

	xError error = array->addObject(xNull);
	xAssert(error != kNoError, "Error in handling null object");

	int x = 4, y = 3, z = 56;

	error = array->addObject(&x);
	xAssert(error == kNoError, "Cannot add %d", x);

	error = array->addObject(&y);
	xAssert(error == kNoError, "Cannot add %d", y);

	error = array->addObject(&z);
	xAssert(error == kNoError, "Cannot add %d", z);

	xUTResults("Testing initializer");
}
