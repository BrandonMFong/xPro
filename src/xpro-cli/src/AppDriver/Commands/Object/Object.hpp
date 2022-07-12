/*
 * Object.hpp
 *
 *  Created on: Mar 2, 2022
 *      Author: brandonmfong
 */

#ifndef SRC_APPDRIVER_COMMANDS_OBJECT_OBJECT_HPP_
#define SRC_APPDRIVER_COMMANDS_OBJECT_OBJECT_HPP_

#include <xLib.h>
#include <AppDriver/Commands/Command.hpp>

class Object : public Command {
public:
	Object(xError * err);
	virtual ~Object();
	xError exec();
	static xBool commandInvoked();
	static void help();

protected:
	
	/**
	 * Prints total count of object nodes
	 */
	xError HandleObjectCount(void);

	/**
	 * Prints object at index
	 */
	xError HandleObjectIndex(void);
};


#endif /* SRC_APPDRIVER_COMMANDS_OBJECT_OBJECT_HPP_ */
