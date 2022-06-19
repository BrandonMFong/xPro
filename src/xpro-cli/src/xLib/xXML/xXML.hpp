
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
	 * Returns a value at nodepath
	 *
	 * nodePath should be /<value>/<value>/.../<value> and so on
	 * A <value> can be the name of the node, as well as the attribute
	 *
	 * <value>="node.attr(attrvalue)"
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
};


#endif /* SRC_XLIB_XXML_XXML_HPP_ */
