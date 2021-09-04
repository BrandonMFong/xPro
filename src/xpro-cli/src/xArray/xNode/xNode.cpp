/*
 * xNode.cpp
 *
 *  Created on: Sep 1, 2021
 *      Author: BrandonMFong
 */

#include <xArray/xNode/xNode.h>

xNode::xNode(void * object, xError * err) {
	xError error = kNoError;

	this->next = NULL;
	this->previous = NULL;
	this->object = NULL;

	if (error == kNoError) {
		error = object != NULL ? kNoError : kNodeObjectError;
	}

	if (error == kNoError) {
		this->object = object;
	}

	if (err != NULL) {
		*err = error;
	}
}

xNode::~xNode() {
	// TODO Auto-generated destructor stub
}

