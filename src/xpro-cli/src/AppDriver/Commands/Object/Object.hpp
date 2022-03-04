/*
 * Object.hpp
 *
 *  Created on: Mar 2, 2022
 *      Author: brandonmfong
 */

#ifndef SRC_APPDRIVER_COMMANDS_OBJECT_OBJECT_HPP_
#define SRC_APPDRIVER_COMMANDS_OBJECT_OBJECT_HPP_


#include <xLib.h>

/**
 * Path to list of objects in user config
 */
#define OBJECT_TAG_PATH "/xPro/Objects/Object"

/**
 * Path to object name
 */
#define OBJECT_NAME_TAG_PATH "/xPro/Objects/Object.name[%s]"

/**
 *	Prints out object based on arguments passed
 */
xError HandleObject(void);

/**
 * Prints total count of object nodes
 */
xError HandleObjectCount(void);

/**
 * Prints object at index
 */
xError HandleObjecValueForIndex(void);


#endif /* SRC_APPDRIVER_COMMANDS_OBJECT_OBJECT_HPP_ */
