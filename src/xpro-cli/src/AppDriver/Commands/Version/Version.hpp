/*
 * Version.hpp
 *
 *  Created on: Nov 29, 2021
 *      Author: brandonmfong
 */

#ifndef SRC_APPDRIVER_COMMANDS_VERSION_VERSION_HPP_
#define SRC_APPDRIVER_COMMANDS_VERSION_VERSION_HPP_

#include <xLib.h>
#include <AppDriver/Commands/Command.hpp>

class Version : public Command {
public:
	Version(xError * err);
	virtual ~Version();
	static xBool commandInvoked();
	static void help();

	/**
	 * Prints VERSION macro.  This macro should hold the version string
	 */
	xError exec();
};

#endif /* SRC_APPDRIVER_COMMANDS_VERSION_VERSION_HPP_ */
