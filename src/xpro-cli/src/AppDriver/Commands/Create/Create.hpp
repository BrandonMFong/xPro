/*
 * Create.hpp
 *
 *  Created on: Nov 14, 2021
 *      Author: brandonmfong
 */

#ifndef SRC_APPDRIVER_COMMANDS_CREATE_CREATE_HPP_
#define SRC_APPDRIVER_COMMANDS_CREATE_CREATE_HPP_

#include <xLib.h>

/**
 * Handles the dir argument from
 *
 * This is where we create the xpro environment, i.e. create env.xml
 */
xError HandleCreate(void);

/**
 * Creates .xpro at home path
 */
xError CreateXProHomePath(void);

#endif /* SRC_APPDRIVER_COMMANDS_CREATE_CREATE_HPP_ */
