/*
 * xNode.h
 *
 *  Created on: Sep 1, 2021
 *      Author: BrandonMFong
 */

#ifndef XARRAY_XNODE_XNODE_H_
#define XARRAY_XNODE_XNODE_H_

class xNode {
public:
	xNode();
	virtual ~xNode();

	void * previous;
	void * next;
};

#endif /* XARRAY_XNODE_XNODE_H_ */
