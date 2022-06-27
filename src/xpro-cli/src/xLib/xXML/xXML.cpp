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
			* attrKey = xNull,
			* attrValue = xNull;
	xError error = kNoError;
	xUInt8 size = 0, i = 0;
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
		tempString = splitString[i];
		error = tempString != xNull ? kNoError : kStringError;

		// See if there is an attribute
		if (error == kNoError) {
			if (xContainsSubString(tempString, ".", &error)) {
				hasAttr = error == kNoError;
			}
		}

		// If there is an attribute, then get the key and value
		if (hasAttr && (error == kNoError)) {
			char buf[1024];
			memset(&buf[0], 0, 1024);
			strcpy(buf, tempString);

			error = xXML::parseNodePathForNodeValueAndAttrKeyValue(
				buf,
				&tempString,
				&attrKey,
				&attrValue
			);
		}

		if (error == kNoError) {
			// If we found the node, then lets go to then next string in our path and
			// the next node
			if (!strcmp(node->name(), tempString)) {
				i++;
				done = (i == size);

				xBool getAttrValue = xFalse, getNodeValue = xFalse;
				char * tempAttrValue = xNull;
				if (attrKey != xNull) {
					if (attrValue != xNull) {
						getNodeValue = xXML::doesNodeContainAttrKeyAndValue(
							node,
							attrKey,
							attrValue
						);
					} else {
						tempAttrValue = xXML::getAttrValue(node, attrKey);
						getAttrValue = tempAttrValue != xNull;
					}
				} else {
					getNodeValue = done;
				}

				if (done) {
					if (getNodeValue) {
						result = xCopyString(node->value(), &error);
					} else if (getAttrValue) {
						result = xCopyString(tempAttrValue, &error);
					} else {
						error = kUnknownError;
					}
				} else {
					node 	= node->first_node();
					error 	= node != xNull ? kNoError : kXMLError;
				}
			} else {
				node = node->next_sibling();

				// If there are no more nodes, then we are done
				done = node == xNull;
			}
		}

		xFree(attrValue);
		xFree(attrKey);

		// We know that hasAttr==true if there was a '.' in the node path. We can assume that tempString
		//  has the address to the string before '.'
		if (hasAttr) {
			xFree(tempString);
		}
	}

	for (xUInt8 i = 0; i < size; i++) xFree(splitString[i]);
	xFree(splitString);

	if (err != xNull) {
		*err = error;
	}

	return result;
}

xUInt64 xXML::countTags(const char * nodePath, xError * err) {
	xUInt64 result = 0;
	xError error = kNoError;
	char 	** splitString = xNull,
			* tempNodeString = xNull,
			* attrKey = xNull,
			* attrValue = xNull;
	xUInt8 size = 0, i = 0;
	xml_node<> * node = xNull;
	xBool done = xFalse;

	splitString = xSplitString(nodePath, ELEMENT_PATH_SEP, &size, &error);

	if (error == kNoError) {
		node = this->_xmldoc.first_node();
		error = node != xNull ? kNoError : kXMLError;
	}

	while ((i < size) && (error == kNoError) && !done) {
		xBool hasAttr = xFalse;
		tempNodeString = splitString[i];
		error = tempNodeString != xNull ? kNoError : kStringError;

		// See if there is an attribute
		if (error == kNoError) {
			if (xContainsSubString(tempNodeString, ".", &error)) {
				hasAttr = error == kNoError;
			}
		}

		// If there is an attribute, then get the key and value
		if (hasAttr && (error == kNoError)) {
			char buf[1024];
			memset(&buf[0], 0, 1024);
			strcpy(buf, tempNodeString);

			error = xXML::parseNodePathForNodeValueAndAttrKeyValue(
				buf,
				&tempNodeString,
				&attrKey,
				&attrValue
			);
		}

		if (error == kNoError) {
			// If we found the node, then lets go to then next string in our path and
			// the next node
			if (!strcmp(node->name(), tempNodeString)) {
				i++;
				done = (i == size);

				xBool countAttrs = xFalse, countNodes = xFalse;
				char * tempAttrValue = xNull;
				if (attrKey != xNull) {
					if (attrValue != xNull) {
						countNodes = xXML::doesNodeContainAttrKeyAndValue(
							node,
							attrKey,
							attrValue
						);
					} else {
						tempAttrValue = xXML::getAttrValue(node, attrKey);
						countAttrs = tempAttrValue != xNull;
					}
				} else {
					countNodes = done;
				}

				if (done) {
					if (countNodes) {
						result = xXML::countNodesWithName(node, tempNodeString);
					} else if (countAttrs) {
						result = xXML::countAttributesWithKey(node->first_attribute(), attrKey);
					} else {
						error = kUnknownError;
					}
				} else {
					node 	= node->first_node();
					error 	= node != xNull ? kNoError : kXMLError;
				}
			} else {
				node = node->next_sibling();

				// If there are no more nodes, then we are done
				done = node == xNull;
			}
		}

		xFree(attrValue);
		xFree(attrKey);

		// We know that hasAttr==true if there was a '.' in the node path. We can assume that tempString
		//  has the address to the string before '.'
		if (hasAttr) {
			xFree(tempNodeString);
		}
	}

	for (xUInt8 i = 0; i < size; i++) xFree(splitString[i]);
	xFree(splitString);

	if (err) *err = error;

	return result;
}

xError xXML::parseNodePathForNodeValueAndAttrKeyValue(const char * nodePathString, char ** nodeString, char ** key, char ** value) {
	xError result = kNoError;
	char ** splitString = xNull, * tempString = xNull;
	xUInt8 splitSize;
	xBool hasAttrValue = xFalse;

	// make sure output outlet is not null
	if ((key == xNull) || (value == xNull) || (nodeString == xNull)) {
		result = kXMLError;
	}

	// If we are here, then we know "." is somewhere in this path.  Let's
	// locate it and split the string at that position
	if (result == kNoError) {
		splitString = xSplitString(nodePathString, ".", &splitSize, &result);
	}

	// make sure the split size is 2
	if (result == kNoError) {
		result = splitSize == 2 ? kNoError : kXMLError;
	}

	if (result == kNoError) {
		*nodeString = xCopyString(splitString[0], &result);
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
		if (xContainsSubString(nodePathString, "(", &result)) {
			hasAttrValue = result == kNoError;
		}
	}

	if (hasAttrValue && (result == kNoError)) {
		if (xContainsSubString(nodePathString, ")", &result)) {
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
					nodePathString,
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

xBool xXML::doesNodeContainAttrKeyAndValue(
	xml_node<> * node,
	const char * attrKey,
	const char * attrValue
) {
	for (
		xml_attribute<> * tempAttr = node->first_attribute();
		tempAttr;
		tempAttr = tempAttr->next_attribute()) {
		if (	!strcmp(tempAttr->name(), attrKey)
			&& 	!strcmp(tempAttr->value(), attrValue)) {
			return xTrue;
		}
	}

	return xFalse;
}

char * xXML::getAttrValue(
		xml_node<> * node,
		const char * attrKey
	) {
	for (
		xml_attribute<> * tempAttr = node->first_attribute();
		tempAttr;
		tempAttr = tempAttr->next_attribute()) {
		if (!strcmp(tempAttr->name(), attrKey)) {
			return tempAttr->value();
		}
	}

	return xNull;
}

xUInt64 xXML::countNodesWithName(xml_node<> * node, const char * nodeName) {
	xUInt64 result = 0;
	xml_node<> * tempNode = node;

	do {
		if (!strcmp(tempNode->name(), nodeName)) {
			result++;
		}
	} while ((tempNode = tempNode->next_sibling()));

	return result;
}

xUInt64 xXML::countAttributesWithKey(
	rapidxml::xml_attribute<> * node,
	const char * attrKey
) {
	xUInt64 result = 0;
	xml_attribute<> * tempAttr = node;

	do {
		if (!strcmp(tempAttr->name(), attrKey)) {
			result++;
		}
	} while ((tempAttr = tempAttr->next_attribute()));

	return result;
}
