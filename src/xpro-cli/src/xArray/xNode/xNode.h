/*
 * xNode.h
 *
 *  Created on: Sep 1, 2021
 *      Author: BrandonMFong
 */

#ifndef XARRAY_XNODE_XNODE_H_
#define XARRAY_XNODE_XNODE_H_

#include <xLib.h>

class xNode {
public:
	/**
	 * Initializes the node object with a pointer to the object
	 */
	xNode(void * object, xError * err);

	/**
	 * Destructor
	 */
	virtual ~xNode();

	/**
	 * Pointer to previous node in list
	 */
	xNode * previous;

	/**
	 * Pointer to next node in list
	 */
	xNode * next;

	/**
	 * Pointer to any object
	 */
	void * object;
};

#endif /* XARRAY_XNODE_XNODE_H_ */
