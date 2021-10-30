/*
 * xXML.hpp
 *
 *  Created on: Oct 30, 2021
 *      Author: brandonmfong
 */

#ifndef SRC_XLIB_XXML_XXML_H_
#define SRC_XLIB_XXML_XXML_H_

/// xPro
#include <xError.h>
#include <xNull.h>
#include <xUtilities/xUtilities.h>

/// System
#include <unistd.h>

class xXML {
public:
	/**
	 * Opens file and starts parsing through the xml file
	 */
	xXML(const char * path, xError * err);

	/**
	 *
	 */
	virtual ~xXML();

private:
	/**
	 * Path to the xml file
	 */
	char * _path;
};


#endif /* SRC_XLIB_XXML_XXML_H_ */
