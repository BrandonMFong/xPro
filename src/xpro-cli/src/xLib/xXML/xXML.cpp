/*
 * xXML.cpp
 *
 *  Created on: Oct 30, 2021
 *      Author: brandonmfong
 */

#include "xXML.h"

xXML::xXML(const char * path, xError * err) {
	xError error = kNoError;

	this->_path = xNull;

	if (error == kNoError) {

	}

	if (error == kNoError) {
		this->_path = xCopyString(path, &error);
	}

	if (err != xNull) {
		*err = error;
	}
}

xXML::~xXML() {
	if (this->_path != xNull) {
		free(this->_path);
	}
}

