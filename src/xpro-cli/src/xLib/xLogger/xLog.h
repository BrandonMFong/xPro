/*
 * xDLog.h
 *
 *  Created on: Jul 24, 2021
 *      Author: BrandonMFong
 */

#ifndef XLOGGER_XDLOG_H_
#define XLOGGER_XDLOG_H_

#ifdef DEBUG
 #define DLog(...) printf("xPro Debug: " __VA_ARGS__);printf("\n")
#else
 #define DLog(...) /* Don't do anything in non debug builds */
#endif

/**
 * Standard xpro print
 */
#define xLog(...) printf("xPro: " __VA_ARGS__);printf("\n")

/**
 * Prints labeled error
 */
#define xError(...) printf("xPro Error: " __VA_ARGS__);printf("\n")

#endif /* XLOGGER_XDLOG_H_ */