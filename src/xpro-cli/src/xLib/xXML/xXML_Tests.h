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

void TestParsingWithNodes(void) {
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
		success = value != xNull;
	}

	if (success) {
		success = (strcmp(value, "Adam") == 0);
	}

	if (success) {
		xFree(value);
		value = xml->getValue("/Person", &error);
		success = error == kNoError;
	}

	if (success) {
		success = value != xNull;
	}

	if (success) {
		success = (strcmp(value, "<Name>Adam</Name>") == 0);
	}

	PRINT_TEST_RESULTS(success);
}

void TestParsingForAttribute(void) {
	const char * content = "<Persons><Person isCousin=\"true\"><Name>Adam</Name></Person></Persons>";
	xError error = kNoError;
	xXML * xml = new xXML(&error);

	if (error == kNoError) {
		error = xml->setContent(content);
	}

	char * value = xNull;
	if (error == kNoError) {
		value = xml->getValue("/Persons/Person.isCousin", &error);
	}

	xBool success = error == kNoError;

	if (success) {
		success = value != xNull;
	}

	if (success) {
		success = (strcmp(value, "true") == 0);
	}

	if (success) {
		xFree(value);
		value = xml->getValue("/Persons/Person.isCousin(true)", &error);
		success = error == kNoError;
	}

	if (success) {
		success = value != xNull;
	}

	if (success) {
		success = (strcmp(value, "<Name>Adam</Name>") == 0);
	}

	PRINT_TEST_RESULTS(success);
}

void TestGettingInnerXmlForSpecificAttribute(void) {
	const char * content =
		"<Persons>"
			"<Person isCousin=\"true\">"
				"<Name>Adam</Name>"
			"</Person>"
			"Person isCousin=\"false\""
				"<Name>Joe</Name>"
			"</Person>"
		"</Persons>";

	xError error = kNoError;
	xXML * xml = new xXML(&error);

	if (error == kNoError) {
		error = xml->setContent(content);
	}

	char * value = xNull;
	if (error == kNoError) {
		value = xml->getValue("/Persons/Person.isCousin(false)", &error);
	}

	xBool success = error == kNoError;

	if (success) {
		success = value != xNull;

		if (!success) {
			printf("getValue() returned null\n");
		}
	} else {
		printf("Error in getting value for '/Persons/Person.isCousin(false)', %d\n", error);
	}

	if (success) {
		success = (strcmp(value, "<Name>Joe</Name>") == 0);
	}

	if (success) {
		xFree(value);
		value = xml->getValue("/Persons/Person.isCousin(true)", &error);
		success = error == kNoError;
	}

	if (success) {
		success = value != xNull;
	}

	if (success) {
		success = (strcmp(value, "<Name>Adam</Name>") == 0);
	}

	PRINT_TEST_RESULTS(success);
}

void xXML_Tests(void) {
	INTRO_TEST_FUNCTION;

	TestParsingWithNodes();
	TestParsingForAttribute();
	TestGettingInnerXmlForSpecificAttribute();

	printf("\n");
}

#endif /* SRC_XLIB_XXML_XXML_TESTS_H_ */

#endif // TESTING
