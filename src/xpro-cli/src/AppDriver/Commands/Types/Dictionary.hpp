/*
 * Dictionary.hpp
 *
 *  Created on: Jul 15, 2022
 *      Author: brandonmfong
 */

#ifndef SRC_APPDRIVER_COMMANDS_TYPES_DICTIONARY_HPP_
#define SRC_APPDRIVER_COMMANDS_TYPES_DICTIONARY_HPP_

#include <AppDriver/Commands/Command.hpp>

/**
 * This is an abstract class that should define xPro configs like
 * Alias, Object, and Dictionary since they behave in a key to value
 * way
 */
class Dictionary : public Command {
public:
	Dictionary(xError * err);
	virtual ~Dictionary();
	xError exec();
	virtual xError handleCount();
	virtual xError handleIndex();

	static const char * countArg();
	static const char * indexArg();
	static const char * valueArg();
	static const char * keyArg();

protected:
	/**
	 * Derived classes must set this variable
	 */
	char _baseNodeString[50];

	/**
	 * Derived classes must set this variable
	 */
	char _individualNodeString[50];
};

#endif /* SRC_APPDRIVER_COMMANDS_TYPES_DICTIONARY_HPP_ */
