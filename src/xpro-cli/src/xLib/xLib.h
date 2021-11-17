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
#include <xError.h>
#include "xLogger/xLog.h"
#include <xInt.h>
#include <xNull.h>
#include <xBool.h>
#include <xUtilities/xUtilities.h>
#include <xTests.h>

/// Classes
#ifdef __cplusplus

#include <xArguments/xArgs.hpp>
#include <xXML/xXML.hpp>

#endif // __cplusplus

#endif /* XLIB_H_ */
