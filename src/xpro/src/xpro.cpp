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

long unsigned int InstanceThread(void * param);

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
			DLog("Error %d", error);
		}
	}

	return (int) error;
}

long unsigned int InstanceThread(void * param) {
	xError 				error 			= kNoError;
	char * 				readBuffer 		= NULL;
	char * 				writeBuffer 	= NULL;
	long unsigned int 	bytesRead 		= 0;
	long unsigned int 	messageSize 	= 0;
	long unsigned int 	bytesWritten 	= 0;
	HANDLE 				pipeHandler 	= NULL;
	bool 				success 		= false;

	if (error == kNoError) {
		error = param != NULL ? kNoError : kNULLError;
	}

	if (error == kNoError) {
		pipeHandler = (HANDLE) param;
		error 		= pipeHandler != NULL ? kNoError : kPipeError;
	}

	if (error == kNoError) {
		readBuffer 	= (char *) malloc(sizeof(char) * kBufferSize);
		error 		= readBuffer != NULL ? kNoError : kNULLError;
	}

	if (error == kNoError) {
		writeBuffer = (char *) malloc(sizeof(char) * kBufferSize);
		error 		= writeBuffer != NULL ? kNoError : kNULLError;
	}

	while (error == kNoError) {
		if (error == kNoError) {
			success = ReadFile(
				pipeHandler,
				readBuffer,
				kBufferSize * sizeof(char),
				&bytesRead,
				NULL
			);

			error = (success && (bytesRead != 0)) ? kNoError : kReadError;
		}

		if (error == kNoError) {
			strcpy(writeBuffer, "Hello world! I did it!");
			error = !strcmp(writeBuffer, "Hello world! I did it!") ? kNoError : kStringError;
		}

		if (error == kNoError) {
			messageSize = (lstrlen(writeBuffer)+1) * sizeof(char);

		    success = WriteFile(
				pipeHandler,
				writeBuffer,
				messageSize,
				&bytesWritten,
				NULL
			);

		    error = success ? kNoError : kWriteError;
		}
	}

	FlushFileBuffers(pipeHandler);
	DisconnectNamedPipe(pipeHandler);
	CloseHandle(pipeHandler);

	free(readBuffer);
	free(writeBuffer);

	DLog("InstanceThread exiting.\n");

	return 1;
}
