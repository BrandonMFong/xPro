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
#include "Describe/Describe.hpp"
#include "Help/Help.hpp"
#include "Alias/Alias.hpp"

#pragma mark - Common Variables

//#define XPRO_HOME_ARG	"home"
//#define USER_CONF_ARG	"uconf"
//#define ENV_CONF_ARG	"uenv"
#define COUNT_ARG 	"--count"
#define INDEX_ARG 	"-index"
#define VALUE_ARG 	"--value"
#define NAME_ARG 	"--name"

#pragma mark - Version

#define VERSION_ARG "version"
#define LONG_ARG "--long"
#define SHORT_ARG "--short"

#define VERSION_ARG_BRIEF "Displays app version"
#define VERSION_ARG_DISCUSSION "Displays version with or without build hash"
#define LONG_ARG_INFO "Displays version with full build hash"
#define SHORT_ARG_INFO "Displays veresion with short build hash"

#pragma mark - Help

#define HELP_ARG 					"--help"
#define DESCRIBE_COMMAND_HELP_ARG 	"help"

#endif /* SRC_COMMANDS_COMMANDS_H_ */
