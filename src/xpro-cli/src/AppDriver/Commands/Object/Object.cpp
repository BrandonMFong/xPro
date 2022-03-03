/*
 * Object.cpp
 *
 *  Created on: Mar 2, 2022
 *      Author: brandonmfong
 */

#include "Object.hpp"
#include <AppDriver/AppDriver.hpp>

xError HandleObject(void) {
	xError result = kNoError;
	AppDriver * appDriver = xNull;

	appDriver = AppDriver::shared();
	result = appDriver != xNull ? kNoError : kDriverError;

	return result;
}
