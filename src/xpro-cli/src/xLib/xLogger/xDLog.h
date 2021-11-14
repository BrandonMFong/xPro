/*
 * xDLog.h
 *
 *  Created on: Jul 24, 2021
 *      Author: BrandonMFong
 */

#ifndef XLOGGER_XDLOG_H_
#define XLOGGER_XDLOG_H_

#ifdef DEBUG
 #define DLog(...) printf(__VA_ARGS__);printf("\n")
#else
 #define DLog(...) /* Don't do anything in release builds */
#endif

#endif /* XLOGGER_XDLOG_H_ */
