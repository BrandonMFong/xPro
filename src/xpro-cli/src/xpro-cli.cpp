//============================================================================
// Name        : xpro-cli.cpp
// Author      : 
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C++, Ansi-style
//============================================================================

#include <windows.h>
#include <stdio.h>
#include <conio.h>
#include <tchar.h>

/* xPro */
#include <xLib.h>

int main(int argc, char ** argv)
{
	xError 				error 		= kNoError;
	const char * 		pipeName 	= kPipename;
	bool 				isBusy 		= true;
	bool 				success 	= true;
	HANDLE 				pipeHandler;
	char * 				messageString;
	char  				buffer[kBufferSize];
	char  				result[kBufferSize];
	long unsigned int 	readMessageLength;
	long unsigned int	messageLength;
	long unsigned int 	writtenBytes;
	long unsigned int 	pipeMode;

	if (error == kNoError) {
		if (argc > 1) {
			messageString = argv[1];
		} else {
			error = kArgError;
			DLog("No argument provided");
		}
	}

	// Try to open pipe
	while (isBusy && (error == kNoError))
	{
		if (error == kNoError) {
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

		if (isBusy && (error == kNoError)) {
			if (GetLastError() != ERROR_PIPE_BUSY) {
				error = kPipeError;
				printf("Could not open pipe.  GLE=%lu", GetLastError());
			}
		}

		if (isBusy && (error == kNoError)) {
			if (!WaitNamedPipe(pipeName, 20000)) {
				error = kPipeDelayError;
				printf("Could not open pipe: 20 second wait timed out");
			}
		}
	}

	if (error == kNoError) {
		pipeMode = PIPE_READMODE_MESSAGE;

		// Get pipe
		success = SetNamedPipeHandleState(
			pipeHandler,	// pipe handle
			&pipeMode,  	// new pipe mode
			NULL,     		// don't set maximum bytes
			NULL			// don't set maximum time
		);

		if (!success) {
			error = kPipeError;
			printf("SetNamedPipeHandleState failed. GLE=%lu\n", GetLastError());
		}
	}

	// Send message through pipe
	if (error == kNoError) {
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

			error = kWriteError;
		}
	}

	if (error == kNoError) {
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
				strcat(result, buffer);
			}
		} while (isBusy && !success);

		if (!success) {
			printf("ReadFile from pipe failed. GLE=%lu\n", GetLastError());
			error = kReadError;
		} else {
			printf("\"%s\"\n", buffer);
		}
	}

	if (error == kNoError) {
		printf("\n<End of message, press ENTER to terminate connection and exit>");
		_getch();
	} else {
		printf("\nError %d", error);
	}

   CloseHandle(pipeHandler);

   return (int) error;
}
