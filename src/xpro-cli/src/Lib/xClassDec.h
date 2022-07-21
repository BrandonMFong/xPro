/*
 * xClassDec.h
 *
 *  Created on: Feb 8, 2022
 *      Author: brandonmfong
 */

#ifndef SRC_LIB_XCLASSDEC_H_
#define SRC_LIB_XCLASSDEC_H_

#ifdef TESTING

#define xPublic public
#define xPrivate public
#define xProtected public

#else

#define xPublic public
#define xPrivate private
#define xProtected protected

#endif

#endif /* SRC_LIB_XCLASSDEC_H_ */
