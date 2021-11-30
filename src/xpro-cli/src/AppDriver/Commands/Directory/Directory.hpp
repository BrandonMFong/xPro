/*
 * Directory.hpp
 *
 *  Created on: Oct 30, 2021
 *      Author: BrandonMFong
 */

#ifndef SRC_COMMANDS_DIRECTORY_DIRECTORY_HPP_
#define SRC_COMMANDS_DIRECTORY_DIRECTORY_HPP_

#include <xLib.h>

/**
 * Element path template
 */
#define DIRECTORY_ELEMENT_PATH_FORMAT "/xPro/Directories/Directory.alias(%s)/Value.username(%s)"

/**
 * If this is specified in the username in the above format, then the path with this attribute will take precedence
 */
#define ALL_USERS "__ALL__"

/**
 * Handles the dir argument from
 */
xError HandleDirectory(void);

/**
 * Prints out directory for the alias
 */
xError PrintDirectoryForAlias(const char * alias);

#endif /* SRC_COMMANDS_DIRECTORY_DIRECTORY_HPP_ */
