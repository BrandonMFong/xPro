/*
 * Server.cpp
 *
 *  Created on: Aug 30, 2021
 *      Author: BrandonMFong
 */

#include "Server.h"

Server::Server(xError * err) {
	xError error = kNoError;

	if (err != NULL) {
		*err = error;
	}
}

Server::~Server() {
	// TODO Auto-generated destructor stub
}

xError Server::listen() {
	xError 			result 		= kNoError;
	HANDLE 			pipeHandler = INVALID_HANDLE_VALUE;
	const char *	pipeName 	= kPipename;

	while (result == kNoError) {
		if (result == kNoError) {
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

			result = pipeHandler != INVALID_HANDLE_VALUE ? kNoError : kPipeError;
		}

		if (result == kNoError) {
			result = ConnectNamedPipe(pipeHandler, NULL) == true ? kNoError : kPipeConnectionError;

			if (result != kNoError) {
				CloseHandle(pipeHandler);
			}
		}

		if (result == kNoError) {
			result = this->handleRequest(pipeHandler);
		}

		if (pipeHandler != INVALID_HANDLE_VALUE) {
			FlushFileBuffers(pipeHandler);
			DisconnectNamedPipe(pipeHandler);
			CloseHandle(pipeHandler);
		}
	}

	if (result != kNoError) {
		DLog("Error %d", result);
	}

	return result;
}

xError Server::handleRequest(HANDLE pipe) {
	xError 				result 			= kNoError;
	char * 				readBuffer 		= NULL;
	char * 				writeBuffer 	= NULL;
	bool 				success 		= false;
	long unsigned int 	bytesRead 		= 0;
	long unsigned int 	messageSize 	= 0;
	long unsigned int 	bytesWritten 	= 0;

	if (result == kNoError) {
		result = pipe != NULL ? kNoError : kPipeError;
	}

	if (result == kNoError) {
		readBuffer 	= (char *) malloc(sizeof(char) * kBufferSize);
		result 		= readBuffer != NULL ? kNoError : kNULLError;
	}

	if (result == kNoError) {
		writeBuffer = (char *) malloc(sizeof(char) * kBufferSize);
		result 		= writeBuffer != NULL ? kNoError : kNULLError;
	}

	if (result == kNoError) {
		success = ReadFile(
			pipe,
			readBuffer,
			kBufferSize * sizeof(char),
			&bytesRead,
			NULL
		);

		result = (success && (bytesRead != 0)) ? kNoError : kReadError;
	}

	if (result == kNoError) {
		strcpy(writeBuffer, "Hello world! I did it!");
		result = !strcmp(writeBuffer, "Hello world! I did it!") ? kNoError : kStringError;
	}

	if (result == kNoError) {
		messageSize = (lstrlen(writeBuffer)+1) * sizeof(char);

	    success = WriteFile(
			pipe,
			writeBuffer,
			messageSize,
			&bytesWritten,
			NULL
		);

	    result = success ? kNoError : kWriteError;
	}

	if (readBuffer != NULL) {
		free(readBuffer);
	}

	if (writeBuffer != NULL) {
		free(writeBuffer);
	}

	return result;
}
