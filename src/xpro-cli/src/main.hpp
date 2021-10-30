/*
 * Driver.hpp
 *
 *  Created on: Oct 30, 2021
 *      Author: BrandonMFong
 *
 */

#ifndef SRC_MAIN_HPP_
#define SRC_MAIN_HPP_

#include <xLib.h>
#include <Commands/Directory/Directory.hpp>
#include <Commands/Commands.h>

xError Run(void);
void Help(xBool moreInfo);

#endif /* SRC_MAIN_HPP_ */
