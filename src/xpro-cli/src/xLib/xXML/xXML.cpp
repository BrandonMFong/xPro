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

char * xXML::getValue(
	const char * 	elementPath,
	xError * 		err
) {
	char * result = xNull;
	xError error = kNoError;

	if (elementPath == xNull) {
		error = kStringError;
	} else {
		this->_parseHelper.init();

		this->_parseHelper.tagPathArray = xSplitString(
			elementPath,
			ELEMENT_PATH_SEP,
			&this->_parseHelper.arraySize,
			&error
		);
	}

	if (error == kNoError) {
		this->_parseHelper.contentLength = strlen(this->_rawContent);
		result = this->sweepContent(&error);
	}

	if (err != xNull) {
		*err = error;
	}

	return result;
}

char * xXML::sweepContent(xError * err) {
	char * result = xNull;
	xError error = kNoError;
	char * tagString = xNull;

	while ((this->_parseHelper.contentIndex < this->_parseHelper.contentLength) && (error == kNoError)) {
		switch (this->_parseHelper.state) {
		case kIdle:
			if (this->_rawContent[this->_parseHelper.contentIndex] == '<') {
				this->_parseHelper.state = kReadingTagString;
			}
		break;

		case kReadingTagString:

			break;
		default:
			break;
		}
		this->_parseHelper.contentIndex++;
	}

	if (err != xNull) {
		*err = error;
	}

	return result;
}
