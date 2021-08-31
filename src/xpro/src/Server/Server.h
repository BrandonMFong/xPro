/*
 * Server.h
 *
 *  Created on: Aug 30, 2021
 *      Author: BrandonMFong
 */

#ifndef SERVER_H_
#define SERVER_H_

#define STRSAFE_NO_DEPRECATE

/* Windows */
#include <windows.h>
#include <stdio.h>
#include <tchar.h>
#include <strsafe.h>

/* xPro */
#include <xLib.h>

class Server {
public:
	Server();
	virtual ~Server();
	xError Listen();
	xError HandleRequest(HANDLE pipe);
private:
	HANDLE _pipe;
};

#endif /* SERVER_H_ */
