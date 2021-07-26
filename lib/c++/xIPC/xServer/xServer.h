/*
 * xServer.h
 *
 *  Created on: Jul 24, 2021
 *      Author: BrandonMFong
 */

#ifndef XIPC_XSERVER_XSERVER_H_
#define XIPC_XSERVER_XSERVER_H_

#undef UNICODE

#define WIN32_LEAN_AND_MEAN

#include <windows.h>
#include <winsock2.h>
#include <ws2tcpip.h>
#include <stdlib.h>
#include <stdio.h>

#define DEFAULT_BUFLEN 512
#define DEFAULT_PORT "27015"

#include <xObject/xObject.h>
#include <xLogger/xDLog.h>

namespace xPro {

class xServer : public xObject {
public:
	/**
	 * Should initiate all the steps to create the socket connection
	 * up to listening
	 */
	xServer();

	/**
	 * Destruct
	 */
	virtual ~xServer();

	/**
	 * Bind to socket
	 */
	int run();
};

} /* namespace xPro */

#endif /* XIPC_XSERVER_XSERVER_H_ */
