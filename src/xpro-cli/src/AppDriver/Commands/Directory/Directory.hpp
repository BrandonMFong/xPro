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

/**
 * Element path template
 */
#define DIRECTORY_ELEMENT_PATH_FORMAT "xPro/Directories/Directory.key(%s)/Value.username(%s)"

class Directory : public Command {
public:
	Directory(xError * err);
	virtual ~Directory();
	xError exec();
	static xBool commandInvoked();
	static void help();

protected:

	/**
	 * Prints out directory for the alias
	 */
	xError PrintDirectoryForKey(const char * key);
};

#endif /* SRC_COMMANDS_DIRECTORY_DIRECTORY_HPP_ */
