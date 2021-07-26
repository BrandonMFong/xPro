//============================================================================
// Name        : xpro.cpp
// Author      : 
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C++, Ansi-style
//============================================================================

#include <Driver/Driver.h>
#include <xIPC/xIPC.h>

int main() {
	xPro::xServer * server = new xPro::xServer;

	server->run();
}
