/*
 * xServer.h
 *
 *  Created on: Jul 24, 2021
 *      Author: BrandonMFong
 */

#ifndef XIPC_XSERVER_XSERVER_H_
#define XIPC_XSERVER_XSERVER_H_

#include <xObject/xObject.h>

namespace xPro {

class xServer : public xObject {
public:
	xServer();
	virtual ~xServer();
};

} /* namespace xPro */

#endif /* XIPC_XSERVER_XSERVER_H_ */
