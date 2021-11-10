/*
 * xXML.cpp
 *
 *  Created on: Oct 30, 2021
 *      Author: brandonmfong
 */

#include <xXML/xXML.hpp>

xXML::xXML(const char * path, xError * err) {
	xError error = kNoError;

	this->_path 		= xNull;
	this->_rawContent	= xNull;

	// Read contents of file into rawContent
	if (path != xNull) {
		error = this->read(path);
	}

	if (err != xNull) {
		*err = error;
	}
}

xXML::~xXML() {
	xFree(this->_path);
	xFree(this->_rawContent);
}

xError xXML::read(const char * path) {
	xError result = kNoError;

	// Erase old content
	xFree(this->_rawContent);

	// Read file content at path
	this->_rawContent = xReadFile(path, &result);

	// Save the path
	if (result == kNoError) {
		// Free memory if path was already set
		xFree(this->_path);

		this->_path = xCopyString(path, &result);
	}

	return result;
}

char * xXML::getValue(
	const char * 	elementPath,
	xError * 		err
) {
	char * result = xNull;
	xError error = kNoError;

	if (elementPath == xNull) {
		error = kStringError;
	} else {
		this->_parseHelper.init();

		this->_parseHelper.tagPathArray = xSplitString(
			elementPath,
			ELEMENT_PATH_SEP,
			&this->_parseHelper.arraySize,
			&error
		);
	}

	if (error == kNoError) {
		this->_parseHelper.contentLength = strlen(this->_rawContent);
		result = this->sweepContent(&error);
	}

	if (err != xNull) {
		*err = error;
	}

	return result;
}

char * xXML::sweepContent(xError * err) {
	char * result = xNull;
	xError error = kNoError;
	char * tagString = xNull;
	char * tempString = xNull;
	char * tempAttrString = xNull;
	char * attrString = xNull;
	char ** split = xNull;
	xUInt8 splitSize = 0;

	// Init empty string
	tagString = xCopyString("", &error);

	while ((this->_parseHelper.contentIndex < this->_parseHelper.contentLength) && (error == kNoError)) {
		switch (this->_parseHelper.state) {
		case kIdle:
			if (this->_rawContent[this->_parseHelper.contentIndex] == '<') {
				this->_parseHelper.state = kReadingTagString;
			}
			break;

		case kReadingTagString:
			// Add to tag string if are still sweeping tag
			switch (this->_rawContent[this->_parseHelper.contentIndex]) {

			// Compare tag string with the strings in array
			case '>': // end of tag
			case '/': // start of the end of a tag
				if (error == kNoError) {
					tempString = this->_parseHelper.tagPathArray[this->_parseHelper.arrayIndex];

					// If we found a tag from the tag path then increment the array index
					if (!strcmp(tempString, tagString)) {
						this->_parseHelper.arrayIndex++;
					}
				}
				break;
			case ' ': // start of attribute
				if (error == kNoError) {
					tempString 	= this->_parseHelper.tagPathArray[this->_parseHelper.arrayIndex];
					split 		= xSplitString(tempString, ".", &splitSize, &error);
				}

				if (error == kNoError) {
					if (splitSize == 2) {
						tempAttrString = split[1];

						if (tempAttrString != xNull) {
							this->_parseHelper.state = kReadAttributeString;
						} else {

						}
					} else if (splitSize == 1) {
						this->_parseHelper.state = kWaitToCloseTag;
					} else {
						error = kXMLError;
					}
				}
				break;
			default:
				if (error == kNoError) {
					tempString = xCharToString(this->_rawContent[this->_parseHelper.contentIndex], &error);

					error = xApendToString(&tagString, tempString);
					xFree(tempString);
				}
			}
			break;

		// When find the close tag, then go to the idle state to wait for new start of tag
		case kWaitToCloseTag:
			if (this->_rawContent[this->_parseHelper.contentIndex] == '>') {
				this->_parseHelper.state = kIdle;
			}
			break;

		// Gather the characters to form the attribute
		case kReadAttributeString:
			switch (this->_rawContent[this->_parseHelper.contentIndex]) {
			case '=':
				if (error == kNoError) {
					// If user specified the attribute in the path then we need to read the value.  Otherwise we will wait for the next tag
					if (!strcmp(tempAttrString, attrString)) {
						this->_parseHelper.state = kReadAttributeValue;
					} else {
						this->_parseHelper.state = kWaitToCloseTag;
					}
				}
				break;
			default:
				if (error == kNoError) {
					tempString = xCharToString(this->_rawContent[this->_parseHelper.contentIndex], &error);

					error = xApendToString(&attrString, tempString);
					xFree(tempString);
				}
				break;
			}
			break;

		// Get the attribute value inside quotes
		case kReadAttributeValue:
			break;
		default:
			break;
		}

		if (error == kNoError) {
			this->_parseHelper.contentIndex++;
		}
	}

	if (error != kNoError) {
		DLog("There was an error during parsing");
	}

	if (err != xNull) {
		*err = error;
	}

	return result;
}
