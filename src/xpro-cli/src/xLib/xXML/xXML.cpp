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
		xFree(this->_path);

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

	if (elementPath == xNull) {
		error = kStringError;
	}

	if (error == kNoError) {
		result = (char **) malloc(sizeof(char *));
		error = result != xNull ? kNoError : kUnknownError;
	}

	if (error == kNoError) {
		result[0] = this->getStringInsideElementPath(this->_rawContent, elementPath, &error);
	}

	if (err != xNull) {
		*err = error;
	}

	return result;
}

char * xXML::getStringInsideElementPath(const char * content, const char * elementPath, xError * err) {
	char * result = xNull;
	xError error = kNoError;


	if (err != xNull) {
		*err = error;
	}

	return result;
}
