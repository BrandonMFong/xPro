/*
 * xArray.cpp
 *
 *  Created on: Sep 1, 2021
 *      Author: BrandonMFong
 */

#include <xLinkedList/xLinkedList.h>

xLinkedList::xLinkedList() {
	this->_startNode 	= xNull;
	this->_size 		= 0;
}

xLinkedList::~xLinkedList() {

}

xError xLinkedList::addObject(void * obj) {
	xError 	result 			= kNoError;
	xNode * node 			= xNull;
	bool 	okayToContinue 	= false;
	xNode * tempNode 		= xNull;
	xUInt64 index;
	xUInt64 count;

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
