/*
 * xObject.h
 *
 *  Created on: Jul 24, 2021
 *      Author: BrandonMFong
 */

#ifndef XOBJECT_XOBJECT_H_
#define XOBJECT_XOBJECT_H_

#include <xError.h>

namespace xPro {

class xObject {
public:
	/**
	 * Constructor
	 */
	xObject();

	/**
	 * Destructor
	 */
	virtual ~xObject();

	/**
	 * Read-only _status
	 */
	const xError & status = _status;

protected:
	/**
	 * Status of the object, usually used to check
	 * if constructor successfully executed
	 */
	xError _status;
};

} /* namespace xPro */

#endif /* XOBJECT_XOBJECT_H_ */
