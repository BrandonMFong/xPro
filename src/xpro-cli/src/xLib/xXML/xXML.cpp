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

			// When find the close tag, then go to the idle state
			// to wait for new start of tag
			case xPSWaitToCloseTag:
			case xPSNoAttributeMatch:
				this->parseWaitToCloseTag(xPSIdle);
				break;

			case xPSReadingTagString:
				error = this->parseTagString();
				break;

			case xPSFoundTag:
			case xPSFoundStuffedTag:
				this->_parseHelper.state = xPSWaitToCloseTag;

				// If we found the tag then we will increment count
				result++;

				// If we are here then parseTagString() found the last tag in the
				// tag path.  We need to make sure that if we are going to go through
				// the xml nodes again that we read for the same current tag string
				this->_parseHelper.arrayIndex--;
				break;

			case xPSWaitToCloseXmlDeclaration:
				this->waitToCloseXmlDeclaration();
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

			// When find the close tag, then go to the idle state
			// to wait for new start of tag
			case xPSWaitToCloseTag:
				this->parseWaitToCloseTag(xPSIdle);
				break;

			case xPSNoAttributeMatch:
				this->_parseHelper.state = xPSReadingTagString;
				break;

			// If we are ready to read the inner xml but are far away from
			// the '>' char, then we need to wait for it before
			// getting into kPrepareReadingInnerXml
			case xPSWaitToReadInnerXml:
				this->parseWaitToCloseTag(xPSFoundTag);
				break;

			case xPSWaitToCloseXmlDeclaration:
				this->waitToCloseXmlDeclaration();
				break;

			case xPSFoundStuffedTag:
				this->parseWaitToCloseTag(xPSFoundTag);
				break;

			case xPSFoundTag:
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
