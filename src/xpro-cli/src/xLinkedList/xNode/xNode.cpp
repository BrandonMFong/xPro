/*
 * xNode.cpp
 *
 *  Created on: Sep 1, 2021
 *      Author: BrandonMFong
 */

#include <xLinkedList/xNode/xNode.h>

xNode::xNode(void * object, xError * err) {
	xError error = kNoError;

	this->next = xNull;
	this->previous = xNull;
	this->object = xNull;

	if (error == kNoError) {
		error = object != xNull ? kNoError : kNodeObjectError;
	}

	if (error == kNoError) {
		this->object = object;
	}

	if (err != xNull) {
		*err = error;
	}
}

xNode::~xNode() {
	// TODO Auto-generated destructor stub
}

