/*
 * Directory.hpp
 *
 *  Created on: Oct 30, 2021
 *      Author: BrandonMFong
 */

#ifndef SRC_COMMANDS_DIRECTORY_DIRECTORY_HPP_
#define SRC_COMMANDS_DIRECTORY_DIRECTORY_HPP_

#include <xLib.h>
#include <AppDriver/Commands/Command.hpp>

class Directory : public Command {
public:
	Directory(xError * err);
	virtual ~Directory();
	xError exec();
	static xBool commandInvoked();
	static void help();
	static const char * brief();
	static const char * command();

protected:

	/**
	 * Prints out directory for the alias
	 */
	xError PrintDirectoryForKey(const char * key);
};

#endif /* SRC_COMMANDS_DIRECTORY_DIRECTORY_HPP_ */
