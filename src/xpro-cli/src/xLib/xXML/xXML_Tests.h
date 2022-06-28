/*
 * xXML_Tests.h
 *
 *  Created on: Nov 9, 2021
 *      Author: brandonmfong
 */

#ifdef TESTING

#ifndef SRC_XLIB_XXML_XXML_TESTS_H_
#define SRC_XLIB_XXML_XXML_TESTS_H_

#include "xXML.hpp"

#define TEST_FILE "test.xml"

void TestNodes(void) {
	xBool success = xTrue;
	xError error = kNoError;
	xXML * xml = new xXML;
	success = xml != xNull;

	if (success) {
		xml->parseBuffer(
			"<xPro>"
				"<Directories>"
					"<Directory>"
						"docs"
					"</Directory>"
				"</Directories>"
			"</xPro>"
		);

		char * value = xml->getValue("xPro/Directories/Directory", &error);
		xFree(value);
	}

	xFree(xml);

	PRINT_TEST_RESULTS(success);
}

void xXML_Tests(void) {
	INTRO_TEST_FUNCTION;

	TestNodes();

	printf("\n");
}

#endif /* SRC_XLIB_XXML_XXML_TESTS_H_ */

#endif // TESTING
