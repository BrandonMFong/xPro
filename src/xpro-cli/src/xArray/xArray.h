/*
 * xArray.h
 *
 *  Created on: Sep 1, 2021
 *      Author: BrandonMFong
 */

#ifndef XARRAY_H_
#define XARRAY_H_

#include <xLib.h>
#include "xNode/xNode.h"

class xArray {
public:
	/**
	 * Constructor
	 */
	xArray();

	/**
	 * Destructor
	 */
	virtual ~xArray();

	/**
	 * Adds the xNode object to the end of the list
	 *
	 * This function assumes that the _startNode was already set
	 */
	xError addObject(void * obj);
private:

	/**
	 * Pointer to the start of the array
	 */
	xNode * _startNode;

	/**
	 * Size of the array
	 */
	xUint64 _size;
};

#endif /* XARRAY_H_ */
