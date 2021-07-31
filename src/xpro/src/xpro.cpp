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

#define kBufferSize 512
#define kPipename "\\\\.\\pipe\\mynamedpipe"

DWORD WINAPI InstanceThread(LPVOID);

int main() {
	xError error = kNoError;
//	BOOL   connected = FALSE;
	DWORD  threadID = 0;
	HANDLE pipeHandler = INVALID_HANDLE_VALUE;
	HANDLE threadHandler = NULL;
	LPCTSTR lpszPipename = kPipename;

	while (error == kNoError) {
		if (error == kNoError) {
			pipeHandler = CreateNamedPipe(
				lpszPipename,             // pipe name
				PIPE_ACCESS_DUPLEX,       // read/write access
				PIPE_TYPE_MESSAGE |       // message type pipe
				PIPE_READMODE_MESSAGE |   // message-read mode
				PIPE_WAIT,                // blocking mode
				PIPE_UNLIMITED_INSTANCES, // max. instances
				kBufferSize,                  // output buffer size
				kBufferSize,                  // input buffer size
				0,                        // client time-out
				NULL
			);

			error = pipeHandler != INVALID_HANDLE_VALUE ? kNoError : kPipeError;
		}

		if (error == kNoError) {
			error = ConnectNamedPipe(pipeHandler, NULL) == true ? kNoError : kPipeConnectionError;

			if (error != kNoError) {
				CloseHandle(pipeHandler);
			}
		}

		if (error == kNoError) {
			threadHandler = CreateThread(
		            NULL,              		// no security attribute
		            0,                	 	// default stack size
		            InstanceThread,    		// thread proc
		            (LPVOID) pipeHandler,	// thread parameter
		            0,                 		// not suspended
		            &threadID);      		// returns thread ID

			error = threadHandler != NULL ? kNoError : kThreadError;
		}

		// Close the thread because we are now done with it
		if (error == kNoError) {
			CloseHandle(threadHandler);
		}
	}
}

DWORD WINAPI InstanceThread(LPVOID lpvParam) {
	return 1;
}
