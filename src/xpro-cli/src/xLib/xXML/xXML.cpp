/*
 * xXML.cpp
 *
 *  Created on: Oct 30, 2021
 *      Author: brandonmfong
 */

#include <xXML/xXML.hpp>

xXML::xXML(const char * path, xError * err) {
	xError error = kNoError;

	this->_path 		= xNull;
	this->_rawContent	= xNull;

	// Read contents of file into rawContent
	if (path != xNull) {
		error = this->read(path);
	}

	if (err != xNull) {
		*err = error;
	}
}

xXML::~xXML() {
	xFree(this->_path);
	xFree(this->_rawContent);
}

xError xXML::read(const char * path) {
	xError result = kNoError;

	// Erase old content
	xFree(this->_rawContent);

	// Read file content at path
	this->_rawContent = xReadFile(path, &result);

	// Save the path
	if (result == kNoError) {
		// Free memory if path was already set
		if (this->_path != xNull) {
			free(this->_path);
		}

		this->_path = xCopyString(path, &result);
	}

	return result;
}

char ** xXML::getValue(
	const char * 	elementPath,
	xUInt8 * 		size,
	xError * 		err
) {
	char ** result = xNull;
	xError error = kNoError;
	char ** elementPathArray = xNull;
	xUInt8 elementArraySize = 0;
	char * element = xNull;
	xUInt8 elementIndex = 0;

	if (elementPath == xNull) {
		error = kStringError;
	} else {
		elementPathArray = xSplitString(
			elementPath,
			ELEMENT_PATH_SEP,
			&elementArraySize,
			&error
		);
	}

	if (error == kNoError) {
		result = (char **) malloc(sizeof(char *));
		error = result != xNull ? kNoError : kUnknownError;
	}

	while ((error == kNoError) && (elementIndex < elementArraySize)) {
		element = elementPathArray[elementIndex];
		error = element != xNull ? kNoError : kXMLError;

		if (error == kNoError) {

		} else {
			DLog("Null element at index %d\n", elementIndex);
		}

		elementIndex++;
	}

	// Free the split string array
	if (elementPathArray != xNull) {
		for (xUInt8 i = 0; i < elementArraySize; i++) {
			xFree(elementPathArray[i]);
		}
		xFree(elementPathArray);
	}

	if (err != xNull) {
		*err = error;
	}

	return result;
}
