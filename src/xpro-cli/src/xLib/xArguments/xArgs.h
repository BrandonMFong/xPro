/*
 * xArgs.h
 *
 *  Created on: Oct 23, 2021
 *      Author: brandonmfong
 */

#ifndef SRC_XARGS_H_
#define SRC_XARGS_H_

#include <xError.h>
#include <xBool.h>
#include <xNull.h>
#include <xInt.h>
#include <stdlib.h>
#include <string.h>

/**
 * Command line argument parsers
 */
class xArguments {
public:
	/**
	 * Saves argv array into memory
	 */
	xArguments(int argc, char ** argv, xError * err);

	/**
	 * Destroys the argument memory array
	 */
	virtual ~xArguments();

	/**
	 * Returns true if the saved argv from command line contains arg
	 */
	xBool contains(const char * arg, xError * err);

	/**
	 * Returns argument at the specified index.
	 *
	 * You do not need to free the return string.  This string is
	 * owned by xArgument object
	 */
	char * argAtIndex(xUInt8 index, xError * err);

	/**
	 * Returns total count of application arguments
	 */
	xUInt8 count() {
		return this->_numArgs;
	}

	static xArguments * shared();

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
