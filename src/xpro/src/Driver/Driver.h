/*
 * Driver.h
 *
 *  Created on: Jul 24, 2021
 *      Author: BrandonMFong
 */

#ifndef DRIVER_DRIVER_H_
#define DRIVER_DRIVER_H_

#include <iostream>
#include <xLib.h>
#include <xIPC/xServer/xServer.h>

class Driver : public xPro::xObject {
public:
	/**
	 * Constructor
	 */
	Driver();

	/**
	 * Destructor
	 */
	virtual ~Driver();
private:
	xPro::xServer * _server;
};

#endif /* DRIVER_DRIVER_H_ */
