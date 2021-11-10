/*
 * xXML_Tests.h
 *
 *  Created on: Nov 9, 2021
 *      Author: brandonmfong
 */

#ifndef SRC_XLIB_XXML_XXML_TESTS_H_
#define SRC_XLIB_XXML_XXML_TESTS_H_

#include "xXML.hpp"

void TestParsing(void) {
	const char * content = "<Person><Name>Adam</Name></Person>";
	xError error = kNoError;
	xXML * xml = new xXML(&error);

	if (error == kNoError) {
		error = xml->setContent(content);
	}

	char * value = xNull;
	if (error == kNoError) {
		value = xml->getValue("/Person/Name", &error);
	}

	xBool success = error == kNoError;

	if (success) {
		success = (strcmp(value, "Adam") == 0);
	}

	PRINT_TEST_RESULTS(success);
}

void xXML_Tests(void) {
	TestParsing();
}

#endif /* SRC_XLIB_XXML_XXML_TESTS_H_ */
