/*
 * xClient.h
 *
 *  Created on: Jul 24, 2021
 *      Author: BrandonMFong
 */

#ifndef XIPC_XCLIENT_XCLIENT_H_
#define XIPC_XCLIENT_XCLIENT_H_

#include <xObject/xObject.h>

#define WIN32_LEAN_AND_MEAN

#include <windows.h>
#include <winsock2.h>
#include <ws2tcpip.h>
#include <stdlib.h>
#include <stdio.h>

#define DEFAULT_BUFLEN 512
#define DEFAULT_PORT "27015"

namespace xPro {

class xClient : public xObject {
public:
	xClient();
	virtual ~xClient();

	int run();
};

} /* namespace xPro */

#endif /* XIPC_XCLIENT_XCLIENT_H_ */
