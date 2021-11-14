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
	xError error = kNoError;

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
		this->_parseHelper.tagString = xCopyString("", &error);
	}

	while (		(this->_parseHelper.contentIndex < this->_parseHelper.contentLength)
			&& 	(error == kNoError)
			&& 	(this->_parseHelper.arrayIndex <= this->_parseHelper.arraySize)
			&& 	!this->_parseHelper.finished
	) {
		switch (this->_parseHelper.state) {
		case kIdle:
			this->parseIdle();
			break;

		// When find the close tag, then go to the idle state to wait for new start of tag
		case kWaitToCloseTag:
			this->parseWaitToCloseTag(kIdle);
			break;

		// If we are ready to read the inner xml but are far away from
		// the '>' char, then we need to wait for it before getting into kPrepareReadingInnerXml
		case kWaitToReadInnerXml:
			this->parseWaitToCloseTag(kPrepareReadingInnerXml);

			break;

		case kPrepareReadingInnerXml:
			error = this->parsePrepareToReadInnerXml();
			break;

		case kInnerXml:
			error = this->parseReadInnerXml();
			break;

		case kReadingTagString:
			error = this->parseTagString();
			break;

		// Gather the characters to form the attribute
		case kReadAttributeKey:
			error = this->parseAttributeKey();
			break;

		// Get the attribute value inside quotes
		case kReadAttributeValue:
			error = this->parseAttributeValue();
			break;

		default:
			break;
		}

		if (error == kNoError) {
			this->_parseHelper.contentIndex++;
		}
	}

	if (error != kNoError) {
		DLog("There was an error during parsing, %d", error);
	}

	xFree(this->_parseHelper.attrValue);
	xFree(this->_parseHelper.attrKey);
	xFree(this->_parseHelper.tagString);
	xFree(this->_parseHelper.innerXml);

	if (err != xNull) {
		*err = error;
	}

	return this->_parseHelper.result;
}

xError xXML::setContent(const char * rawContent) {
	xError result = kNoError;

	xFree(this->_rawContent);

	this->_rawContent = xCopyString(rawContent, &result);

	return result;
}

void xXML::parseIdle(void) {
	if (this->_rawContent[this->_parseHelper.contentIndex] == '<') {
		this->_parseHelper.state = kReadingTagString;
	}
}

void xXML::parseWaitToCloseTag(ParsingState nextState) {
	if (this->_rawContent[this->_parseHelper.contentIndex] == '>') {
		this->_parseHelper.state = nextState;
	}
}

xError xXML::parsePrepareToReadInnerXml() {
	xError result 		= kNoError;
	char * tempString 	= xNull;

	// Init to one
	this->_parseHelper.endTagCharRecord = 1;

	if (this->_rawContent[this->_parseHelper.contentIndex] == '<') {
		this->_parseHelper.endTagCharRecord++;
	}

	// Initialize innerXml string
	xFree(this->_parseHelper.innerXml);
	this->_parseHelper.innerXml = xCopyString("", &result);

	if (result == kNoError) {
		tempString = xCharToString(this->_rawContent[this->_parseHelper.contentIndex], &result);
	}

	if (result == kNoError) {
		result = xApendToString(&this->_parseHelper.innerXml, tempString);
		xFree(tempString);
	}

	// If we are here and we have went through the whole tag
	// array, then we need to immediately go record the inner xml
	this->_parseHelper.state = kInnerXml;

	return result;
}

xError xXML::parseReadInnerXml() {
	xError result 		= kNoError;
	char * tempString 	= xNull;

	// Make sure we are not out of range
	if ((this->_parseHelper.contentIndex + 1) < this->_parseHelper.contentLength) {
		if (this->_rawContent[this->_parseHelper.contentIndex] == '<') {
			if (this->_rawContent[this->_parseHelper.contentIndex + 1] == '/') {
				this->_parseHelper.endTagCharRecord--;
			} else {
				this->_parseHelper.endTagCharRecord++;
			}
		}
	} else {
		result = kOutOfRangeError;
	}

	// If endTagCharRecord is 0 then we know we found the last closing tag
	if (this->_parseHelper.endTagCharRecord > 0) {
		if (result == kNoError) {
			tempString = xCharToString(
				this->_rawContent[this->_parseHelper.contentIndex],
				&result
			);
		}

		if (result == kNoError) {
			result = xApendToString(
				&this->_parseHelper.innerXml,
				tempString
			);
			xFree(tempString);
		}
	} else {
		this->_parseHelper.finished = xTrue;

		this->_parseHelper.result = xCopyString( // Save the value in result
			this->_parseHelper.innerXml,
			&result
		);
	}

	return result;
}

xError xXML::parseTagString() {
	xError 	result 			= kNoError;
	char 	* tempString 	= xNull,
			** split 		= xNull;
	xUInt8 	splitSize 		= 0;

	// Add to tag string if are still sweeping tag
	switch (this->_rawContent[this->_parseHelper.contentIndex]) {

	// Compare tag string with the strings in array
	case '>': // end of tag
	case '/': // start of the end of a tag
		tempString = this->_parseHelper.tagPathArray[this->_parseHelper.arrayIndex];

		// If we found a tag from the tag path then increment the array index
		if (!strcmp(tempString, this->_parseHelper.tagString)) {
			tempString = xNull;
			this->_parseHelper.arrayIndex++;

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

		// Reset the tag string
		xFree(this->_parseHelper.tagString);
		this->_parseHelper.tagString = xCopyString("", &result);

		break;

	case ' ': // start of attribute
		// Get the current tag string.  We want to see if it has the '.', denoting an attribute path
		tempString = this->_parseHelper.tagPathArray[this->_parseHelper.arrayIndex];

		split = xSplitString(
			tempString,
			".",
			&splitSize,
			&result
		);

		if (result == kNoError) {
			// If the size is two, then caller passed a path to an attribute.  If that
			// is true, then we need to save the attribute
			if (splitSize == 2) {
				this->_parseHelper.state = kReadAttributeKey;

				this->_parseHelper.attrKeyString = split[1];

				if (this->_parseHelper.attrKeyString == xNull) {
					result = kXMLError;
					DLog("NULL string for attribute");
				} else {
					// Make a copy of the string because we are going to free split's memory
					this->_parseHelper.attrKeyString = xCopyString(this->_parseHelper.attrKeyString, &result);
				}

				// We need to initialize the attrString if all succeeds
				if (result == kNoError) {
					this->_parseHelper.attrKey = xCopyString("", &result);
				}

				if (result == kNoError) {
					// Reset the tag string
					xFree(this->_parseHelper.tagString);
					this->_parseHelper.tagString = xCopyString("", &result);
				}
			} else if (splitSize == 1) {
				this->_parseHelper.arrayIndex++; // Go to the next indexed element

				this->_parseHelper.state = kWaitToCloseTag;

				if (result == kNoError) {
					// Reset the tag string
					xFree(this->_parseHelper.tagString);
					this->_parseHelper.tagString = xCopyString("", &result);
				}
			} else {
				DLog("Received an unexpected size of %d", splitSize);
				result = kXMLError;
			}
		}

		if (split != xNull) {
			// Free memory because we do not need it
			for (xUInt8 i = 0; i < splitSize; i++) xFree(split[i]);
			xFree(split);
		}

		break;

	default:
		tempString = xCharToString(
			this->_rawContent[this->_parseHelper.contentIndex],
			&result
		);

		if (result == kNoError) {
			result = xApendToString(
				&this->_parseHelper.tagString,
				tempString
			);

			xFree(tempString);
		}
	}

	return result;
}

xError xXML::parseAttributeKey() {
	xError 	result 			= kNoError;
	char 	* tempString 	= xNull,
			** split 		= xNull;
	xUInt8 	splitSize 		= 0;

	switch (this->_rawContent[this->_parseHelper.contentIndex]) {
	case '=':
		this->_parseHelper.attrValSpecified = xFalse;

		// See if (...) is in the string
		this->_parseHelper.attrValSpecified = xContainsSubString(
			this->_parseHelper.attrKeyString,
			"(",
			&result
		);

		if (this->_parseHelper.attrValSpecified && (result == kNoError)) {
			this->_parseHelper.attrValSpecified = xContainsSubString(
				this->_parseHelper.attrKeyString,
				")",
				&result
			);
		}

		// If okayToContinue then we know the user specified an attribute value
		if (this->_parseHelper.attrValSpecified) {
			if (result == kNoError) {
				this->_parseHelper.specAttrValue = xStringBetweenTwoStrings(
					this->_parseHelper.attrKeyString,
					"(",
					")",
					&result
				);
			}

			// Reset the tempAttrString to remove the (...) string section
			if (result == kNoError) {
				split = xSplitString(this->_parseHelper.attrKeyString,
					"(",
					&splitSize,
					&result
				);
			}

			if (result == kNoError) {
				if (splitSize == 2) {
					xFree(this->_parseHelper.attrKeyString);
					this->_parseHelper.attrKeyString = xCopyString(split[0], &result);
				} else {
					result = kXMLError;
					DLog("Error in attempting to split string. There may be an error in the syntax\n");
				}
			}

			if (split != xNull) {
				for (xUInt8 i = 0; i < splitSize; i++) xFree(split[i]);
				xFree(split);
			}
		}

		if (result == kNoError) {
			// If user specified the attribute in the path then we need to
			// read the value.  Otherwise we will wait for the next tag
			if (!strcmp(this->_parseHelper.attrKeyString, this->_parseHelper.attrKey)) {
				// Set count to 0 so that we know when to stop reading
				// for the attribute string
				this->_parseHelper.quoteCount = 0;

				xFree(this->_parseHelper.attrKey);

				this->_parseHelper.attrValue 	= xCopyString("", &result);
				this->_parseHelper.state 		= kReadAttributeValue;
			} else {
				this->_parseHelper.state = kWaitToCloseTag;
			}
		}

		xFree(this->_parseHelper.attrKeyString);

		break;
	default:
		tempString = xCharToString(this->_rawContent[this->_parseHelper.contentIndex], &result);

		result = xApendToString(&this->_parseHelper.attrKey, tempString);
		xFree(tempString);

		break;
	}

	return result;
}

xError xXML::parseAttributeValue() {
	xError result 		= kNoError;
	char * tempString 	= xNull;

	switch (this->_rawContent[this->_parseHelper.contentIndex]) {
	case '"':
		this->_parseHelper.quoteCount++;

		// If we found the entire attribute string then we will
		// need to determine what the next state is
		if (this->_parseHelper.quoteCount == 2) {
			if (this->_parseHelper.attrValSpecified) {
				if (!strcmp(this->_parseHelper.attrValue, this->_parseHelper.specAttrValue)) {
					// Since we found the attribute, let's increment the array index to see what is
					// our next move
					this->_parseHelper.arrayIndex++;

					// If we still have more tags to look for, then we need to go back to the idle state
					if (this->_parseHelper.arrayIndex < this->_parseHelper.arraySize) {
						this->_parseHelper.state = kIdle;
					} else {
						// if we found the attribute and there are no more tags to
						// sweep for, then we need to immediately find what is in
						// the inner xml
						this->_parseHelper.state = kWaitToReadInnerXml;
					}
				} else {

					// If we did not find a match, then we need to continue on with
					// sweeping the raw content
					this->_parseHelper.state = kIdle;
				}

				xFree(this->_parseHelper.attrValue);
				xFree(this->_parseHelper.specAttrValue);
			} else {
				this->_parseHelper.result 	= xCopyString(this->_parseHelper.attrValue, &result);
				this->_parseHelper.finished	= xTrue;
			}
		}

		break;
	default:
		if (this->_parseHelper.quoteCount < 2) {
			tempString = xCharToString(
				this->_rawContent[this->_parseHelper.contentIndex],
				&result
			);

			result = xApendToString(&this->_parseHelper.attrValue, tempString);
			xFree(tempString);
		} else {
			result = kXMLError;
			DLog("Quote count is %d, which should not be more than 2\n", this->_parseHelper.quoteCount);
		}

		break;
	}

	return result;
}
