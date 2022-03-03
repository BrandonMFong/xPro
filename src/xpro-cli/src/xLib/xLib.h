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
#include <xError.h>
#include <xLogger/xLog.h>
#include <xInt.h>
#include <xNull.h>
#include <xBool.h>
#include <xUtilities/xUtilities.h>
#include <xTests.h>

#ifdef __cplusplus

#include <xClassDec.h>

/// Classes
#include <xArguments/xArgs.hpp>
#include <xXML/xXML.hpp>

#endif // __cplusplus

#pragma mark - Macros

/**
 * If TESTING is defined, we need to have the entry point be the tests
 */
#if defined(TESTING)

#define xMain 	xMain
#define xTests 	main

/**
 * Define a test path and put path into this variable for unit tests to use
 */
static char testPath[MAX_PATH_LENGTH] __attribute__((unused));

#else

#define xMain 	main
#define xTests 	xTests

#endif

#endif /* XLIB_H_ */
