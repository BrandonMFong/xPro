/*
 * xArray.cpp
 *
 *  Created on: Sep 1, 2021
 *      Author: BrandonMFong
 */

#include <xArray/xArray.h>

xArray::xArray() {
	this->_startNode 	= NULL;
	this->_size 		= 0;
}

xArray::~xArray() {

}

xError xArray::addObject(void * obj) {
	xError 	result 			= kNoError;
	xNode * node 			= xNull;
	bool 	okayToContinue 	= false;
	xNode * tempNode 		= xNull;
	xUint64 index;
	xUint64 count;

	if (result == kNoError) {
		node = new xNode(obj, &result);
		if (node == xNull) {
			result = kNULLError;
		}
	}

	if (result == kNoError) {
		if (this->_size == 0) { // Set start node
			this->_startNode = node;
		} else { // add node to the end
			okayToContinue = true;
		}
	}

	if (okayToContinue && (result == kNoError)) {
		result = this->_startNode != xNull ? kNoError : kStartNodeError;

		if (result == kNoError) {
			tempNode = this->_startNode;
		}
	}

	if (okayToContinue && (result == kNoError)) {
		index = 0;
		count = this->_size - 1;
		while ((index < count) && (result == kNoError))
		{
			if (result == kNoError) {
				tempNode 	= tempNode->next;
				result 		= tempNode != xNull ? kNoError : kNodeObjectError;
			}

			if (result != kNoError) {
				DLog("Node is null and that is not expected, index %llu\n", index);
			}

			index++;
		}
	}

	if (result == kNoError) {
		if (okayToContinue) {
			tempNode->next = node;
			node->previous = tempNode;
		}
		this->_size++;
	}

	return result;
}
