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
	xError result = kNoError;
	xNode * node = xNull;
	bool okayToContinue = false;
	xUint64 index;
	xUint64 count;
	xNode * tempNode = xNull;

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
				tempNode = tempNode->next;
				result = tempNode != xNull ? kNoError : kNodeObjectError;
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
		}
		this->_size++;
	}

	return result;
}

//xError xArray::addObject(xNode * node)
//{
//	xError result = kNoError;
//	xNode * tempNode = NULL;
//	bool okayToContinue = true;
//	xUint64 index;
//	xUint64 count;
//
//	if (result == kNoError) {
//		result = this->_startNode != NULL ? kNoError : kStartNodeError;
//
//		if (result == kNoError) {
//			tempNode = this->_startNode;
//		}
//	}
//
//	if (result == kNoError) {
//		index = 0;
//		count = this->_size;
//		while ((index < count) && (result == kNoError))
//		{
//			okayToContinue = true;
//
//			// Get next node
//			if (result == kNoError) {
//				tempNode = tempNode->next;
//				result = tempNode != NULL ? kNoError : kNodeObjectError;
//			}
//
//			// See if we are at the last index
//			if (result == kNoError) {
//				okayToContinue = (index == (count - 1));
//			}
//
//			// node pointer should not be null
//			if (okayToContinue && (result == kNoError)) {
//				result = (tempNode->next == NULL) ? kNoError : kNodeObjectError;
//			}
//
//			// Save node
//			if (okayToContinue && (result == kNoError)) {
//				tempNode->next = node;
//			}
//
//			index++;
//		}
//	}
//
//	return result;
//}
