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
	char 	* result 			= xNull,
			* tagString 		= xNull,
			* tempString 		= xNull,
			* tempAttrString 	= xNull,
			* attrString 		= xNull,
			** split 			= xNull,
			* innerXml 			= xNull;
	xError 	error 				= kNoError;
	xUInt8 	splitSize 			= 0,
			quoteCount			= 0;
	xUInt32 endTagCharRecord 	= 0;
	xBool 	finished 			= xFalse;

	if (elementPath == xNull) {
		error = kStringError;
	} else {
		this->_parseHelper.init();

		this->_parseHelper.contentLength 	= strlen(this->_rawContent);
		this->_parseHelper.arrayIndex 		= 1; // Set it to 1

		this->_parseHelper.tagPathArray = xSplitString(
			elementPath,
			ELEMENT_PATH_SEP,
			&this->_parseHelper.arraySize,
			&error
		);
	}

	if (error == kNoError) {
		// Init empty string
		tagString = xCopyString("", &error);
	}

	while (		(this->_parseHelper.contentIndex < this->_parseHelper.contentLength)
			&& 	(error == kNoError)
			&& 	(this->_parseHelper.arrayIndex <= this->_parseHelper.arraySize)
			&& 	!finished
	) {
		switch (this->_parseHelper.state) {
		case kIdle:
			if (this->_rawContent[this->_parseHelper.contentIndex] == '<') {
				this->_parseHelper.state = kReadingTagString;
			}

			break;

		case kPrepareReadingInnerXml:
			// Init to one
			endTagCharRecord = 1;

			if (this->_rawContent[this->_parseHelper.contentIndex] == '<') {
				endTagCharRecord++;
			}

			// Initialize innerXml string
			xFree(innerXml);
			innerXml = xCopyString("", &error);

			if (error == kNoError) {
				tempString = xCharToString(this->_rawContent[this->_parseHelper.contentIndex], &error);
			}

			if (error == kNoError) {
				error = xApendToString(&innerXml, tempString);
				xFree(tempString);
			}

			// If we are here and we have went through the whole tag
			// array, then we need to immediately go record the inner xml
			this->_parseHelper.state = kInnerXml;

			break;

		case kInnerXml:
			// Make sure we are not out of range
			if ((this->_parseHelper.contentIndex + 1) < this->_parseHelper.contentLength) {
				if (this->_rawContent[this->_parseHelper.contentIndex] == '<') {
					if (this->_rawContent[this->_parseHelper.contentIndex + 1] == '/') {
						endTagCharRecord--;
					} else {
						endTagCharRecord++;
					}
				}
			} else {
				error = kOutOfRangeError;
			}

			// If endTagCharRecord is 0 then we know we found the last closing tag
			if (endTagCharRecord > 0) {
				if (error == kNoError) {
					tempString = xCharToString(this->_rawContent[this->_parseHelper.contentIndex], &error);
				}

				if (error == kNoError) {
					error = xApendToString(&innerXml, tempString);
					xFree(tempString);
				}
			} else {
				finished 	= xTrue;
				result 		= xCopyString(innerXml, &error); // Save the value in result
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
						tempString = xNull;
						this->_parseHelper.arrayIndex++;

						// Reset the tag string
						tagString = xCopyString("", &error);
					}
				}

				if (error == kNoError) {
					if (this->_rawContent[this->_parseHelper.contentIndex] == '>') {
						// If we reached the end of the tag array, we need to start reading the inner xml
						if (this->_parseHelper.arrayIndex == this->_parseHelper.arraySize) {
							this->_parseHelper.state = kPrepareReadingInnerXml;
						} else {
							// Go to idle
							this->_parseHelper.state = kIdle;
						}
					} else if (this->_rawContent[this->_parseHelper.contentIndex] == '/') {
						// Wait for not to finish
						this->_parseHelper.state = kWaitToCloseTag;
					}
				}

				break;

			case ' ': // start of attribute
				// Get the current tag string.  We want to see if it has the '.', denoting an attribute path
				if (error == kNoError) {
					tempString 	= this->_parseHelper.tagPathArray[this->_parseHelper.arrayIndex];
					split 		= xSplitString(tempString, ".", &splitSize, &error);
				}

				if (error == kNoError) {
					// If the size is two, then caller passed a path to an attribute.  If that
					// is true, then we need to save the attribute
					if (splitSize == 2) {
						this->_parseHelper.state = kReadAttributeString;

						tempAttrString = split[1];

						if (tempAttrString == xNull) {
							error = kXMLError;
							DLog("NULL string for attribute\n");
						}

						// We need to initialize the attrString if all succeeds
						if (error == kNoError) {
							attrString = xCopyString("", &error);
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
				}

				if (error == kNoError) {
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
						// Set count to 0 so that we know when to stop reading
						// for the attribute string
						quoteCount = 0;

						this->_parseHelper.state = kReadAttributeValue;

						// Reset attrString
						xFree(attrString);
						attrString = xCopyString("", &error);
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
			switch (this->_rawContent[this->_parseHelper.contentIndex]) {
			case '"':
				quoteCount++;
				break;
			default:
				if (quoteCount < 2) {
					if (error == kNoError) {
						tempString = xCharToString(this->_rawContent[this->_parseHelper.contentIndex], &error);

						error = xApendToString(&attrString, tempString);
						xFree(tempString);
					}
				} else {
					result 		= xCopyString(attrString, &error);
					finished 	= xTrue;
				}

				break;
			}
			break;

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

	xFree(attrString);
	xFree(tagString);
	xFree(innerXml);

	if (err != xNull) {
		*err = error;
	}

	return result;
}

xError xXML::setContent(const char * rawContent) {
	xError result = kNoError;

	xFree(this->_rawContent);

	this->_rawContent = xCopyString(rawContent, &result);

	return result;
}
