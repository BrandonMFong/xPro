/*
 * xArgs.cpp
 *
 *  Created on: Oct 23, 2021
 *      Author: brandonmfong
 */

#include "xArgs.h"

#ifdef __cplusplus
extern "C" {
#endif

#include <xUtilities/xUtilities.h>

#ifdef __cplusplus
}
#endif

/// Use this global args variable for your main
static xArguments * args = xNull;

xArguments::xArguments(int argc, char ** argv, xError * err) {
	xError error = kNoError;

	this->_arguments 	= xNull;
	this->_numArgs 		= 0;

	if (error == kNoError) {
		error = this->_saveArgs(argc, argv);
	}

	if ((error == kNoError) && (args == xNull)) {
		args = this;
	}

	if (err != xNull) {
		*err = error;
	}
}

xArguments::~xArguments() {
	if (this->_arguments != xNull) {
		for (xUInt8 i = 0; i < this->_numArgs; i++) {
			if (this->_arguments[i] != xNull) {
				free(this->_arguments[i]);
			}
		}
	}
}

xError xArguments::_saveArgs(int argc, char ** argv){
	xError result = kNoError;

	if (result == kNoError) {
		this->_arguments 	= (char **) malloc(sizeof(char *) * argc);
		result 				= this->_arguments != xNull ? kNoError : kUnknownError;
	}

	for (xUInt8 i = 0; i < argc; i++) {
		if (result == kNoError) {
			this->_arguments[i] = xCopyString(argv[i], &result);
		}

		if (result != kNoError) break;
	}

	if (result == kNoError) {
		this->_numArgs = argc; // Save count
	}

	return result;
}

xBool xArguments::contains(const char * arg, xError * err) {
	xBool result 	= xFalse;
	xError error 	= kNoError;
	char * tempArg 	= xNull;

	for (xUInt8 i = 0; i < this->_numArgs; i++) {
		if (error == kNoError) {
			tempArg = this->_arguments[i];
			error 	= tempArg != xNull ? kNoError : kArgError;
		}

		if (error == kNoError) {
			result = !strcmp(arg, tempArg);
		}

		// Move on if there was an error or if we found the arg
		if ((error != kNoError) || result) break;
	}

	return result;
}

char * xArguments::argAtIndex(xUInt8 index, xError * err) {
	char * result 	= xNull;
	xError error 	= kNoError;

	if (error == kNoError) {
		error = index < this->_numArgs ? kNoError : kOutOfRangeError;
	}

	if (error == kNoError) {
		result 	= this->_arguments[index];
		error 	= result != xNull ? kNoError : kArgError;
	}

	if (err != xNull) {
		*err = error;
	}

	return result;
}

xArguments * xArguments::shared() {
	return args;
}
