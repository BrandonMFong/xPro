/*
 * xXML.cpp
 *
 *  Created on: Oct 30, 2021
 *      Author: brandonmfong
 */

#include <xXML/xXML.hpp>
#include <xUtilities/xUtilities.h>

xXML::xXML(const char * path, xError * err) {
	xError error = kNoError;

	this->_path = xCopyString(path, &error);

	if (err != xNull) {
		*err = error;
	}
}

xXML::~xXML() {
	xFree(this->_path);
}

char * xXML::getValue(const char * nodePath, xError * err) {
	char * result = xNull, ** splitString = xNull;;
	xError error = kNoError;
	xUInt8 size = 0;

	splitString = xSplitString(nodePath, ELEMENT_PATH_SEP, &size, &error);

	if (err != xNull) {
		*err = error;
	}

	return result;
}
