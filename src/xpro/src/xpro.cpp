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

DWORD WINAPI InstanceThread(LPVOID param) {
	xError error = kNoError;
	HANDLE heapHandler = NULL;
	TCHAR * request = NULL;
	TCHAR * reply = NULL;
	DWORD bytesRead = 0;
	DWORD bytesReply = 0;
	DWORD bytesWritten = 0;
	HANDLE pipeHandler = NULL;
	BOOL success = FALSE;

	if (error == kNoError) {
		error = param != NULL ? kNoError : kNULLError;
	}

	if (error == kNoError) {
		heapHandler = GetProcessHeap();
		error 		= heapHandler != NULL ? kNoError : kProcessHeapError;
	}

	if (error == kNoError) {
		request = (TCHAR*) HeapAlloc(heapHandler, 0, kBufferSize * sizeof(TCHAR));
		error 	= request != NULL ? kNoError : kHeapRequestError;
	}

	if (error == kNoError) {
		reply = (TCHAR *) HeapAlloc(heapHandler, 0, kBufferSize * sizeof(TCHAR));
		error = reply != NULL ? kNoError : kHeapReplyError;
	}

	if (error == kNoError) {
		pipeHandler = (HANDLE) param;
		error = pipeHandler != NULL ? kNoError : kPipeError;
	}

	while (error == kNoError) {
		if (error == kNoError) {
			success = ReadFile(
				pipeHandler,
				request,
				kBufferSize * sizeof(TCHAR),
				&bytesRead,
				NULL
			);

			error = (success && (bytesRead != 0)) ? kNoError : kReadError;
		}

		if (error == kNoError) {
		    if (FAILED(StringCchCopy(reply, kBufferSize, TEXT("default answer from server"))))
		    {
		        bytesReply = 0;
		        reply[0] = 0;
		        DLog("StringCchCopy failed, no outgoing message.\n");
		        error = kWriteError;
		    }

		    success = WriteFile(
				pipeHandler,
				reply,
				bytesReply,
				&bytesWritten,
				NULL
			);

		    error = success ? kNoError : kWriteError;
		}
	}

	FlushFileBuffers(pipeHandler);
	DisconnectNamedPipe(pipeHandler);
	CloseHandle(pipeHandler);

	HeapFree(heapHandler, 0, request);
	HeapFree(heapHandler, 0, reply);

	printf("InstanceThread exiting.\n");

	return 1;
}
