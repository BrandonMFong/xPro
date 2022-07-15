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

#define XPRO_HOME_ARG	"home"
#define USER_CONF_ARG	"uconf"
#define ENV_CONF_ARG	"uenv"
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

#pragma mark - Directory

#define DIR_ARG "dir"

#define DIR_ARG_BRIEF "Returns directory path for key"
#define DIR_ARG_DISCUSSION \
	"  If key could not be found, no directory path will be\n"\
	"  returned. If no key was passed, an error will be returned"

#define DIR_ARG_INFO "A valid key used in user's config file"

#pragma mark - Object

#define OBJ_ARG "obj"

#define OBJ_ARG_BRIEF "Returns object"
#define OBJ_ARG_DISCUSSION \
	"Returns object name or object value"

#define OBJ_COUNT_ARG_INFO "Returns count of objects in user's config"
#define OBJ_INDEX_ARG_INFO "Indexes the list of arguments in user config"
#define OBJ_VALUE_ARG_INFO "Returns value at index"
#define OBJ_NAME_ARG_INFO "Returns name at index"

#pragma mark - Describe

#define DESCRIBE_ARG "describe"
#define DESCRIBE_ARG_BRIEF "Returns xpro information"
#define DESCRIBE_ARG_DISCUSSION "Helps user to query environment xpro information"
#define DESCRIBE_XPRO_ARG_INFO "Path to .xpro where all xPro sources live"
#define DESCRIBE_USER_CONF_ARG_INFO "Path to active user config"
#define DESCRIBE_ENV_CONF_ARG_INFO "Path to env.xml"

#endif /* SRC_COMMANDS_COMMANDS_H_ */
