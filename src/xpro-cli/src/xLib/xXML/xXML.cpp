/*
 * xXML.cpp
 *
 *  Created on: Oct 30, 2021
 *      Author: brandonmfong
 */

#include <xXML/xXML.hpp>

xXML::xXML(const char * path, xError * err) {
	xError error = kNoError;

	this->_path = xNull;

	// Read contents of file into rawContent
	if (path != xNull) {
		this->_path = xCopyString(path, &error);
	}

	if (err != xNull) {
		*err = error;
	}
}

xXML::~xXML() {
	xFree(this->_path);
}

xUInt64 xXML::countTags(
	const char * 	tagPath,
	xError *		err
) {
	xUInt64 result 			= 0;
	xError 	error 			= kNoError;
	xBool 	okayToContinue 	= xTrue;

	if (tagPath == xNull) {
		error = kStringError;
	} else {
		this->_parseHelper.init();

		this->_parseHelper.arrayIndex = 1; // Set it to 1

		this->_parseHelper.tagPathArray = xSplitString(
			tagPath,
			ELEMENT_PATH_SEP,
			&this->_parseHelper.arraySize,
			&error
		);
	}

	if (error == kNoError) {
		this->_parseHelper.filePtr = fopen(this->_path, "r");
		if (this->_parseHelper.filePtr == xNull) {
			error = kFileError;
		} else {
			// Set to the beginning of the file
			fseek(this->_parseHelper.filePtr, 0, SEEK_SET);
		}
	}

	if (error == kNoError) {
		// Init empty string
		this->_parseHelper.tagString = xCopyString("", &error);
	}

	while (		okayToContinue
			&& 	(error == kNoError)
			&& 	(this->_parseHelper.arrayIndex <= this->_parseHelper.arraySize)
			&& 	!this->_parseHelper.finished
	) {
		this->_parseHelper.chBuf 	= fgetc(this->_parseHelper.filePtr);
		okayToContinue 				= !feof(this->_parseHelper.filePtr);

		if (okayToContinue) {
			switch (this->_parseHelper.state) {
			case xPSIdle:
				this->parseIdle();
				break;

			// When find the close tag, then go to the idle state to wait for new start of tag
			case xPSWaitToCloseTag:
			case xPSNoAttributeMatch:
				this->parseWaitToCloseTag(xPSIdle);
				break;

			case xPSReadingTagString:
				error = this->parseTagString();
				break;

//			case xPSNoAttributeMatchWithIdenticalTag:
//				this->_parseHelper.state = xPSWaitToCloseTag;
//
//				// If we found the tag then we will increment count
//				result++;
//
//				break;

//			case xPSNoAttributesMatchWithIdenticalTag:
			case xPSFoundTag:
				this->_parseHelper.state = xPSWaitToCloseTag;

				// If we found the tag then we will increment count
				result++;

				// If we are here then parseTagString() found the last tag in the
				// tag path.  We need to make sure that if we are going to go through
				// the xml nodes again that we read for the same current tag string
				this->_parseHelper.arrayIndex--;
				break;

			default:
				break;
			}
		}
	}

	// Close the file
	if (this->_parseHelper.filePtr != xNull) fclose(this->_parseHelper.filePtr);

	if (err != xNull) {
		*err = error;
	}

	return result;
}

char * xXML::getValue(
	const char * 	tagPath,
	xError * 		err
) {
	xError 	error 			= kNoError;
	xBool 	okayToContinue 	= xTrue;

	if (tagPath == xNull) {
		error = kStringError;
	} else {
		this->_parseHelper.init();

		this->_parseHelper.arrayIndex = 1; // Set it to 1

		this->_parseHelper.tagPathArray = xSplitString(
			tagPath,
			ELEMENT_PATH_SEP,
			&this->_parseHelper.arraySize,
			&error
		);
	}

	if (error == kNoError) {
		this->_parseHelper.filePtr = fopen(this->_path, "r");
		if (this->_parseHelper.filePtr == xNull) {
			error = kFileError;
		} else {
			// Set to the beginning of the file
			fseek(this->_parseHelper.filePtr, 0, SEEK_SET);
		}
	}

	if (error == kNoError) {
		// Init empty string
		this->_parseHelper.tagString = xCopyString("", &error);
	}

	while (		okayToContinue
			&& 	(error == kNoError)
			&& 	(this->_parseHelper.arrayIndex <= this->_parseHelper.arraySize)
			&& 	!this->_parseHelper.finished
	) {
		this->_parseHelper.chBuf 	= fgetc(this->_parseHelper.filePtr);
		okayToContinue 				= !feof(this->_parseHelper.filePtr);

		if (okayToContinue) {
			switch (this->_parseHelper.state) {
			case xPSIdle:
				this->parseIdle();
				break;

			// When find the close tag, then go to the idle state to wait for new start of tag
			case xPSWaitToCloseTag:
				this->parseWaitToCloseTag(xPSIdle);
				break;

			case xPSNoAttributeMatch:
				this->parseWaitToCloseTag(xPSIdle);
				break;

			// If we are ready to read the inner xml but are far away from
			// the '>' char, then we need to wait for it before getting into kPrepareReadingInnerXml
			case xPSWaitToReadInnerXml:
				this->parseWaitToCloseTag(xPSFoundTag);
				break;

			case xPSWaitToCloseXmlDeclaration:
				this->waitToCloseXmlDeclaration();
				break;

			case xPSFoundTag:
//				error = this->parsePrepareToReadInnerXml();
				this->parseWaitToCloseTag(xPSPrepareToReadInnerXml);
				break;

			case xPSPrepareToReadInnerXml:
				error = this->parsePrepareToReadInnerXml();
				break;

			case xPSInnerXml:
				error = this->parseReadInnerXml();
				break;

			case xPSReadingTagString:
				error = this->parseTagString();
				break;

			// Gather the characters to form the attribute
			case xPSReadAttributeKey:
				error = this->parseAttributeKey();
				break;

			// Get the attribute value inside quotes
			case xPSReadAttributeValue:
				error = this->parseAttributeValue();
				break;

			case xPSParseComment:
				error = this->parseComment();
				break;

//			case xPSNoAttributeMatchWithIdenticalTag:
//				this->_parseHelper.state = xPSWaitToCloseTag;
//
//				break;

			default:
				error = kXMLError;
				DLog(
					"State %d not considered, will error out",
					this->_parseHelper.state
				);

				break;
			}
		}
	}

	if (error != kNoError) {
		DLog("There was an error during parsing, %d", error);
	}

	if (this->_parseHelper.tagPathArray != xNull) {
		for (xUInt8 i = 0; i < this->_parseHelper.arraySize; i++)
			xFree(this->_parseHelper.tagPathArray[i]);

		xFree(this->_parseHelper.tagPathArray);
	}

	xFree(this->_parseHelper.attrValue);
	xFree(this->_parseHelper.attrKey);
	xFree(this->_parseHelper.tagString);
	xFree(this->_parseHelper.innerXml);

	// Close the file
	if (this->_parseHelper.filePtr != xNull) fclose(this->_parseHelper.filePtr);

	if (err != xNull) {
		*err = error;
	}

	return this->_parseHelper.result;
}

void xXML::parseIdle(void) {
	if (this->_parseHelper.chBuf == '<') {
		this->_parseHelper.state = xPSReadingTagString;
	}
}

void xXML::parseWaitToCloseTag(xParsingState nextState) {
	if (this->_parseHelper.chBuf == '>') {
		this->_parseHelper.state = nextState;
	}
}

void xXML::waitToCloseXmlDeclaration() {
	if (this->_parseHelper.chBuf == '?') {
		this->_parseHelper.state = xPSIdle;
	}
}

xError xXML::parsePrepareToReadInnerXml() {
	xError result 		= kNoError;
	char * tempString 	= xNull;

	// Init to one
	this->_parseHelper.endTagCharRecord = 1;

	if (this->_parseHelper.chBuf == '<') {
		this->_parseHelper.endTagCharRecord++;
	}

	// Initialize innerXml string
	xFree(this->_parseHelper.innerXml);
	this->_parseHelper.innerXml = xCopyString("", &result);

	if (result == kNoError) {
		tempString = xCharToString(this->_parseHelper.chBuf, &result);
	}

	if (result == kNoError) {
		result = xApendToString(&this->_parseHelper.innerXml, tempString);
		xFree(tempString);
	}

	// If we are here and we have went through the whole tag
	// array, then we need to immediately go record the inner xml
	this->_parseHelper.state = xPSInnerXml;

	return result;
}

xError xXML::parseReadInnerXml() {
	xError 	result 			= kNoError;
	char * 	tempString 		= xNull;
	long 	currentPosition = 0;
	char 	nextChar = 0;

	if (this->_parseHelper.filePtr != xNull) {
		currentPosition = ftell(this->_parseHelper.filePtr);

		// Get the next char
		nextChar = fgetc(this->_parseHelper.filePtr);
	}

	// Make sure we are not out of range
	if (!feof(this->_parseHelper.filePtr)) {
		if (this->_parseHelper.chBuf == '<') {
			if (nextChar == '/') {
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
				this->_parseHelper.chBuf,
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

	// Set file position back
	if (this->_parseHelper.filePtr != xNull)
		fseek(this->_parseHelper.filePtr, currentPosition, SEEK_SET);

	return result;
}

xError xXML::parseTagString() {
	xError 	result 				= kNoError;
	char 	* tempString 		= xNull,
			** split 			= xNull,
			* strippedString 	= xNull;
	xUInt8 	splitSize 			= 0;
	xUInt8	index 				= 0;
	xBool 	foundIndex			= xFalse;

	// Add to tag string if are still sweeping tag
	switch (this->_parseHelper.chBuf) {
	case '!':
		// Initialize the flag
		this->_parseHelper.insideComment 	= xFalse;
		this->_parseHelper.dashCount		= 0;
		this->_parseHelper.state 			= xPSParseComment;
		break;
	// If we entered an xml declaration
	case '?':
		this->_parseHelper.state = xPSWaitToCloseXmlDeclaration;
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
			if (splitSize >= 2) {
				this->_parseHelper.state = xPSReadAttributeKey;

				this->_parseHelper.attrKeyString = split[1];

				if (this->_parseHelper.attrKeyString == xNull) {
					result = kXMLError;
					DLog("NULL string for attribute");
				} else {
					// Make a copy of the string because we are going to free split's memory
					this->_parseHelper.attrKeyString = xCopyString(
						this->_parseHelper.attrKeyString,
						&result
					);
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

			// If received 1 then there is no attribute specified for
			// this tag in tag path.  If there is an attribute specified
			// for this node, then the user needs specify the attribute
			// in the tag path
			} else if (splitSize == 1) {
				// If the split was only 1, then we can see if that string is the
				// tag. If the string is the tag string then we need to change to
				// a specific state that shows we found the tag but the attribute
				// does not match.  We do not increment the arrayIndex because we
				// do not need to continue if the user did not specify an attribute
				if (!strcmp(this->_parseHelper.tagString, tempString)) {
					this->_parseHelper.arrayIndex++;
					this->tagMatch();
				} else {
					this->_parseHelper.state = xPSNoAttributeMatch;
				}

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

	// Compare tag string with the strings in array
	case '>': // end of tag
	case '/': // start of the end of a tag
		tempString = this->_parseHelper.tagPathArray[this->_parseHelper.arrayIndex];

		// If the tag path has a '[' then we need to extract
		// the base path and the index number
		if (xContainsSubString(tempString, "[", &result)) {
			if (result == kNoError) {
				result = xXML::stripIndexLeafTagPath(
					tempString,
					&strippedString,
					&index
				);

				if (result == kNoError) {
					foundIndex = xTrue;
					tempString = strippedString;
				} else {
					foundIndex = xFalse;
				}
			}
		}

		if (result == kNoError) {
			if (!strcmp(tempString, this->_parseHelper.tagString)) {
				if (foundIndex) {
					if (this->_parseHelper.indexPathIndex == index) {
						this->_parseHelper.indexPathIndex = 0;
						this->_parseHelper.arrayIndex++;
					} else {
						this->_parseHelper.indexPathIndex++;
					}
				} else {
					// If we found a tag from the tag path then increment the array index
					this->_parseHelper.arrayIndex++;
				}

				this->tagMatch();
			} else {
				if (this->_parseHelper.chBuf == '/') {
					// Wait for not to finish
					this->_parseHelper.state = xPSWaitToCloseTag;
				}
			}
		}

		tempString = xNull;
		xFree(strippedString);

		// Reset the tag string
		xFree(this->_parseHelper.tagString);
		this->_parseHelper.tagString = xCopyString("", &result);

		break;
	default:
		tempString = xCharToString(
			this->_parseHelper.chBuf,
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

void xXML::tagMatch() {
	if ((this->_parseHelper.chBuf == ' ') || (this->_parseHelper.chBuf == '>')) {
		// If we reached the end of the tag array, we need to start reading the inner xml
		if (this->_parseHelper.arrayIndex == this->_parseHelper.arraySize) {
			// If we found an tag followed by a space indicating an attribute
			// we will say we found tag. If we are at the end of
			// a node then we need to immediately prepare to read
			// the inner xml
			if (this->_parseHelper.chBuf == ' ') {
				this->_parseHelper.state = xPSFoundTag;
			} else if (this->_parseHelper.chBuf == '>') {
				this->_parseHelper.state = xPSPrepareToReadInnerXml;
			}
		} else {
			// Go to idle
			this->_parseHelper.state = xPSIdle;
		}
	} else if (this->_parseHelper.chBuf == '/') {
		// Wait for not to finish
		this->_parseHelper.state = xPSWaitToCloseTag;

//	// If we are currently inside a node and currently looking through a tag
//	} else if (this->_parseHelper.chBuf == ' ') {
//		this->_parseHelper.state = xPSNoAttributeMatchWithIdenticalTag;
	} else {
		this->_parseHelper.state = xPSWaitToCloseTag;
	}
}

xError xXML::stripIndexLeafTagPath(
	const char 	* indexTag,
	char 		** tag,
	xUInt8 		* index
) {
	xError 	result 			= kNoError;
	char 	** splitString 	= xNull,
			* tempString 	= xNull;
	xUInt8 	splitSize 		= 0;

	if (result == kNoError) {
		if (tag == xNull) {
			result = kNullError;
			DLog("Tag string should not be null");
		}
	}

	if (result == kNoError) {
		if (index == xNull) {
			result = kNullError;
			DLog("Caller must provided a pointer to index");
		}
	}

	if (result == kNoError) {
		splitString = xSplitString(
			indexTag,
			"[",
			&splitSize,
			&result
		);
	}

	if (result == kNoError) {
		if (splitSize != 2) {
			result = kSizeError;
			DLog(
				"Split size value is unexpected: %d",
				splitSize
			);
		}
	}

	// Get the base tag without the index
	if (result == kNoError) {
		*tag = xCopyString(splitString[0], &result);
	}

	// Get the rest of the string
	if (result == kNoError) {
		tempString = xCopyString(splitString[1], &result);
	}

	if (result == kNoError) {
		for (xUInt8 i = 0; i < splitSize; i++) xFree(splitString[i]);

		splitString = xSplitString(
			tempString,
			"]",
			&splitSize,
			&result
		);
	}

	if (result == kNoError) {
		xFree(tempString);

		tempString = xCopyString(splitString[0], &result);
	}

	if (result == kNoError) {
		*index = atoi(tempString);
		xFree(tempString);
	}

	return result;
}

xError xXML::parseAttributeKey() {
	xError 	result 			= kNoError;
	char 	* tempString 	= xNull,
			** split 		= xNull;
	xUInt8 	splitSize 		= 0;

	switch (this->_parseHelper.chBuf) {
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
				this->_parseHelper.state 		= xPSReadAttributeValue;
			} else {
				this->_parseHelper.state = xPSWaitToCloseTag;
			}
		}

		xFree(this->_parseHelper.attrKeyString);

		break;
	default:
		tempString 	= xCharToString(this->_parseHelper.chBuf, &result);
		result 		= xApendToString(&this->_parseHelper.attrKey, tempString);

		xFree(tempString);

		break;
	}

	return result;
}

xError xXML::parseAttributeValue() {
	xError result 		= kNoError;
	char * tempString 	= xNull;

	switch (this->_parseHelper.chBuf) {
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
						this->_parseHelper.state = xPSIdle;
					} else {
						// if we found the attribute and there are no more tags to
						// sweep for, then we need to immediately find what is in
						// the inner xml
						this->_parseHelper.state = xPSWaitToReadInnerXml;
					}
				} else {

					// If we did not find a match, then we need to continue on with
					// sweeping the raw content
					this->_parseHelper.state = xPSIdle;
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
				this->_parseHelper.chBuf,
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

xError xXML::parseComment() {
	xError result = kNoError;

	// See if we are entering or exiting a comment
	if (this->_parseHelper.chBuf == '-') {
		// If we found two consecutive '-'s then we are either entering or existing
		// a comment
		if (this->_parseHelper.dashCount < 2) {
			this->_parseHelper.dashCount++;
		}
	} else {
		this->_parseHelper.dashCount = 0;
	}

	// If we found two dashes, then we invert the 'insideComment' flag
	if (this->_parseHelper.dashCount == 2) {
		this->_parseHelper.insideComment = ~this->_parseHelper.insideComment;
	} else {
		// If we are inside a comment, then we can do something with it.  At the
		// momment I do not see a need to do so.  We will just leave this if block
		// void but future implementations should live here
		if (this->_parseHelper.insideComment) {

		} else {
			// If we are not inside the comment and we found '>' then we are
			// done with the parsing comment state
			if (this->_parseHelper.chBuf == '>') {
				this->_parseHelper.state = xPSIdle;
			}
		}
	}

	return result;
}
