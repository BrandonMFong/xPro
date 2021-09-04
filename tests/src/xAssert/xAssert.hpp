/*
 * xAssert.hpp
 *
 *  Created on: Sep 2, 2021
 *      Author: BrandonMFong
 */

#ifndef XASSERT_HPP_
#define XASSERT_HPP_

#include <cstdarg>
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>

#define RED "\033[1;31m"
#define GREEN "\033[0;32m"
#define NC "\033[0m"

/**
 * Displays results if value is false
 */
void xUTResults(bool value, const char * string, ...);

/**
 * Asserts that value has to be true
 */
void xAssert(bool value, const char * string, ...);

/**
 * Asserts that value is NULL
 */
void xAssertNotNull(void * value, const char * string, ...);

#endif /* XASSERT_HPP_ */
