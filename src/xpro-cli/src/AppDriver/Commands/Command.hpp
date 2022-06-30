/*
 * Command.h
 *
 *  Created on: Jun 29, 2022
 *      Author: brandonmfong
 */

#ifndef SRC_APPDRIVER_COMMANDS_COMMAND_HPP_
#define SRC_APPDRIVER_COMMANDS_COMMAND_HPP_

class Command {
public:
	static Command createCommand();
	Command();
	virtual ~Command();
};

#endif /* SRC_APPDRIVER_COMMANDS_COMMAND_HPP_ */
