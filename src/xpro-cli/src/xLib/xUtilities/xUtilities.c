/*
 * xUtilities.c
 *
 *  Created on: Oct 16, 2021
 *      Author: brandonmfong
 */

#include "xUtilities.h"

char * xHostname(xError * err) {
	char * 	result 	= xNull;
	xError 	error 	= kNoError;
	xUInt8 	size 	= ~0;
	char 	hostname[size];

	if (gethostname(&hostname[0], size) == -1) {
		error = kHostnameError;
		DLog("Could not get host name");
	} else {
		result = xCopyString(hostname, &error);
	}

	if (err != xNull) {
		*err = error;
	}

	return result;
}
