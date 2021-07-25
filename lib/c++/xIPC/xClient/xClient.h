/*
 * xClient.h
 *
 *  Created on: Jul 24, 2021
 *      Author: BrandonMFong
 */

#ifndef XIPC_XCLIENT_XCLIENT_H_
#define XIPC_XCLIENT_XCLIENT_H_

#include <xObject/xObject.h>

namespace xPro {

class xClient : public xObject {
public:
	xClient();
	virtual ~xClient();
};

} /* namespace xPro */

#endif /* XIPC_XCLIENT_XCLIENT_H_ */
