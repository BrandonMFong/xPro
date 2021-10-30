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

#ifndef SRC_XLIB_XXML_XXML_H_
#define SRC_XLIB_XXML_XXML_H_

/// xPro
#include <xError.h>
#include <xNull.h>
#include <xUtilities/xUtilities.h>

/// System
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

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
};


#endif /* SRC_XLIB_XXML_XXML_H_ */
