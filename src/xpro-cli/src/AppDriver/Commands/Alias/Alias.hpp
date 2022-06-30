/*
 * Alias.hpp
 *
 *  Created on: Mar 15, 2022
 *      Author: brandonmfong
 */

#ifndef SRC_APPDRIVER_COMMANDS_ALIAS_ALIAS_HPP_
#define SRC_APPDRIVER_COMMANDS_ALIAS_ALIAS_HPP_

#include <xLib.h>

/**
 * Path to list of aliases in user config
 */
#define ALIAS_TAG_PATH "xPro/Aliases/Alias"

/**
 * Path to aliases name
 */
#define ALIAS_NAME_TAG_PATH "xPro/Aliases/Alias[%s].name"

/**
 * Path to aliases Value
 */
#define ALIAS_VALUE_TAG_PATH "xPro/Aliases/Alias[%s]/Value.username(%s)"

xError HandleAlias(void);
xError HandleAliasCount(void);
xError HandleAliasIndex(void);

#endif /* SRC_APPDRIVER_COMMANDS_ALIAS_ALIAS_HPP_ */
