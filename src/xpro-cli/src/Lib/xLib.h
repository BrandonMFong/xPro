/*
 * xLib.h
 *
 *  Created on: Jul 24, 2021
 *      Author: BrandonMFong
 */

#ifndef XLIB_H_
#define XLIB_H_

#pragma mark - Headers

/// Standard lib
#include <libgen.h>

/// xLib
#include "../Lib/xError.h"
#include "../Lib/xInt.h"
#include "../Lib/xNull.h"
#include "../Lib/xBool.h"
#include "Utilities/Utilities.h"
#include "../Lib/xTests.h"

#ifdef __cplusplus

#include "../Lib/xClassDec.h"

/// Classes
#include "Arguments/Arguments.hpp"

#endif // __cplusplus

#pragma mark - Macros

/**
 * If TESTING is defined, we need to have the entry point be the tests
 */
#if defined(TESTING)

#define xMain 	xMain
#define xTests 	main

#else

#define xMain 	main
#define xTests 	xTests

#endif

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

#endif /* XLIB_H_ */
