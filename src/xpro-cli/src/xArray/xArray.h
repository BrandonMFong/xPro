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
	xArray();
	virtual ~xArray();
	xError addObject(void * obj);
private:
	xNode * _startNode;
	xUint64 _size;
};

#endif /* XARRAY_H_ */
