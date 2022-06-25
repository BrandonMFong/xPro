
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

#include "RapidXml/rapidxml.hpp"
#include <xClassDec.h>
#include <xError.h>
#include <iosfwd>
#include <string>

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
 * Helps parse an xml file
 */
class xXML {
xPublic:

	/**
	 * Saves file path and initializes file stream
	 */
	xXML(const char * path, xError * err);

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
	char * getValue(const char * nodePath, xError * err);

xPrivate:

	/**
	 * Holds the path to the xml file
	 */
	char * _path;

	/**
	 * This is the main parser
	 */
	rapidxml::xml_document<> _xmldoc;

	/**
	 * Holds the file stream for the file pointed by _path
	 */
	std::ifstream * _xmlStream;

	std::string _buffer;
};


#endif /* SRC_XLIB_XXML_XXML_HPP_ */
