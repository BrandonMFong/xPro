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
}

void xXML_Tests(void) {

}

#endif /* SRC_XLIB_XXML_XXML_TESTS_H_ */
