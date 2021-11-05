/*
 * Utilities.h
 *
 *  Created on: Nov 4, 2021
 *      Author: brandonmfong
 */

#ifndef SRC_UTILITIES_UTILITIES_H_
#define SRC_UTILITIES_UTILITIES_H_

#include <xLib.h>

#ifdef __cplusplus
extern "C" {
#endif // __cplusplus

/**
 * Returns the standard config file for user
 *
 * Caller is responsible for freeing memory
 */
char * ConfigFilePath(xError * err);

#ifdef __cplusplus
}
#endif // __cplusplus

#endif /* SRC_UTILITIES_UTILITIES_H_ */
