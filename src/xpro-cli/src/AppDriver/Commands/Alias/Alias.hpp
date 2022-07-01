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
	Alias * createAlias(Array<const char *> * args, xError * err);

protected:
	Alias(Array<const char *> * args, xError * err);

	virtual ~Alias();
};

xError HandleAlias(void);
xError HandleAliasCount(void);
xError HandleAliasIndex(void);

#endif /* SRC_APPDRIVER_COMMANDS_ALIAS_ALIAS_HPP_ */
