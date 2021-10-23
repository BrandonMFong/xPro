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

/**
 * Creates a copy of the string.
 *
 * Returns pointer to string or NULL if there was a failure
 */
char * xCopyString(
		const char * 	string,
		xError * 		err
);

#endif /* XUTILITIES_XUTILITIES_H_ */
