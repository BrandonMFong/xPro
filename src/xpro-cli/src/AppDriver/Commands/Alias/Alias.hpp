/*
 * Alias.hpp
 *
 *  Created on: Mar 15, 2022
 *      Author: brandonmfong
 */

#ifndef SRC_APPDRIVER_COMMANDS_ALIAS_ALIAS_HPP_
#define SRC_APPDRIVER_COMMANDS_ALIAS_ALIAS_HPP_

#include <xLib.h>
#include <AppDriver/Commands/Command.hpp>

class Alias : public Command {
public:
	Alias(xError * err);
	virtual ~Alias();
	virtual xError exec();
	static xBool commandInvoked();
	static void help();

protected:

	xError HandleAliasCount(void);
	xError HandleAliasIndex(void);
};

#endif /* SRC_APPDRIVER_COMMANDS_ALIAS_ALIAS_HPP_ */
