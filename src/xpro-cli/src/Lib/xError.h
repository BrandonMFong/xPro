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
	kEmptyStringError = 4,
	kXMLError = 5,
	kDirectoryKeyError = 6,
	kOSError = 7,
	kFileError = 8,
	kReadError = 9,
	kFileContentError = 10,
	kSubStringError = 11,
	kHostnameError = 12,
	kSizeError = 13,
	kUserConfigPathError = 14,
	kDirectoryError = 15,
	kNullError = 16,
	kWriteError = 17,
	kDriverError = 18,
} xError;


#endif /* XERROR_H_ */
