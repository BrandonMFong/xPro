/*
 * xArgs.h
 *
 *  Created on: Oct 23, 2021
 *      Author: brandonmfong
 */

#ifndef SRC_XARGS_H_
#define SRC_XARGS_H_

#include <stdlib.h>
#include <string.h>

#include "../../Lib/xBool.h"
#include "../../Lib/xError.h"
#include "../../Lib/xInt.h"
#include "../../Lib/xInt.h"
#include "../../Lib/xNull.h"

/**
 * Command line argument parsers
 */
class xArguments {
public:
	/**
	 * Saves argv array into memory
	 *
	 * Establishes a reference to itself so that this object
	 * is globally accessable from any part of the source
	 * code.  So long as the constructor is invoked once
	 */
	xArguments(xInt8 argc, char ** argv, xError * err);

	/**
	 * Destroys the argument memory array
	 */
	virtual ~xArguments();

	/**
	 * Returns true if the saved argv from command line contains arg
	 */
	xBool contains(const char * arg, xError * err);

	/**
	 * Returns argument at the specified index.  Null on error
	 *
	 * You do not need to free the return string.  This string is
	 * owned by xArgument object
	 */
	const char * argAtIndex(xUInt8 index, xError * err);

	/**
	 * Returns total count of application arguments including
	 * the executable
	 *
	 */
	xUInt8 count() {
		return this->_numArgs;
	}

	/**
	 * Returns index for the argument
	 *
	 * Default return value is -1
	 */
	xInt8 indexForArg(const char * arg, xError * err);

private:
	/**
	 * Saves the argv into memory
	 */
	xError _saveArgs(int argc, char ** argv);

	/**
	 * Holds the count of the arguments
	 */
	xUInt8 _numArgs;

	/**
	 * Holds the array of arguments
	 */
	char ** _arguments;
};

#endif /* SRC_XARGS_H_ */