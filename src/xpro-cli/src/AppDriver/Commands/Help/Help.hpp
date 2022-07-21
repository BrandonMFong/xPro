/*
 * Help.hpp
 *
 *  Created on: Mar 15, 2022
 *      Author: brandonmfong
 */

#ifndef SRC_APPDRIVER_COMMANDS_HELP_HELP_HPP_
#define SRC_APPDRIVER_COMMANDS_HELP_HELP_HPP_

#include <xLib.h>
#include <AppDriver/Commands/Command.hpp>

class Help : public Command {
public:
	Help(xError * err);
	virtual ~Help();
	xError exec();
	static xBool invoked();
	static const char * command();

protected:
	/**
	 * Shows help
	 *
	 * 0: Prints brief help
	 * 1: Prints help with brief descriptions on commands and app
	 * 2: Prints full descripton on command
	 */
	xError HandleHelp(xUInt8 printType);

	void PrintHeader(void);
	void PrintFooter(void);
};


#endif /* SRC_APPDRIVER_COMMANDS_HELP_HELP_HPP_ */
