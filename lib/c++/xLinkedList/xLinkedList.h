/*
 * xArray.h
 *
 *  Created on: Sep 1, 2021
 *      Author: BrandonMFong
 */

#ifndef XARRAY_H_
#define XARRAY_H_

#include <xLib.h>
#include <xLinkedList/xNode/xNode.h>

class xLinkedList {
public:
	/**
	 * Constructor
	 */
	xLinkedList();

	/**
	 * Destructor
	 */
	virtual ~xLinkedList();

	/**
	 * Adds the xNode object to the end of the list
	 *
	 * This function assumes that the _startNode was already set. I also expect that
	 * the objecdts that are being saved are retained.  DO NOT add an object that does not
	 * have guaranteed memory.
	 */
	xError addObject(void * obj);

	/**
	 * Returns _size
	 */
	xUInt64 size();

private:

	/**
	 * Pointer to the start of the array
	 */
	xNode * _startNode;

	/**
	 * Size of the array
	 */
	xUInt64 _size;
};

#endif /* XARRAY_H_ */
