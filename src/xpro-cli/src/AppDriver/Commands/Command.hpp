/*
 * Command.h
 *
 *  Created on: Jun 29, 2022
 *      Author: brandonmfong
 */

#ifndef SRC_APPDRIVER_COMMANDS_COMMAND_HPP_
#define SRC_APPDRIVER_COMMANDS_COMMAND_HPP_

#include <xError.h>
#include <Array.hpp>

class Command {
public:
	/**
	 * Creates a command object with the help of the shared AppDriver instance
	 *
	 * Should be able to determine what sub class we should be calling
	 */
	static Command * createCommand(xError * err);

	xError exec();

protected:

	Command(xError * err);

	virtual ~Command();
};

#endif /* SRC_APPDRIVER_COMMANDS_COMMAND_HPP_ */

