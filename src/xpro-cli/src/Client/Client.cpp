/*
 * Client.cpp
 *
 *  Created on: Aug 30, 2021
 *      Author: BrandonMFong
 */

#include "Client.h"

Client::Client(xError * err) {
	xError error = kNoError;

	if (err != xNull) {
		*err = error;
	}
}

Client::~Client() {
	// TODO Auto-generated destructor stub
}

xError Client::readArgs(int argc, char ** argv) {
	xError result = kNoError;
	xLinkedList * argsList = xNull;
	char * tempArgString = xNull;

	// Save args into a list

	if (result == kNoError) {
		argsList = new xLinkedList;
		result = argsList != xNull ? kNoError : kNULLError;
	}

	if (result == kNoError) {
		for (xUInt8 i = 0; i < argc; i++) {
			if (result == kNoError) {
				tempArgString = (char *) malloc(sizeof(char));
			}

			if (result != kNoError) {
				break;
			}
		}
	}

	return result;
}

xError Client::exec() {

	xError 				result 		= kNoError;
	const char * 		pipeName 	= kPipename;
	bool 				isBusy 		= true;
	bool 				success 	= true;
	HANDLE 				pipeHandler;
	const char * 		messageString = "Hello world!";
	char  				buffer[kBufferSize];
	char  				data[kBufferSize];
	long unsigned int 	readMessageLength;
	long unsigned int	messageLength;
	long unsigned int 	writtenBytes;
	long unsigned int 	pipeMode;

	// Try to open pipe
	while (isBusy && (result == kNoError))
	{
		if (result == kNoError) {
			pipeHandler = CreateFile(
				pipeName,   					// pipe name
				GENERIC_READ | GENERIC_WRITE, 	// read and write access
				0,              				// no sharing
				NULL,           				// default security attributes
				OPEN_EXISTING, 					// opens existing pipe
				0,              				// default attributes
				NULL							// no template file
			);

			isBusy = pipeHandler == INVALID_HANDLE_VALUE;
		}

		if (isBusy && (result == kNoError)) {
			if (GetLastError() != ERROR_PIPE_BUSY) {
				result = kPipeError;
				printf("Could not open pipe.  GLE=%lu", GetLastError());
			}
		}

		if (isBusy && (result == kNoError)) {
			if (!WaitNamedPipe(pipeName, 20000)) {
				result = kPipeDelayError;
				printf("Could not open pipe: 20 second wait timed out");
			}
		}
	}

	if (result == kNoError) {
		pipeMode = PIPE_READMODE_MESSAGE;

		// Get pipe
		success = SetNamedPipeHandleState(
			pipeHandler,	// pipe handle
			&pipeMode,  	// new pipe mode
			NULL,     		// don't set maximum bytes
			NULL			// don't set maximum time
		);

		if (!success) {
			result = kPipeError;
			printf("SetNamedPipeHandleState failed. GLE=%lu\n", GetLastError());
		}
	}

	// Send message through pipe
	if (result == kNoError) {
		messageLength = (lstrlen(messageString)+1)*sizeof(TCHAR);

		printf("Sending %lu byte message: \"%s\"\n", messageLength, messageString);

		success = WriteFile(
			pipeHandler,	// pipe handle
			messageString, 	// message
			messageLength, 	// message length
			&writtenBytes, 	// bytes written
			NULL			// not overlapped
		);

		if (!success) {
			printf("WriteFile to pipe failed. GLE=%lu\n", GetLastError());

			result = kWriteError;
		}
	}

	if (result == kNoError) {
		do {
			success = ReadFile(
				pipeHandler,    			// pipe handle
				buffer,    					// buffer to receive reply
				kBufferSize*sizeof(char),  	// size of buffer
				&readMessageLength,  		// number of bytes read
				NULL						// not overlapped
			);

			if (!success && (GetLastError() != ERROR_MORE_DATA)) {
				isBusy = false;
			} else {
				isBusy = true;
				strcat(data, buffer);
			}
		} while (isBusy && !success);

		if (!success) {
			printf("ReadFile from pipe failed. GLE=%lu\n", GetLastError());
			result = kReadError;
		} else {
			printf("\"%s\"\n", data);
		}
	}

	if (result == kNoError) {
		printf("\n<End of message, press ENTER to terminate connection and exit>");
		_getch();
	} else {
		printf("\nError %d", result);
	}

   CloseHandle(pipeHandler);

   return result;
}
