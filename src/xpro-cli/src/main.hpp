/*
 * Driver.hpp
 *
 *  Created on: Oct 30, 2021
 *      Author: BrandonMFong
 */

#ifndef SRC_MAIN_HPP_
#define SRC_MAIN_HPP_

#include <xLib.h>
#include <Commands/Directory/Directory.hpp>

#define HELP_ARG "--help"
#define DIR_ARG "dir"
#define VERSION_ARG "--version"

xError Run(void);
void Help(xBool moreInfo);

#endif /* SRC_MAIN_HPP_ */
