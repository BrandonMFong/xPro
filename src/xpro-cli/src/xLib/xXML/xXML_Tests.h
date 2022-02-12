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

/**
 * Free result string
 */
char * SetTestFile(const char * content, xError * err) {
	char * result = xNull;
	xError error = kNoError;
	FILE * fp = xNull;

	result = xMallocString(strlen(testPath) + strlen(TEST_FILE) + 1, &error);

	if (error == kNoError) {
		sprintf(result, "%s/%s", testPath, TEST_FILE);

		fp = fopen(result, "w");
		error = fp != xNull ? kNoError : kFileError;
	}

	if (error == kNoError) {
		fprintf(fp, "%s", content); // Set content
		fclose(fp);
	}

	return result;
}

void TestParsingWithUnknownAttribute(void) {
	const char * content = "<Person><Name>Adam</Name></Person>";
	xError error = kNoError;
	xXML * xml = xNull;
	char * file = xNull;

	if (error == kNoError) {
		file = SetTestFile(content, &error);
	}

	if (error == kNoError) {
		xml = new xXML(file, &error);
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

	if (remove(file)) {
		printf("Could not delete file %s", file);
	}

	PRINT_TEST_RESULTS(success);
	xDelete(xml);
}

void TestParsingWithNodes(void) {
	const char * content = "<Person><Name>Adam</Name></Person>";
	xError error = kNoError;
	xXML * xml = xNull;
	char * file = xNull;

	if (error == kNoError) {
		file = SetTestFile(content, &error);
	}

	if (error == kNoError) {
		xml = new xXML(file, &error);
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

	if (remove(file)) {
		printf("Could not delete file %s", file);
	}

	PRINT_TEST_RESULTS(success);
	xDelete(xml);
}

void TestParsingForAttribute(void) {
	const char * content = "<Persons><Person isCousin=\"true\"><Name>Adam</Name></Person></Persons>";
	xError error = kNoError;
	xXML * xml = xNull;
	char * file = xNull;

	if (error == kNoError) {
		file = SetTestFile(content, &error);
	}

	if (error == kNoError) {
		xml = new xXML(file, &error);
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

	if (remove(file)) {
		printf("Could not delete file %s", file);
	}

	PRINT_TEST_RESULTS(success);
	xDelete(xml);
}

void TestGettingInnerXmlForSpecificAttribute(void) {
	const char * content =
		"<Persons>"
			"<Person isCousin=\"true\">"
				"<Name>Adam</Name>"
			"</Person>"
			"<Person isCousin=\"false\">"
				"<Name>Joe</Name>"
			"</Person>"
		"</Persons>";

	xError error = kNoError;
	xXML * xml = xNull;
	char * file = xNull;

	if (error == kNoError) {
		file = SetTestFile(content, &error);
	}

	if (error == kNoError) {
		xml = new xXML(file, &error);
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

		if (!success) {
			printf("%s != '<Name>Joe</Name>'\n", value);
		}
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

	if (remove(file)) {
		printf("Could not delete file %s", file);
	}

	PRINT_TEST_RESULTS(success);
	xDelete(xml);
}

void TestGettingValueForSpecificAttribute(void) {
	const char * content =
		"<Persons family=\"Geronimo\">"
			"<Person isCousin=\"true\">"
				"<Name>Adam</Name>"
			"</Person>"
			"<Person isCousin=\"false\">"
				"<Name>Joe</Name>"
			"</Person>"
		"</Persons>";

	xError error = kNoError;
	xXML * xml = xNull;
	char * file = xNull;

	if (error == kNoError) {
		file = SetTestFile(content, &error);
	}

	if (error == kNoError) {
		xml = new xXML(file, &error);
	}

	char * value = xNull;
	if (error == kNoError) {
		value = xml->getValue("/Persons.family(Geronimo)/Person.isCousin(false)/Name", &error);
	}

	xBool success = error == kNoError;

	if (success) {
		success = value != xNull;

		if (!success) {
			printf("getValue() returned null\n");
		}
	} else {
		printf("Error in getting value for '/Persons.family(Geronimo)/Person.isCousin(false)', %d\n", error);
	}

	if (success) {
		success = (strcmp(value, "Joe") == 0);

		if (!success) {
			printf("%s != 'Joe'\n", value);
		}
	}

	if (success) {
		xFree(value);
		value = xml->getValue("/Persons.family(Geronimo)/Person.isCousin(true)/Name", &error);
		success = error == kNoError;
	}

	if (success) {
		success = value != xNull;

		if (!success) {
			printf("getValue() returned null\n");
		}
	}

	if (success) {
		success = (strcmp(value, "Adam") == 0);

		if (!success) {
			printf("%s != 'Adam'\n", value);
		}
	}

	if (remove(file)) {
		printf("Could not delete file %s", file);
	}

	PRINT_TEST_RESULTS(success);
	xDelete(xml);
}

void TestParsingWithFilePath(void) {
	const char * content =
		"<xPro>\n"
			"<Users>\n"
				"<User active=\"true\">\n"
					"<ConfigPath>/Users/brandonmfong/.xpro/user.xml</ConfigPath>\n"
				"</User>\n"
			"</Users>\n"
		"</xPro>\n";

	xError error = kNoError;
	xXML * xml = xNull;
	char * file = xNull;

	if (error == kNoError) {
		file = SetTestFile(content, &error);
	}

	if (error == kNoError) {
		xml = new xXML(file, &error);
	}

	char * value = xNull;
	if (error == kNoError) {
		value = xml->getValue("/xPro/Users/User.active(true)/ConfigPath", &error);
	}

	xBool success = error == kNoError;

	if (success) {
		success = value != xNull;

		if (!success) {
			printf("getValue() returned null\n");
		}
	} else {
		printf("Error in getting value for '/xPro/Users/User.active(true)/ConfigPath', %d\n", error);
	}

	if (success) {
		success = (strcmp(value, "/Users/brandonmfong/.xpro/user.xml") == 0);

		if (!success) {
			printf("%s != '/Users/brandonmfong/.xpro/user.xml'\n", value);
		}
	}

	if (remove(file)) {
		printf("Could not delete file %s", file);
	}

	PRINT_TEST_RESULTS(success);
	xDelete(xml);
}

void TestGettingSiblingNode(void) {
	const char * content =
		"<xPro>"
			"<One>1</One>"
			"<Two>2</Two>"
		"</xPro>";

	xError error = kNoError;
	xXML * xml = xNull;
	char * file = xNull;

	if (error == kNoError) {
		file = SetTestFile(content, &error);
	}

	if (error == kNoError) {
		xml = new xXML(file, &error);
	}

	char * value = xNull;
	if (error == kNoError) {
		value = xml->getValue("/xPro/Two", &error);
	}

	xBool success = error == kNoError;

	if (success) {
		success = value != xNull;

		if (!success) {
			printf("getValue() returned null\n");
		}
	} else {
		printf("Error in getting value for '/xPro/Two', %d\n", error);
	}

	if (success) {
		success = (strcmp(value, "2") == 0);

		if (!success) {
			printf("%s != '2'\n", value);
		}
	}

	if (remove(file)) {
		printf("Could not delete file %s", file);
	}

	PRINT_TEST_RESULTS(success);
	xDelete(xml);
}

void TestIgnoringComments(void) {
	const char * content =
		"<xPro>"
			"<One>1</One>"
			"<!-- <Two>3</Two> -->"
			"<Two>2</Two>"
		"</xPro>";

	xError error = kNoError;
	xXML * xml = xNull;
	char * file = xNull;

	if (error == kNoError) {
		file = SetTestFile(content, &error);
	}

	if (error == kNoError) {
		xml = new xXML(file, &error);
	}

	xBool success = error == kNoError;
	char * value = xNull;
	if (error == kNoError) {
		value = xml->getValue("/xPro/Two", &error);
	}

	if (success) {
		success = value != xNull;

		if (!success) {
			printf("getValue() returned null\n");
		}
	} else {
		printf("Error in getting value for '/xPro/Two', %d\n", error);
	}

	if (success) {
		success = (strcmp(value, "2") == 0);

		if (!success) {
			printf("%s != '2'\n", value);
		}
	}

	if (remove(file)) {
		printf("Could not delete file %s", file);
	}

	PRINT_TEST_RESULTS(success);
	xDelete(xml);
}

void TestMakeSureNoErrorWithUnresolvedTagPath(void) {
	const char * content =
		"<xPro>"
			"<One>1</One>"
			"<!-- <Two>3</Two> -->"
			"<Two attr=\"yup\">2</Two>"
		"</xPro>";

	xError error = kNoError;
	xBool success = xTrue;
	xXML * xml = xNull;
	char * file = xNull;

	if (error == kNoError) {
		file = SetTestFile(content, &error);
	}

	if (error == kNoError) {
		xml = new xXML(file, &error);
	}

	char * value = xNull;
	if (success) {
		value 	= xml->getValue("/xPro/Two.(__ALL__)", &error);
		success = error == kNoError;

		if (!success) {
			printf("Error %d", error);
		}
	}

	if (success) {
		success = value == xNull;

		if (!success) {
			printf("Value not null");
		}
	}

	if (remove(file)) {
		printf("Could not delete file %s", file);
	}

	PRINT_TEST_RESULTS(success);
	xDelete(xml);
}

void TestCount(void) {
	xBool success = xTrue;
	const char * content =
		"<xPro>"
			"<One>1</One>"
			"<Two>5</Two>"
			"<Two>3</Two>"
			"<Two>2</Two>"
		"</xPro>";

	xError error = kNoError;
	xXML * xml = xNull;
	char * file = xNull;

	if (error == kNoError) {
		file = SetTestFile(content, &error);
	}

	if (error == kNoError) {
		xml = new xXML(file, &error);
	}

	if (error == kNoError) {
		xInt32 count = xml->countTags("/xPro/Two", &error);
		success = count == 3;
	}

	if (remove(file)) {
		printf("Could not delete file %s", file);
	}

	PRINT_TEST_RESULTS(success);
	xDelete(xml);
}

void TestCountForInterchangingNodes(void) {
	xBool success = xTrue;
	const char * content =
		"<xPro>"
			"<Function>"
				"<One>1</One>"
				"<Two>5</Two>"
				"<Three>8</Three>"
				"<Two>3</Two>"
				"<Two>2</Two>"
			"</Function>"
		"</xPro>";

	xError error = kNoError;
	xXML * xml = xNull;
	char * file = xNull;

	if (error == kNoError) {
		file = SetTestFile(content, &error);
	}

	if (error == kNoError) {
		xml = new xXML(file, &error);
	}

	if (error == kNoError) {
		xInt32 count = xml->countTags("/xPro/Function/Two", &error);
		success = count == 3;
	}

	if (remove(file)) {
		printf("Could not delete file %s", file);
	}

	PRINT_TEST_RESULTS(success);
	xDelete(xml);
}

void TestCountWithNodesHavingAttributes(void) {
	xBool success = xTrue;
	const char * content =
		"<xPro>"
			"<Function>"
				"<One attr=\"true\">1</One>"
				"<Two attr=\"true\">5</Two>"
				"<Three attr=\"true\">8</Three>"
				"<Two attr=\"true\">3</Two>"
				"<Two attr=\"true\">2</Two>"
			"</Function>"
		"</xPro>";

	xError error = kNoError;
	xXML * xml = xNull;
	char * file = xNull;

	if (error == kNoError) {
		file = SetTestFile(content, &error);
	}

	if (error == kNoError) {
		xml = new xXML(file, &error);
	}

	if (error == kNoError) {
		xInt32 count = xml->countTags("/xPro/Function/Two", &error);
		if (count != 3) {
			printf("Count is %d\n", count);
			success = xFalse;
		}
	}

	if (remove(file)) {
		printf("Could not delete file %s", file);
	}

	PRINT_TEST_RESULTS(success);
	xDelete(xml);
}

void TestIndexingASetOfSimilarPaths(void) {
	xBool success = xTrue;
	const char * content =
		"<xPro>"
			"<Function>"
				"<Path>One</Path>"
				"<Path>Two</Path>"
				"<Path>Three</Path>"
			"</Function>"
		"</xPro>";

	xError error = kNoError;
	xXML * xml = xNull;
	char * file = xNull;

	if (error == kNoError) {
		file = SetTestFile(content, &error);
	}

	if (error == kNoError) {
		xml = new xXML(file, &error);
	}

	if (error == kNoError) {
		xInt32 count = xml->countTags("/xPro/Function/Path", &error);
		if (count != 3) {
			printf("Count is %d\n", count);
			success = xFalse;
		}
	}

	char * value = xNull;
	if (success) {
		value 	= xml->getValue("/xPro/Function/Path[0]", &error);
		success = error == kNoError;

		if (!success) {
			printf("Error %d\n", error);
		}
	}

	if (success) {
		if (strcmp(value, "One")) {
			printf("Incorrect inner xml, %s\n", value);
		}
	}

	if (success) {
		value 	= xml->getValue("/xPro/Function/Path[1]", &error);
		success = error == kNoError;

		if (!success) {
			printf("Error %d\n", error);
		}
	}

	if (success) {
		if (strcmp(value, "Two")) {
			printf("Incorrect inner xml, %s\n", value);
		}
	}

	if (success) {
		value 	= xml->getValue("/xPro/Function/Path[2]", &error);
		success = error == kNoError;

		if (!success) {
			printf("Error %d\n", error);
		}
	}

	if (success) {
		if (strcmp(value, "Three")) {
			printf("Incorrect inner xml, %s\n", value);
		}
	}

	if (remove(file)) {
		printf("Could not delete file %s", file);
	}

	PRINT_TEST_RESULTS(success);
	xDelete(xml);
}

void TestStrippingIndexedTag() {
	xBool success = xTrue;
	xError error = kNoError;
	char * tag = xNull;
	xUInt8 index = 0;

	xXML * xml = new xXML(&error);
	success = xml != xNull;

	if (success) {
		success = error == kNoError;

		if (!success) {
			DLog("Error in xml constructor %d", error);
		}
	}

	if (success) {
		error = xml->stripIndexLeafTagPath("path[1]", &tag, &index);

		if (error != kNoError) {
			DLog("Error stripping: %d", error);
			success = xFalse;
		} else if (strcmp(tag, "path")) {
			success = xFalse;
			DLog("tag is not expected value: 'path'");
		} else if (index != 1) {
			success = xFalse;
			DLog("index should be 1");
		}
	}

	PRINT_TEST_RESULTS(success);
}

void xXML_Tests(void) {
	INTRO_TEST_FUNCTION;

	TestParsingWithUnknownAttribute();
	TestParsingWithNodes();
	TestParsingForAttribute();
	TestGettingInnerXmlForSpecificAttribute();
	TestGettingValueForSpecificAttribute();
	TestParsingWithFilePath();
	TestGettingSiblingNode();
	TestIgnoringComments();
	TestMakeSureNoErrorWithUnresolvedTagPath();
	TestCount();
	TestCountForInterchangingNodes();
	TestCountWithNodesHavingAttributes();
	TestIndexingASetOfSimilarPaths();
	TestStrippingIndexedTag();

	printf("\n");
}

#endif /* SRC_XLIB_XXML_XXML_TESTS_H_ */

#endif // TESTING
