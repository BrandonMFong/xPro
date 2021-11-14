/*
 * xXML.hpp
 *
 *  Created on: Oct 30, 2021
 *      Author: brandonmfong
 *
 *  documentation:
 *  	https://developer.mozilla.org/en-US/docs/Web/XML/XML_introduction
 *  	https://www.xmlfiles.com/xml/xml-syntax/
 *
 */

#ifndef SRC_XLIB_XXML_XXML_HPP_
#define SRC_XLIB_XXML_XXML_HPP_

/// xPro
#include <xError.h>
#include <xNull.h>
#include <xUtilities/xUtilities.h>

/// System
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

/**
 * Each element must be separate by a forward slash
 */
#define ELEMENT_PATH_SEP "/"

/**
 * Attributes must be denoted after an element path,
 * followed by a "."
 */
#define ATTRIBUTE_PATH_SEP "."


enum ParsingState {
	kIdle = 0,
	kReadingTagString = 1,
	kWaitToCloseTag = 2,
	kReadAttributeKey = 3,
	kReadAttributeValue = 4,
	kInnerXml = 5,
	kPrepareReadingInnerXml = 6,
	kWaitToReadInnerXml = 7
};

class xXML {
public:
	/**
	 * Opens file and reads the content in the file
	 */
	xXML(const char * path, xError * err);

	xXML(xError * err) : xXML(NULL, err) {};

	/**
	 *
	 */
	virtual ~xXML();

	/**
	 * Reads xml at file path
	 */
	xError read(const char * path);

	/**
	 * Returns value from element path
	 *
	 * elementPath syntax
	 * --------------------
	 * 	- 	Separate each element should be separated by forward slashes.  The
	 * 		first node needs to follow after one forward slash.
	 * 		- 	Example: /Root/Path/To/Element
	 * 		- 	The return value is the innerXml value.  That can be the
	 * 			element value or more xml
	 *	- 	When you want an attribute, follow the element path with a
	 *		'.' and the attribute name
	 *		- 	Example /Root/Path/To/Element.Attribute
	 *	- 	To get an inner xml from a specific attribute, enclose the attribute
	 *		inside parenthesis
	 *		- 	Example /Root/Path/To/Element.Attribute(value)
	 */
	char * getValue(
		const char *	elementPath,
		xError * 		err
	);

	/**
	 * Returns _path.  Caller should not attempt to free return value
	 */
	char * path() {
		return this->_path;
	}

	/**
	 * Copies rawContent to _rawContent  The user is still responsible for the value
	 */
	xError setContent(const char * rawContent);

private:

	/**
	 * Waits for '<' to appear at contentIndex
	 */
	void parseIdle();

	/**
	 * Waits for '>' to appear at contentIndex and then sets parsing state to nextState
	 */
	void parseWaitToCloseTag(ParsingState nextState);

	/**
	 * Path to the xml file
	 */
	char * _path;

	/**
	 * Raw text content of xml file
	 *
	 * We should be using this when we find values from a node path.  The memory should be set with malloc
	 */
	char * _rawContent;

	struct {
		void init(void) {
			this->tagPathArray 	= xNull;
			this->arraySize 	= 0;
			this->openTags 		= 0;
			this->contentIndex	= 0;
			this->state 		= kIdle;
			this->contentLength	= 0;
			this->arrayIndex	= 0;
		}

		xUInt8 arrayIndex;
		char ** tagPathArray;
		xUInt8 arraySize;
		xUInt64 contentIndex;
		xUInt64 contentLength;
		xUInt32 openTags;
		ParsingState state;
	} _parseHelper;
};


#endif /* SRC_XLIB_XXML_XXML_HPP_ */
