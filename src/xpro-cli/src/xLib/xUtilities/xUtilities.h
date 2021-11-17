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
#include <xBool.h>

/// System
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>
#include <dirent.h>
#include <limits.h>
#include "../xLogger/xLog.h"

/**
 * Frees memory from heap and nulls out pointer
 */
#define xFree(var) if (var != 0) {free(var); var = 0;}

/**
 * Frees memory from free store
 */
#define xDelete(var) if (var != 0) {delete var; var = 0;}

#ifdef __cplusplus
extern "C" {
#endif // __cplusplus

#pragma mark - String

/**
 * Returns malloc'd string and copies an empty string to it
 */
char * xMallocString(xUInt64 length, xError * err);

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
 *
 * @param size The size of the returned array
 */
char ** xSplitString(
	const char *	string,
	const char * 	sep,
	xUInt8 *		size,
	xError * 		err
);

/**
 * Appends a character to string
 */
xError xApendToString(
	char ** string,
	const char * stringToAppend
);

/**
 * Converts char to string
 *
 * Resulting string must be freed
 */
char * xCharToString(char ch, xError * err);

/**
 * Returns string between two strings
 */
char * xStringBetweenTwoStrings(
	const char * string,
	const char * firstString,
	const char * secondString,
	xError * err
);

#pragma mark - File System

/**
 * File system separator
 */
#if defined(__WINDOWS__)

#define FILE_SYSTEM_SEPARATOR '\\'
#define MAX_PATH_LENGTH MAX_PATH

#elif defined(__MACOS__) || defined(__LINUX__)

#define FILE_SYSTEM_SEPARATOR '/'
#define MAX_PATH_LENGTH PATH_MAX

#endif

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
 * Checks if path is a directory
 */
xBool xIsDir(const char * path);

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

/**
 * Creates directory at path.  If it already
 * exists, this function does nothing
 */
xError xMkDir(const char * path);

#pragma mark - Other

/**
 * Returns host name of system
 */
char * xHostname(xError * err);

#ifdef __cplusplus
}
#endif // __cplusplus

#endif /* XUTILITIES_XUTILITIES_H_ */
