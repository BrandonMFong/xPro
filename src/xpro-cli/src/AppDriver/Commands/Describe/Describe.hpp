/*
 * Describe.hpp
 *
 *  Created on: Mar 5, 2022
 *      Author: brandonmfong
 */

#ifndef SRC_APPDRIVER_COMMANDS_DESCRIBE_DESCRIBE_HPP_
#define SRC_APPDRIVER_COMMANDS_DESCRIBE_DESCRIBE_HPP_

#include <xLib.h>
#include <AppDriver/Commands/Command.hpp>

class Describe : public Command {
public:
	Describe(xError * err);
	virtual ~Describe();
	xError exec();
	static xBool commandInvoked();
};

//xError HandleDescribe(void);


#endif /* SRC_APPDRIVER_COMMANDS_DESCRIBE_DESCRIBE_HPP_ */
