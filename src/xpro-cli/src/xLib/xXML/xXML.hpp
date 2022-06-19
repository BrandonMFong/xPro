
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
 * Helps parse an xml file
 */
class xXML {
xPublic:

	xXML(const char * path, xError * err);

	virtual ~xXML();

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
