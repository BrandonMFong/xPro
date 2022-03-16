/*
 * Utilities.h
 *
 *  Created on: Nov 29, 2021
 *      Author: brandonmfong
 */

#ifndef SRC_UTILITIES_UTILITIES_H_
#define SRC_UTILITIES_UTILITIES_H_

/// Version macro.  Must be defined in build
#ifndef VERSION

#define VERSION "Version Error"

#endif // VERSION

/// Build hash macro.  Defined in build
#ifndef BUILD

#define BUILD "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

#endif // VERSION

/// Length of the build has string
#define BUILD_HASH_LENGTH 40

#endif /* SRC_UTILITIES_UTILITIES_H_ */
