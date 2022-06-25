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
	char 	* result = xNull,
			** splitString = xNull,
			* tempString = xNull,
			* tempNodeString = xNull,
			* attrKey = xNull,
			* attrValue = xNull,
			** tempSplitString = xNull,
			* tempAttrString = xNull;
	xError error = kNoError;
	xUInt8 size = 0, i = 0, splitSize = 0;
	xml_node<> * node = xNull;
	xBool done = xFalse;

	splitString = xSplitString(nodePath, ELEMENT_PATH_SEP, &size, &error);

	// Get the first node from document
	if (error == kNoError) {
		node = this->_xmldoc.first_node();
		error = node != xNull ? kNoError : kXMLError;
	}

	while ((i < size) && (error == kNoError) && !done) {
		xBool hasAttr = xFalse;
		splitSize = 0;
		tempSplitString = xNull;
		tempString = splitString[i];
		error = tempString != xNull ? kNoError : kStringError;

		// See if there is an attribute
		if (error == kNoError) {
			if (xContainsSubString(tempString, ".", &error)) {
				hasAttr = error == kNoError;
			}
		}

		if (hasAttr) {
			if (error == kNoError) {
				tempSplitString = xSplitString(tempString, ".", &splitSize, &error);
			}

			// If there is an attribute, then get the key and value
			if (error == kNoError) {
				error = xXML::getAttrKeyValue(tempString, &attrKey, &attrValue);
			}

			// just giving tempString a ref.  We will delete that memory in
			// the for loop at the end of this while loop
			if (error == kNoError) {
				tempString = tempSplitString[0];
			}
		}

		if (error == kNoError) {
			tempNodeString = node->name();

			// If we found the node, then lets go to then next string in our path and
			// the next node
			if (!strcmp(tempNodeString, tempString)) {
				if (attrKey != xNull) {

				}

				i++;

				node = node->first_node();
				error = node != xNull ? kNoError : kXMLError;
			} else {
				node = node->next_sibling();

				// If there are no more nodes, then we are done
				done = node == xNull;
			}
		}

		xFree(attrValue);
		xFree(attrKey);

		for (int i = 0; i < splitSize; i++) xFree(tempSplitString);
		xFree(tempSplitString);
	}

	for (xUInt8 i = 0; i < size; i++) xFree(splitString[i]);
	xFree(splitString);

	if (err != xNull) {
		*err = error;
	}

	return result;
}

xError xXML::getAttrKeyValue(const char * attrString, char ** key, char ** value) {
	xError result = kNoError;
	char ** splitString = xNull, * tempString = xNull;
	xUInt8 splitSize;
	xBool hasAttrValue = xFalse;

	// make sure output outlet is not null
	if ((key == xNull) || (value == xNull)) {
		result = kXMLError;
	}

	// If we are here, then we know "." is somewhere in this path.  Let's
	// locate it and split the string at that position
	if (result == kNoError) {
		splitString = xSplitString(attrString, ".", &splitSize, &result);
	}

	// make sure the split size is 2
	if (result == kNoError) {
		result = splitSize == 2 ? kNoError : kXMLError;
	}

	// Copy the last split, that is where the attribute is
	if (result == kNoError) {
		tempString = xCopyString(splitString[splitSize - 1], &result);

		// We don't need this anymore
		for (int i = 0; i < splitSize; i++) xFree(splitString[i]);
		xFree(splitString);
		splitSize = 0;
	}

	// See if the attribute specifies a value
	if (result == kNoError) {
		if (xContainsSubString(attrString, "(", &result)) {
			hasAttrValue = result == kNoError;
		}
	}

	if (hasAttrValue && (result == kNoError)) {
		if (xContainsSubString(attrString, ")", &result)) {
			hasAttrValue = result == kNoError;
		}
	}

	// If it has a value, then the attribute key comes before "("
	if (hasAttrValue) {
		if (result == kNoError) {
			splitString = xSplitString(tempString, "(", &splitSize, &result);
		}

		if (result == kNoError) {
			result = splitSize == 2 ? kNoError : kXMLError;
		}

		if (result == kNoError) {
			*key = xCopyString(splitString[0], &result);
		}

		if (result == kNoError) {
			*value = xStringBetweenTwoStrings(
				attrString,
				"(",
				")",
				&result
			);
		}

	// Otherwise we can just use the string as the key and the value is null
	} else {
		if (result == kNoError) {
			*key = xCopyString(tempString, &result);
		}
	}

	for (int i = 0; i < splitSize; i++) xFree(splitString[i]);
	xFree(splitString);
	splitSize = 0;

	xFree(tempString);

	return result;
}
