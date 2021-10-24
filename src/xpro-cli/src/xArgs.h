/*
 * xArgs.h
 *
 *  Created on: Oct 23, 2021
 *      Author: brandonmfong
 */

#ifndef SRC_XARGS_H_
#define SRC_XARGS_H_

#include <xLib.h>

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
	 */
	char * argAtIndex(xUInt8 index, xError * err);

	/**
	 * Returns total count of application arguments
	 */
	xUInt8 count();

private:
	/**
	 * Saves the argv into memory
	 */
	xError saveArgs(int argc, char ** argv);

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
