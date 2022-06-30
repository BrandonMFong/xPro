/*
 * Help.hpp
 *
 *  Created on: Mar 15, 2022
 *      Author: brandonmfong
 */

#ifndef SRC_APPDRIVER_COMMANDS_HELP_HELP_HPP_
#define SRC_APPDRIVER_COMMANDS_HELP_HELP_HPP_

#include "../../../Lib/xLib.h"

/**
 * Shows help
 *
 * 0: Prints brief help
 * 1: Prints help with brief descriptions on commands and app
 * 2: Prints full descripton on command
 */
xError HandleHelp(xUInt8 printType);

void PrintHeader(void);
void PrintVersionHelp(void);
void PrintDirectoryHelp(void);
void PrintCreateHelp(void);
void PrintObjectHelp(void);
void PrintDescribeHelp(void);
void PrintAliasHelp(void);
void PrintFooter(void);

#endif /* SRC_APPDRIVER_COMMANDS_HELP_HELP_HPP_ */
