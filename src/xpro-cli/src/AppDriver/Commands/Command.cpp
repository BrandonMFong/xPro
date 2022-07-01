/*
 * Command.cpp
 *
 *  Created on: Jun 29, 2022
 *      Author: brandonmfong
 */

#include "Command.hpp"
#include <xLib.h>
#include <AppDriver/AppDriver.hpp>

Command * Command::createCommand(xError * err) {
	Command * result = xNull;
	AppDriver * appDriver = AppDriver::shared();

	return result;
}

Command::Command(xError * err) {

}

Command::~Command() {

}

xError Command::exec() {
	xError result = kNoError;

	return result;
}

