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
	kStringError = 1,
	kArgError = 2,
	kOutOfRangeError = 3,
} xError;


#endif /* XERROR_H_ */
