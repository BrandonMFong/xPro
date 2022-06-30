/*
 * DLog.h
 *
 *  Created on: Mar 14, 2022
 *      Author: brandonmfong
 */

#ifndef SRC_UTILITIES_LOG_H_
#define SRC_UTILITIES_LOG_H_

#if defined(DEBUG) && !defined(TESTING)
 #define DLog(...) 	printf("xPro Debug");\
					printf(" (%s:%d)", __FILENAME__, __LINE__);\
					printf(": " __VA_ARGS__);\
					printf("\n")
#else
 #define DLog(...) /* Don't do anything in non debug builds */
#endif

/**
 * Standard xpro print
 */
#ifndef TESTING
#define Log(...) printf("xPro: " __VA_ARGS__);printf("\n")
#else
#define Log(...)
#endif
/**
 * Prints labeled error
 */
#ifndef TESTING
#define ELog(...) printf("xPro Error: " __VA_ARGS__);printf("\n")
#else
#define ELog(...)
#endif

#endif /* SRC_UTILITIES_LOG_H_ */
