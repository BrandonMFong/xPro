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

class xXML {
public:
	/**
	 * Opens file and reads the content in the file
	 */
	xXML(const char * path, xError * err);

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
	 *
	 * Return value is an array of values at path.  If no element was found,
	 * an error will be returned in the err pointer and function will return null.
	 *
	 * Caller is responsible for freeing the memory, use the size pointer to
	 * know how many strings there are to free
	 */
	char ** getValue(
		const char * 	elementPath,
		xUInt8 * 		size,
		xError * 		err
	);

	/**
	 * Returns _path.  Caller should not attempt to free return value
	 */
	char * path() {
		return this->_path;
	}

private:
	/**
	 * Path to the xml file
	 */
	char * _path;

	/**
	 * Raw text content of xml file
	 *
	 * We should be using this when we find values from a node path
	 */
	char * _rawContent;

	char * getStringInsideElementPath(const char * content, const char * elementPath, xError * err);
};


#endif /* SRC_XLIB_XXML_XXML_HPP_ */
