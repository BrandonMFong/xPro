/*
 * xArgs.cpp
 *
 *  Created on: Oct 23, 2021
 *      Author: brandonmfong
 */

#include "../../Lib/xArguments/xArgs.hpp"

#ifdef __cplusplus
extern "C" {
#endif

#include "../Utilities/Utilities.h"

#ifdef __cplusplus
}
#endif

xArguments::xArguments(xInt8 argc, char ** argv, xError * err) {
	xError error = kNoError;

	this->_arguments 	= xNull;
	this->_numArgs 		= 0;

	error = this->_saveArgs(argc, argv);

	if (err != xNull) {
		*err = error;
	}
}

xArguments::~xArguments() {
	if (this->_arguments != xNull) {
		for (xUInt8 i = 0; i < this->_numArgs; i++) xFree(this->_arguments[i]);
		xFree(this->_arguments);
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

	if (err != xNull) {
		*err = error;
	}

	return result;
}

const char * xArguments::argAtIndex(xUInt8 index, xError * err) {
	const char * 	result 	= xNull;
	xError 			error 	= kNoError;

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

xInt8 xArguments::indexForArg(const char * arg, xError * err) {
	xInt8 	result 		= -1,
			i			= 0;
	xError 	error 		= kNoError;
	char 	* tempArg 	= xNull;
	xBool 	foundArg 	= xFalse;

	for (
		i = 0;
		(i < this->_numArgs) && (error == kNoError) && !foundArg;
		i++
	) {
		tempArg = this->_arguments[i];
		error 	= tempArg != xNull ? kNoError : kArgError;

		if (error == kNoError) {
			foundArg = !strcmp(arg, tempArg);
		}
	}

	if (foundArg) {
		result = i - 1;
	}

	if (err != xNull) {
		*err = error;
	}

	return result;
}
