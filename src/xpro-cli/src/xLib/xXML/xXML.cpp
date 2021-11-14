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
//	char 	* result 			= xNull,
char 			* tagString 		= xNull,
			* tempString 		= xNull,
			* tempAttrString 	= xNull,
			* attrKey 			= xNull,
			* attrValue			= xNull,
			* specAttrValue		= xNull,
			** split 			= xNull;
//			* innerXml 			= xNull;
	xError 	error 				= kNoError;
	xUInt8 	splitSize 			= 0,
			quoteCount			= 0;
//	xUInt32 endTagCharRecord 	= 0;
//	xBool 	finished 			= xFalse,
			xBool attrValSpecified	= xFalse;

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
						this->_parseHelper.state = kReadAttributeKey;

						tempAttrString = split[1];

						if (tempAttrString == xNull) {
							error = kXMLError;
							DLog("NULL string for attribute\n");
						} else {
							// Make a copy of the string because we are going to free split's memory
							tempAttrString = xCopyString(tempAttrString, &error);
						}

						// We need to initialize the attrString if all succeeds
						if (error == kNoError) {
							attrKey = xCopyString("", &error);
						}
					} else if (splitSize == 1) {
						this->_parseHelper.state = kWaitToCloseTag;
					} else {
						error = kXMLError;
					}
				}

				if (split != xNull) {
					// Free memory because we do not need it
					for (xUInt8 i = 0; i < splitSize; i++) xFree(split[i]);
					xFree(split);
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

		// Gather the characters to form the attribute
		case kReadAttributeKey:
			switch (this->_rawContent[this->_parseHelper.contentIndex]) {
			case '=':
				attrValSpecified = xFalse;

				// See if (...) is in the string
				if (error == kNoError) {
					attrValSpecified = xContainsSubString(tempAttrString, "(", &error);
				}

				if (attrValSpecified && (error == kNoError)) {
					attrValSpecified = xContainsSubString(tempAttrString, ")", &error);
				}

				// If okayToContinue then we know the user specified an attribute value
				if (attrValSpecified) {
					if (error == kNoError) {
						specAttrValue = xStringBetweenTwoStrings(tempAttrString, "(", ")", &error);
					}

					// Reset the tempAttrString to remove the (...) string section
					if (error == kNoError) {
						split = xSplitString(tempAttrString, "(", &splitSize, &error);
					}

					if (error == kNoError) {
						if (splitSize == 2) {
							xFree(tempAttrString);
							tempAttrString = xCopyString(split[0], &error);
						} else {
							error = kXMLError;
							DLog("Error in attempting to split string. There may be an error in the syntax\n");
						}
					}

					if (split != xNull) {
						for (xUInt8 i = 0; i < splitSize; i++) xFree(split[i]);
						xFree(split);
					}
				}

				if (error == kNoError) {
					// If user specified the attribute in the path then we need to read the value.  Otherwise we will wait for the next tag
					if (!strcmp(tempAttrString, attrKey)) {
						// Set count to 0 so that we know when to stop reading
						// for the attribute string
						quoteCount = 0;

						xFree(attrKey);

						attrValue 					= xCopyString("", &error);
						this->_parseHelper.state 	= kReadAttributeValue;
					} else {
						this->_parseHelper.state = kWaitToCloseTag;
					}
				}

				xFree(tempAttrString);

				break;
			default:
				if (error == kNoError) {
					tempString = xCharToString(this->_rawContent[this->_parseHelper.contentIndex], &error);

					error = xApendToString(&attrKey, tempString);
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

				// If we found the entire attribute string then we will
				// need to determine what the next state is
				if (quoteCount == 2) {
					if (attrValSpecified) {
						// if we found the attribute, then we need to immediately find what is in the inner xml
						if (!strcmp(attrValue, specAttrValue)) {
							this->_parseHelper.state = kWaitToReadInnerXml;
						} else {

							// If we did not find a match, then we need to continue on with
							// sweeping the raw content
							this->_parseHelper.state = kIdle;
						}

						xFree(attrValue);
						xFree(specAttrValue);
					} else {
						this->_parseHelper.result 	= xCopyString(attrValue, &error);
						this->_parseHelper.finished	= xTrue;
					}
				}

				break;
			default:
				if (quoteCount < 2) {
					if (error == kNoError) {
						tempString = xCharToString(this->_rawContent[this->_parseHelper.contentIndex], &error);

						error = xApendToString(&attrValue, tempString);
						xFree(tempString);
					}
				} else {
					error = kXMLError;
					DLog("Quote count is %d, which should not be more than 2\n", quoteCount);
				}

				break;
			}

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

	xFree(attrValue);
	xFree(attrKey);
	xFree(tagString);
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
	xError result = kNoError;
	char * tempString = xNull;

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
