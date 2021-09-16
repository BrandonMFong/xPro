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
#include <xLinkedList/xLinkedList.h>

class Client {
public:
	Client(xError * err);
	virtual ~Client();
	xError exec();
private:

};

#endif /* CLIENT_CLIENT_H_ */
