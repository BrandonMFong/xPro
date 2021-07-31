/*
 * Driver.cpp
 *
 *  Created on: Jul 24, 2021
 *      Author: BrandonMFong
 */

#include <Driver/Driver.h>

Driver::Driver() : xPro::xServer() {
	xError error = this->_status;

	this->_status = error;
}

Driver::~Driver() {

}
