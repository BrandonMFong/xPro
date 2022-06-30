/*
 * Command.h
 *
 *  Created on: Jun 29, 2022
 *      Author: brandonmfong
 */

#ifndef SRC_APPDRIVER_COMMANDS_COMMAND_HPP_
#define SRC_APPDRIVER_COMMANDS_COMMAND_HPP_

#include <xError.h>

class Arguments;

class Command {
public:
	static Command * createCommand(Arguments * args, xError * err);

	Command(Arguments * args, xError * err);

	virtual ~Command();
};

#endif /* SRC_APPDRIVER_COMMANDS_COMMAND_HPP_ */
