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
	kThreadError = 4,
	kProcessHeapError = 5,
	kHeapRequestError = 6,
	kHeapReplyError = 7,
	kReadError = 8,
	kWriteError = 9,
	kArgError = 10,
	kPipeDelayError = 11,
	kStringError = 12,
	kServerError = 13,
	kClientError = 14,
	kNodeObjectError = 15,
	kNodeError = 16,
	kStartNodeError = 17,
	xFlagError = 18,
	xSwitchError = 19,
	xRepeatedFlagError = 20,
} xError;


#endif /* XERROR_H_ */
