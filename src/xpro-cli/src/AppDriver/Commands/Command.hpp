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

	Command(xError * err);

	virtual ~Command();
	
	/**
	 * Each Command object must implement their own exec() that defines the command's 
	 * job
	 */
	virtual xError exec() = 0;

	/*
#define XPRO_HOME_ARG	"home"
	static const char * homeArg() {

	}

#define USER_CONF_ARG	"uconf"
#define ENV_CONF_ARG	"uenv"
#define COUNT_ARG 	"--count"
#define INDEX_ARG 	"-index"
#define VALUE_ARG 	"--value"
#define NAME_ARG 	"--name"
*/
};

#endif /* SRC_APPDRIVER_COMMANDS_COMMAND_HPP_ */

