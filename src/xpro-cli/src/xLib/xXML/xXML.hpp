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

/**
 * States for parsing
 */
enum ParsingState {
	kIdle = 0,
	kReadingTagString = 1,
	kWaitToCloseTag = 2,
	kReadAttributeKey = 3,
	kReadAttributeValue = 4,
	kInnerXml = 5,
	kFoundTag = 6,
	kWaitToReadInnerXml = 7,
	kWaitToCloseXmlDeclaration = 8,
	kParseComment = 9,
	kNoAttributeMatch = 10,
	kNoAttributeMatchWithIdenticalTag = 11,
};

/**
 * Helps parse an xml file
 */
class xXML {
public:
	/**
	 * Opens file and reads the content in the file
	 */
	xXML(const char * path, xError * err);

	/**
	 * Passes null to path
	 */
	xXML(xError * err) : xXML(NULL, err) {};

	/**
	 *
	 */
	virtual ~xXML();

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
		const char *	tagPath,
		xError * 		err
	);

	/**
	 * Returns _path.  Caller should not attempt to free return value
	 */
	char * path() {
		return this->_path;
	}

	/**
	 * Counts the number of tags at tagPath
	 */
	xUInt64 countTags(const char * tagPath, xError * err);

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
	 * Prepare members in Parse helper to save inner xml
	 */
	xError parsePrepareToReadInnerXml();

	/**
	 * Reads inner xml into result
	 */
	xError parseReadInnerXml();

	/**
	 * Parses tag string
	 */
	xError parseTagString();

	/**
	 * Finds the attirbute key
	 */
	xError parseAttributeKey();

	/**
	 * Gets attribute value
	 */
	xError parseAttributeValue();

	/**
	 * Assuming this was called when the first '?' was found, this
	 * goes into the idle state when another '?' was found
	 */
	void waitToCloseXmlDeclaration();

	/**
	 * Inside '<!-- ... -->' will be parsed
	 */
	xError parseComment();

	/**
	 * Path to the xml file
	 */
	char * _path;

	/**
	 * Assists us in parsing
	 */
	struct {
		void init(void) {
			this->result			= xNull;
			this->tagPathArray 		= xNull;
			this->arraySize 		= 0;
			this->state 			= kIdle;
			this->arrayIndex		= 0;
			this->innerXml			= xNull;
			this->endTagCharRecord	= 0;
			this->finished			= xFalse;
			this->tagString			= xNull;
			this->attrKeyString 	= xNull;
			this->attrKey 			= xNull;
			this->attrValSpecified 	= xFalse;
			this->specAttrValue 	= xNull;
			this->quoteCount 		= 0;
			this->attrValue 		= xNull;
			this->insideXMLDec		= xFalse;
			this->dashCount			= 0;
			this->insideComment		= xFalse;
			this->bufferIndex		= 0;
			this->bufferLength		= 0;
			this->chBuf				= 0;
			this->filePtr			= xNull;
		}

		FILE * filePtr;

		/**
		 * Holds the current char
		 */
		char chBuf;

		/**
		 * True if inside <? ?>
		 */
		xBool insideXMLDec;

		/**
		 * Holds the current state of parsing
		 */
		ParsingState state;

		/**
		 * The amount of quotes found when reading attribute strings
		 */
		xUInt8 quoteCount;

		/**
		 * Holds attribute value from xml file
		 */
		char * attrValue;

		/**
		 * If attrValSpecified is true, then this variable will hold
		 * the value of the specified attribute value from the tagPathArray
		 */
		char * specAttrValue;

		/**
		 * True if user provided an attribute value in the tag path
		 */
		xBool attrValSpecified;

		/**
		 * Holds the value before = for an attribute
		 */
		char * attrKey;

		/**
		 * Attribute key from tag path
		 */
		char * attrKeyString;

		/**
		 * Holds the tag string from each node in the xml file
		 */
		char * tagString;

		/**
		 * If we found what we are looking for
		 */
		xBool finished;

		/**
		 * String result for path
		 */
		char * result;

		/**
		 * Current index to tagPathArray
		 */
		xUInt8 arrayIndex;

		/**
		 * Array of the tag path split at '/'
		 */
		char ** tagPathArray;

		/**
		 * Size of tagPathArray
		 */
		xUInt8 arraySize;

		/**
		 * Current index to _rawContent
		 */
		xUInt64 bufferIndex;

		/**
		 * Length of _rawContent
		 */
		xUInt64 bufferLength;

		/**
		 * Holds the content of the innerxml while in kInnerXml state
		 */
		char * innerXml;

		/**
		 * While getting the innerxml, we need to keep track of where we need
		 * to stop.  We do this by counting the number of open tags we come
		 * across while parsing
		 */
		xUInt32 endTagCharRecord;

		/**
		 * A record of the first '-' we see inside the comment state
		 */
		xUInt64 dashCount;

		/**
		 * If true, we are currently indexing inside a comment
		 */
		xBool insideComment;
	} _parseHelper;
};


#endif /* SRC_XLIB_XXML_XXML_HPP_ */
