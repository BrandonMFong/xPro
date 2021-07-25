/*
 * Driver.cpp
 *
 *  Created on: Jul 24, 2021
 *      Author: BrandonMFong
 */

#include <Driver/Driver.h>

Driver::Driver() : xPro::xObject() {
	xError error = kNoError;

	if (error == kNoError) {
		this->_server = new xPro::xServer();

		if (this->_server == NULL) {
			error = kNULLError;
		} else {
			error = this->_server->status;
		}
	}

	this->_status = error;
}

Driver::~Driver() {
	if (this->_server != NULL) {
		delete this->_server;
	}
}
