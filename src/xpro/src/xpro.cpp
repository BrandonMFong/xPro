//============================================================================
// Name        : xPro.cpp
// Author      : 
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C++, Ansi-style
//============================================================================

/* Windows */
#include <windows.h>
#include <stdio.h>
#include <tchar.h>
#include <strsafe.h>

/* xPro */
#include <xLib.h>

#define BUFSIZE 512
#define kPipename "\\\\.\\pipe\\mynamedpipe"

int main() {
	xError error = kNoError;
	BOOL   connected = FALSE;
	DWORD  dwThreadId = 0;
	HANDLE pipeHandler = INVALID_HANDLE_VALUE;
	HANDLE hThread = NULL;
	LPCTSTR lpszPipename = kPipename;

	if (error == kNoError) {
		while (true) {
			pipeHandler = CreateNamedPipe(
			          lpszPipename,             // pipe name
			          PIPE_ACCESS_DUPLEX,       // read/write access
			          PIPE_TYPE_MESSAGE |       // message type pipe
			          PIPE_READMODE_MESSAGE |   // message-read mode
			          PIPE_WAIT,                // blocking mode
			          PIPE_UNLIMITED_INSTANCES, // max. instances
			          BUFSIZE,                  // output buffer size
			          BUFSIZE,                  // input buffer size
			          0,                        // client time-out
			          NULL);
		}
	}
}
