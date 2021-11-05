/*
 * Driver.hpp
 *
 *  Created on: Oct 30, 2021
 *      Author: BrandonMFong
 *
 */

#ifndef SRC_XPRO_CLI_H_
#define SRC_XPRO_CLI_H_

#include <xLib.h>
#include <Commands/Directory/Directory.hpp>
#include <Commands/Commands.h>

/**
 * Reads arguments for the command calls the respective function that
 * handles said command
 */
xError Run(void);

/**
 * Shows help
 */
void Help(xBool moreInfo);

#endif /* SRC_XPRO_CLI_H_ */
