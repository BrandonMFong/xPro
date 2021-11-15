/*
 * AppDriver.hpp
 *
 *  Created on: Nov 14, 2021
 *      Author: brandonmfong
 */

#ifndef SRC_APPDRIVER_APPDRIVER_HPP_
#define SRC_APPDRIVER_APPDRIVER_HPP_

#include <xLib.h>
#include <Commands/Directory/Directory.hpp>
#include <Commands/Commands.h>

/**
 * Main class for xPro CLI
 */
class AppDriver {
public:

	AppDriver(xInt8 argc, char ** argv, xError * err);

	virtual ~AppDriver();

	void help(xBool moreInfo);

	xError run();

	static AppDriver * shared();

	xArguments args;

private:

};

#endif /* SRC_APPDRIVER_APPDRIVER_HPP_ */
