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
 * If TESTING is defined, we need to have the entry point be the tests
 */
#if defined(TESTING)

#define xMain 	xMain
#define xTests 	main

#else

#define xMain 	main
#define xTests 	xTests

#endif

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
