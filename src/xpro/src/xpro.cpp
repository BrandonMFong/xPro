//============================================================================
// Name        : xPro.cpp
// Author      : 
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C++, Ansi-style
//============================================================================

#define STRSAFE_NO_DEPRECATE

/* Windows */
#include <windows.h>
#include <stdio.h>
#include <tchar.h>
#include <strsafe.h>

/* xPro */
#include <xLib.h>

#define kBufferSize 512
#define kPipename "\\\\.\\pipe\\mynamedpipe"

long unsigned int WINAPI InstanceThread(void * param);

int main() {
	xError 				error 			= kNoError;
	long unsigned int  	threadID 		= 0;
	HANDLE 				pipeHandler 	= INVALID_HANDLE_VALUE;
	HANDLE 				threadHandler 	= NULL;
	const char * 		pipeName 		= kPipename;

	while (error == kNoError) {
		if (error == kNoError) {
			pipeHandler = CreateNamedPipe(
				pipeName,					// pipe name
				PIPE_ACCESS_DUPLEX,       	// read/write access
				PIPE_TYPE_MESSAGE |       	// message type pipe
				PIPE_READMODE_MESSAGE |   	// message-read mode
				PIPE_WAIT,                	// blocking mode
				PIPE_UNLIMITED_INSTANCES, 	// max. instances
				kBufferSize,           		// output buffer size
				kBufferSize,               	// input buffer size
				0,                        	// client time-out
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
				(void *) pipeHandler,	// thread parameter
				0,                 		// not suspended
				&threadID				// returns thread ID
			);

			error = threadHandler != NULL ? kNoError : kThreadError;
		}

		// Close the thread because we are now done with it
		if (error == kNoError) {
			CloseHandle(threadHandler);
		} else {

		}
	}

	return (int) error;
}

long unsigned int WINAPI InstanceThread(void * param) {
	xError 				error 			= kNoError;
	HANDLE 				heapHandler 	= NULL;
	char * 				request 		= NULL;
	char * 				reply 			= NULL;
	long unsigned int 	bytesRead 		= 0;
	long unsigned int 	bytesReply 		= 0;
	long unsigned int 	bytesWritten 	= 0;
	HANDLE 				pipeHandler 	= NULL;
	bool 				success 		= false;

	if (error == kNoError) {
		error = param != NULL ? kNoError : kNULLError;
	}

	if (error == kNoError) {
		heapHandler = GetProcessHeap();
		error 		= heapHandler != NULL ? kNoError : kProcessHeapError;
	}

	if (error == kNoError) {
		request = (char *) HeapAlloc(heapHandler, 0, kBufferSize * sizeof(char));
		error 	= request != NULL ? kNoError : kHeapRequestError;
	}

//	if (error == kNoError) {
//		reply = (char *) HeapAlloc(heapHandler, 0, kBufferSize * sizeof(char));
//		error = reply != NULL ? kNoError : kHeapReplyError;
//	}

	if (error == kNoError) {
		pipeHandler = (HANDLE) param;
		error 		= pipeHandler != NULL ? kNoError : kPipeError;
	}

	if (error == kNoError) {
		reply = (char *) malloc(sizeof(char) * kBufferSize);
		error = reply != NULL ? kNoError : kNULLError;
	}

	while (error == kNoError) {
		if (error == kNoError) {
			success = ReadFile(
				pipeHandler,
				request,
				kBufferSize * sizeof(char),
				&bytesRead,
				NULL
			);

			error = (success && (bytesRead != 0)) ? kNoError : kReadError;
		}

		if (error == kNoError) {
			strcpy(reply, "Hello world! I did it!");
			error = !strcmp(reply, "Hello world! I did it!") ? kNoError : kStringError;
		}

//		if (error == kNoError) {
//		    if (FAILED(StringCchCopy(reply, kBufferSize, "Hello you fool!"))) {
//		        DLog("StringCchCopy failed, no outgoing message.\n");
//
//		        bytesReply 	= 0;
//		        reply[0] 	= 0;
//		        error	 	= kWriteError;
//		    }
//		}

		if (error == kNoError) {
		    bytesReply = (lstrlen(reply)+1) * sizeof(char);

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
	free(reply);

	DLog("InstanceThread exiting.\n");

	return 1;
}
