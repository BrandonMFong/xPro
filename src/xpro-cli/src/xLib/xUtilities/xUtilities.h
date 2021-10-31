/*
 * xUtilities.h
 *
 *  Created on: Oct 16, 2021
 *      Author: brandonmfong
 */

#ifndef XUTILITIES_XUTILITIES_H_
#define XUTILITIES_XUTILITIES_H_

/// xPro
#include <xError.h>
#include <xNull.h>
#include <xInt.h>
#include <xLogger/xDLog.h>
#include <xBool.h>

/// System
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#if defined(__WINDOWS__)

#define FILE_SYSTEM_SEPARATOR '\\'

#elif defined(__MACOS__) || defined(__LINUX__)

#define FILE_SYSTEM_SEPARATOR '/'

#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma mark - String

/**
 * Creates a copy of the string.
 *
 * Returns pointer to malloc string or NULL if there was a failure.
 * Must free
 */
char * xCopyString(
	const char * 	string,
	xError * 		err
);

/**
 * Returns true if string contains subString
 */
xBool xContainsSubString (
	const char * 	string,
	const char * 	subString,
	xError * 		err
);

/**
 * Returns an array of strings that contains substrings from
 * input string separated by the input separator
 */
char ** xSplitString(
	char * 		string,
	char * 		separator,
	xError * 	err
);

#pragma mark - File System

/**
 * Returns base name of path
 *
 * Must free the return string
 */
char * xBasename(const char * path, xError * err);

/**
 * Returns true if path exists as a file
 */
xBool xIsFile(const char * path);

/**
 * Returns user home directory path
 *
 * Caller is responsible for freeing memory
 */
char * xHomePath(xError * err);

/**
 * Returns file content at path
 */
char * xReadFile(const char * path, xError * err);

#pragma mark - Other

/**
 * Returns the standard config file for user
 *
 * Caller is responsible for freeing memory
 */
char * xConfigFilePath(xError * err);

#ifdef __cplusplus
}
#endif

#endif /* XUTILITIES_XUTILITIES_H_ */
