//============================================================================
// Name        : xpro-cli.cpp
// Author      : 
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C++, Ansi-style
//============================================================================

#include <iostream>
#include <xLib.h>
#include <xIPC/xClient/xClient.h>

int main(int argc, char **argv) {
	xPro::xClient * client = new xPro::xClient();

	client->run();
}
