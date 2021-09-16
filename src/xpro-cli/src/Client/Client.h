/*
 * Client.h
 *
 *  Created on: Aug 30, 2021
 *      Author: BrandonMFong
 */

#ifndef CLIENT_CLIENT_H_
#define CLIENT_CLIENT_H_

#include <windows.h>
#include <stdio.h>
#include <conio.h>
//#include <tchar.h>

/* xPro */
#include <xLib.h>

class Client {
public:
	Client(xError * err);
	virtual ~Client();
	xError readArgs(int argc, char ** argv);
	xError exec();
};

#endif /* CLIENT_CLIENT_H_ */
