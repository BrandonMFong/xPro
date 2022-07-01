/*
 * Command.cpp
 *
 *  Created on: Jun 29, 2022
 *      Author: brandonmfong
 */

#include "Command.hpp"
#include <xLib.h>

typedef Array<const char*> Arguments;

Command * Command::createCommand(Arguments * args, xError * err) {
	Command * result = xNull;

	return result;
}

Command::Command(Arguments * args, xError * err) {

}

Command::~Command() {

}

