/*
 * xXML.cpp
 *
 *  Created on: Oct 30, 2021
 *      Author: brandonmfong
 */

#include <xXML/xXML.hpp>
#include <xUtilities/xUtilities.h>
#include <fstream>
#include <sstream>

xXML::xXML(const char * path, xError * err) {
	xError error = kNoError;

	this->_path = xCopyString(path, &error);

	if (error == kNoError) {
		this->_xmlStream = new std::ifstream(this->_path);
		error = this->_xmlStream != xNull ? kNoError : kFileError;
	}

	if (err != xNull) {
		*err = error;
	}
}

xXML::~xXML() {
	xFree(this->_path);

	this->_xmlStream->close();
	xDelete(this->_xmlStream);
}

char * xXML::getValue(const char * nodePath, xError * err) {
	char * result = xNull, ** splitString = xNull;;
	xError error = kNoError;
	xUInt8 size = 0;

	splitString = xSplitString(nodePath, ELEMENT_PATH_SEP, &size, &error);

	if (error == kNoError) {
		std::stringstream buffer;
		buffer << this->_xmlStream->rdbuf();
		std::string content = buffer.str();
		this->_xmldoc.parse<0>(&content[0]);

		xUInt8 i = 0;
		while ((i < size) & (error == kNoError)) {


			i++;
		}
	}

	if (err != xNull) {
		*err = error;
	}

	return result;
}
