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

#define kBufferSize 512
#define kPipename "\\\\.\\pipe\\mynamedpipe"

int _tmain(int argc, TCHAR *argv[])
{
	xError 	error = kNoError;
	HANDLE pipeHandler;
	LPTSTR messageString;
	TCHAR  chBuf[kBufferSize];
	DWORD  cbRead;
	DWORD messageBuffer;
	DWORD cbWritten;
	DWORD pipeMode;
	LPTSTR pipeName = kPipename;
	bool isBusy = true;
	bool success = true;

	if (error == kNoError) {
		if (argc > 1) {
			messageString = argv[1];
		} else {
			messageString = "Default message from client.";
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
				printf("Could not open pipe.  GLE=%d", GetLastError());
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
			printf("SetNamedPipeHandleState failed. GLE=%d\n", GetLastError());
		}
	}

	// Send message through pipe
	if (error == kNoError) {
		messageBuffer = (lstrlen(messageString)+1)*sizeof(TCHAR);

		printf("Sending %d byte message: \"%s\"\n", messageBuffer, messageString);

		success = WriteFile(
			pipeHandler,	// pipe handle
			messageString, 	// message
			messageBuffer, 	// message length
			&cbWritten, 	// bytes written
			NULL			// not overlapped
		);

		if (!success) {
			printf("WriteFile to pipe failed. GLE=%d\n", GetLastError());

			error = kWriteError;
		}
	}

	if (error == kNoError) {
		isBusy = true;
		do {
			success = ReadFile(
				pipeHandler,    			// pipe handle
				chBuf,    					// buffer to receive reply
				kBufferSize*sizeof(TCHAR),  // size of buffer
				&cbRead,  					// number of bytes read
				NULL						// not overlapped
			);

			if (!success && (GetLastError() != ERROR_MORE_DATA)) {
				isBusy = false;
			} else {
				printf("\"%s\"\n", chBuf);
			}
		} while (isBusy && !success);

		if (!success) {
			printf("ReadFile from pipe failed. GLE=%d\n", GetLastError());
			error = kReadError;
		}
	}

	if (error == kNoError) {
		printf("\n<End of message, press ENTER to terminate connection and exit>");
		_getch();
	} else {
		printf("\nError %d", error);
	}

   CloseHandle(pipeHandler);

   return 0;
}
