/*
 * Commands.h
 *
 *  Created on: Oct 30, 2021
 *      Author: BrandonMFong
 */

#ifndef SRC_COMMANDS_COMMANDS_H_
#define SRC_COMMANDS_COMMANDS_H_

#include "Create/Create.hpp"
#include "Directory/Directory.hpp"
#include "Version/Version.hpp"
#include "Object/Object.hpp"

#define HELP_ARG 	"--help"
#define VERSION_ARG "--version"

/// Directory
#define DIR_ARG "dir"

/// Create
#define CREATE_ARG 				"create"
#define CREATE_XPRO_ARG 		"home"
#define CREATE_USER_CONF_ARG 	"uconf"
#define CREATE_ENV_CONF_ARG		"uenv"

/// Object
#define OBJ_ARG "obj"

#endif /* SRC_COMMANDS_COMMANDS_H_ */
