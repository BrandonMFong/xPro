/*
 * Object.hpp
 *
 *  Created on: Mar 2, 2022
 *      Author: brandonmfong
 */

#ifndef SRC_APPDRIVER_COMMANDS_OBJECT_OBJECT_HPP_
#define SRC_APPDRIVER_COMMANDS_OBJECT_OBJECT_HPP_

#include <xLib.h>
#include <AppDriver/Commands/Types/Dictionary.hpp>

class Object : public Dictionary {
public:
	Object(xError * err);
	virtual ~Object();

	static xBool invoked();
	static void help();
	static const char * command();
	static const char * brief();

protected:
	xError handleCount();
	xError handleIndex();
	
//	/**
//	 * Prints total count of object nodes
//	 */
//	xError HandleObjectCount(void);
//
//	/**
//	 * Prints object at index
//	 */
//	xError HandleObjectIndex(void);
};


#endif /* SRC_APPDRIVER_COMMANDS_OBJECT_OBJECT_HPP_ */
