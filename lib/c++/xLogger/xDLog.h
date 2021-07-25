/*
 * xDLog.h
 *
 *  Created on: Jul 24, 2021
 *      Author: BrandonMFong
 */

#ifndef XLOGGER_XDLOG_H_
#define XLOGGER_XDLOG_H_

#ifdef DEBUG
 #define DLog(fmt, args...) fprintf(stderr, "\nDEBUG: %s:%d:%s(): " fmt, \
    __FILE__, __LINE__, __func__, ##args)
#else
 #define DLog(fmt, args...) /* Don't do anything in release builds */
#endif

#endif /* XLOGGER_XDLOG_H_ */
