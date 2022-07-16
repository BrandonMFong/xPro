/*
 * Alias.hpp
 *
 *  Created on: Mar 15, 2022
 *      Author: brandonmfong
 */

#ifndef SRC_APPDRIVER_COMMANDS_ALIAS_ALIAS_HPP_
#define SRC_APPDRIVER_COMMANDS_ALIAS_ALIAS_HPP_

#include <xLib.h>
#include <AppDriver/Commands/Types/Dictionary.hpp>

class Alias : public Dictionary {
public:
	Alias(xError * err);
	virtual ~Alias();

	static xBool invoked();
	static void help();
	static const char * command();
	static const char * brief();

//protected:

//	xError HandleAliasCount(void);
//	xError HandleAliasIndex(void);
//	xError handleCount();
//	xError handleIndex();
};

#endif /* SRC_APPDRIVER_COMMANDS_ALIAS_ALIAS_HPP_ */
