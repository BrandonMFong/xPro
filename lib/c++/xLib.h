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

/// Std Library
#include <stdio.h>

/// xLib
#include <xPipe.h>
#include <xError.h>
#include <xLogger/xDLog.h>
#include <xIntType.h>
#include <xNull.h>
#include <xBool.h>

#ifdef __cplusplus

/// Objects
#include <xObject/xObject.h>

#endif // __cplusplus

#endif /* XLIB_H_ */
