/*
 * xXML.cpp
 *
 *  Created on: Oct 30, 2021
 *      Author: brandonmfong
 */

#include <xXML/xXML.hpp>
#include <xUtilities/xUtilities.h>
#include <fstream>
#include <sstream>

using namespace rapidxml;

xXML::xXML(const char * path, xError * err) {
	xError error = kNoError;

	this->_path = xCopyString(path, &error);

	if (error == kNoError) {
		this->_xmlStream = new std::ifstream(this->_path);
		error = this->_xmlStream != xNull ? kNoError : kFileError;
	}

	if (error == kNoError) {
		std::stringstream buffer;
		buffer << this->_xmlStream->rdbuf();
		this->_buffer = buffer.str();
		this->_xmldoc.parse<0>(&this->_buffer[0]);
	}

	if (err != xNull) {
		*err = error;
	}
}

xXML::~xXML() {
	xFree(this->_path);

	this->_xmlStream->close();
	xDelete(this->_xmlStream);
}

char * xXML::getValue(const char * nodePath, xError * err) {
	char * result = xNull, ** splitString = xNull;;
	xError error = kNoError;
	xUInt8 size = 0;
	xUInt8 i = 0;
	xml_node<> * node = xNull;
	char * tempNodeString = xNull;
	xBool done = xFalse;
	char * tempString = xNull;

	splitString = xSplitString(nodePath, ELEMENT_PATH_SEP, &size, &error);

	// Get the first node from document
	if (error == kNoError) {
		node = this->_xmldoc.first_node();
		error = node != xNull ? kNoError : kXMLError;
	}

	while ((i < size) && (error == kNoError) && !done) {
		tempString = splitString[i];
		error = tempString != xNull ? kNoError : kStringError;

		if (error == kNoError) {
			if (xContainsSubString(tempString, "(", &error)) {
				// Handle attribute
			} else {
				tempNodeString = node->value();

				// If we found the node, then lets go to then next string in our path and
				// the next node
				if (!strcmp(tempNodeString, tempString)) {
					i++;

					node = node->first_node();
					error = node != xNull ? kNoError : kXMLError;
				}

			}
		}

		if (error == kNoError) {
			node = node->next_sibling();

			// If there are no more nodes, then we are done
			done = node == xNull;
		}
	}

	for (xUInt8 i = 0; i < size; i++) xFree(splitString[i]);
	xFree(splitString);

	if (err != xNull) {
		*err = error;
	}

	return result;
}
