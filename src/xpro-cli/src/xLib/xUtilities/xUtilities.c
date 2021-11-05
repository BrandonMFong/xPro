/*
 * xUtilities.c
 *
 *  Created on: Oct 16, 2021
 *      Author: brandonmfong
 */

#include "xUtilities.h"

char * xHostname(xError * err) {
	char * result = xNull;
	xError error = kNoError;
	xUInt8 size = ~0;
	char hostname[size];

	if (gethostname(&hostname, size) == -1) {
		error = kHostnameError;
	} else {
		result = xCopyString(hostname, &error);
	}

	if (err != xNull) {
		*err = error;
	}

	return result;
}
