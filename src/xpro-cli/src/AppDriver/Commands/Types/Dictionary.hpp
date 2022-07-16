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
class Dictionary : Command {
public:
	Dictionary(xError * err);
	virtual ~Dictionary();
};

#endif /* SRC_APPDRIVER_COMMANDS_TYPES_DICTIONARY_HPP_ */
