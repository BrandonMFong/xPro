/*
 * xError.h
 *
 *  Created on: Jul 24, 2021
 *      Author: BrandonMFong
 */

#ifndef XERROR_H_
#define XERROR_H_


typedef enum {
	kUnknownError = -1,
	kNoError = 0,
	kNULLError = 1,
	kPipeError = 2,
	kPipeConnectionError = 3,
	kThreadError = 4
} xError;


#endif /* XERROR_H_ */
