/*
 * xTests.h
 *
 *  Created on: Nov 14, 2021
 *      Author: brandonmfong
 */

#ifndef SRC_XLIB_XTESTS_H_
#define SRC_XLIB_XTESTS_H_

#include <xUtilities/xUtilities.h>

/**
 * Use this to print test results.  It will also print the
 * function name. Will not print anything if we did not do
 * a test build
 */
#if defined(TESTING)

#define INTRO_TEST_FUNCTION printf("Running %s:\n", __func__)
#define PRINT_TEST_RESULTS(result) \
	if (result) {system("printf \"[\033[0;32m Pass \033[0m] \"");}\
	else {system("printf \"[\033[0;31m Fail \033[0m] \"");}\
	printf("%s\n", __func__)

#else // defined(TESTING)

#define INTRO_TEST_FUNCTION
#define PRINT_TEST_RESULTS(result)

#endif // defined(TESTING)

#endif /* SRC_XLIB_XTESTS_H_ */
