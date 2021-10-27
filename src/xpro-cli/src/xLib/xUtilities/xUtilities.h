/*
 * xUtilities.h
 *
 *  Created on: Oct 16, 2021
 *      Author: brandonmfong
 */

#ifndef XUTILITIES_XUTILITIES_H_
#define XUTILITIES_XUTILITIES_H_

#include <xError.h>
#include <xNull.h>
#include <stdlib.h>
#include <string.h>
#include <xIntType.h>
#include <stdio.h>

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

#endif /* XUTILITIES_XUTILITIES_H_ */
