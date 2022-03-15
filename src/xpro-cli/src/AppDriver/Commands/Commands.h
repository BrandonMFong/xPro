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

#pragma mark - Common Variables

#define XPRO_HOME_ARG 			"home"
#define CREATE_USER_CONF_ARG 	"uconf"
#define CREATE_ENV_CONF_ARG		"uenv"

#pragma mark - Version

#define VERSION_ARG "--version"

#pragma mark - Help

#define HELP_ARG 					"--help"
#define DESCRIBE_COMMAND_HELP_ARG 	"help"

#pragma mark - Directory

#define DIR_ARG "dir"

#define DIR_ARG_BRIEF "Returns directory path for key"
#define DIR_ARG_DISCUSSION \
	"\tIf key could not be found, no directory path will be\n"\
	"\treturned. If no key was passed, an error will be returned"

#define DIR_ARG_INFO "A valid key used in user's config file"

#pragma mark - Create

#define CREATE_ARG "create"

#define CREATE_ARG_BRIEF "Creates based arguments"
#define CREATE_ARG_DISCUSSION \
	"\tHelps user create their xpro environment"

#define CREATE_XPRO_ARG_INFO "Creates .xpro at home path"
#define CREATE_USER_CONF_ARG_INFO "Creates the 'user.xml' user config file with a basic template"
#define CREATE_ENV_CONF_ARG_INFO "Creates the %s environment config file"

#pragma mark - Object

#define OBJ_ARG 		"obj"
#define OBJ_COUNT_ARG 	"--count"
#define OBJ_INDEX_ARG 	"-index"
#define OBJ_VALUE_ARG 	"--value"
#define OBJ_NAME_ARG 	"--name"

#define OBJ_ARG_BRIEF "Returns object"
#define OBJ_ARG_DISCUSSION \
	"\tReturns object name or object value"

#define OBJ_COUNT_ARG_INFO "Returns count of objects in user's config"
#define OBJ_INDEX_ARG_INFO "Indexes the list of arguments in user config"
#define OBJ_VALUE_ARG_INFO "Returns value at index"
#define OBJ_NAME_ARG_INFO "Returns name at index"

#pragma mark - Describe

#define DESCRIBE_ARG "describe"

#endif /* SRC_COMMANDS_COMMANDS_H_ */
