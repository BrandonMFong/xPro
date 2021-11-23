/*
 * Create.hpp
 *
 *  Created on: Nov 14, 2021
 *      Author: brandonmfong
 */

#ifndef SRC_APPDRIVER_COMMANDS_CREATE_CREATE_HPP_
#define SRC_APPDRIVER_COMMANDS_CREATE_CREATE_HPP_

#include <xLib.h>

#pragma mark - Top

/**
 * Handles the dir argument from
 *
 * This is where we create the xpro environment, i.e. create env.xml
 */
xError HandleCreate(void);

#pragma mark - Sub Commands

/**
 * Creates .xpro at home path
 */
xError CreateXProHomePath(void);

/**
 * Creates the user config file in the xPro home path
 *
 * Can accept an argument to write file to a specific location
 * but default location is the xpro home path
 */
xError CreateUserConfig(void);

/**
 * Creates the env.xml config
 */
xError CreateEnvironmentConfig(void);

#pragma mark - Utils

xError WriteToFile(const char * content, const char * filePath);

#endif /* SRC_APPDRIVER_COMMANDS_CREATE_CREATE_HPP_ */
