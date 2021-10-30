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
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <xInt.h>
#include <xLogger/xDLog.h>
#include <xBool.h>

/// System
#include <sys/syslimits.h>

#if defined(__WINDOWS__)

#define FILE_SYSTEM_SEPARATOR '\\'

#elif defined(__MACOS__)

#define FILE_SYSTEM_SEPARATOR '/'

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
 * Returns base name of path
 *
 * Must free the return string
 */
char * xBasename(const char * path, xError * err);

#pragma mark - File System

xBool xIsDirectory(const char * path, xError * err);

#pragma mark - Other

/**
 * Returns the standard config file for user
 *
 * Caller is responsible for freeing memory
 */
char * xConfigFilePath(xError * err);

/**
 * Returns user home directory path
 *
 * Caller is responsible for freeing memory
 */
char * xHomePath(xError * err);

#endif /* XUTILITIES_XUTILITIES_H_ */
