/*
 * Directory.hpp
 *
 *  Created on: Oct 30, 2021
 *      Author: BrandonMFong
 */

#ifndef SRC_COMMANDS_DIRECTORY_DIRECTORY_HPP_
#define SRC_COMMANDS_DIRECTORY_DIRECTORY_HPP_

#include <xLib.h>

#define DIRECTORY_ELEMENT_PATH_FORMAT "/xPro/Directories/Directory.alias(%s)/Value.username(%s)"

/**
 * Handles the dir argument from
 */
xError HandleDirectory(void);

/**
 * Prints out directory for the alias
 */
xError PrintDirectoryForAlias(const char * alias);

#endif /* SRC_COMMANDS_DIRECTORY_DIRECTORY_HPP_ */
