/*
 * xLib.h
 *
 *  Created on: Jul 24, 2021
 *      Author: BrandonMFong
 */

#ifndef XLIB_H_
#define XLIB_H_

#if !defined(__USE_MINGW_ANSI_STDIO) || (__USE_MINGW_ANSI_STDIO != 1)
#define __USE_MINGW_ANSI_STDIO 1
#endif

/// xLib
#include <xPipe.h>
#include <xError.h>
#include <xLogger/xDLog.h>
#include <xInt.h>
#include <xNull.h>
#include <xBool.h>
#include <xUtilities/xUtilities.h>

/// Classes
#include <xArguments/xArgs.h>
#include <xXML/xXML.h>

/**
 * Use this to print test results.  It will also print the
 * function name. Will not print anything if we did not do
 * a test build
 */
#if defined(TESTING)

#define PRINT_TEST_RESULTS(result) printf("%s: [ %s ]\n", __func__, result ? "Pass" : "Fail");

#else

#define PRINT_TEST_RESULTS(result)

#endif

#endif /* XLIB_H_ */
