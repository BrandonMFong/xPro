/*
 * xAssert.hpp
 *
 *  Created on: Sep 2, 2021
 *      Author: BrandonMFong
 */

#ifndef XASSERT_HPP_
#define XASSERT_HPP_

#ifdef __cplusplus
extern "C" {
#endif

//#include <cstdarg>
#include <stdarg.h> // TODO: how to read args in c
//#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>

#include <xBool.h>
#include <xNull.h>

#define RED "\033[1;31m"
#define GREEN "\033[0;32m"
#define NC "\033[0m"

/**
 * Displays results if value is false
 */
void xUTResults(const char * string, ...);

/**
 * Asserts that value has to be true
 */
void xAssert(xBool value, const char * string, ...);

/**
 * Asserts that value is NULL
 */
void xAssertNotNull(void * value, const char * string, ...);

#ifdef __cplusplus
}
#endif

#endif /* XASSERT_HPP_ */
