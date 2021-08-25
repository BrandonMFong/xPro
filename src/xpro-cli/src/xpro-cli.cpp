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
	BOOL   fSuccess = FALSE;
	DWORD  cbRead, cbToWrite, cbWritten, dwMode;
	LPTSTR pipeName = kPipename;
	bool isBusy = true;

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

			isBusy = pipeHandler != INVALID_HANDLE_VALUE;
		}

		if (isBusy && (error == kNoError)) {
			if (GetLastError() != ERROR_PIPE_BUSY) {
				error = kPipeError;
				DLog("Could not open pipe.  GLE=%d", GetLastError());
			}
		}

		if (isBusy && (error == kNoError)) {
			if (!WaitNamedPipe(pipeName, 20000)) {
				error = kPipeDelayError;
				DLog("Could not open pipe: 20 second wait timed out");
			}
		}
	}

// The pipe connected; change to message-read mode.

   dwMode = PIPE_READMODE_MESSAGE;
   fSuccess = SetNamedPipeHandleState(
		   pipeHandler,    // pipe handle
      &dwMode,  // new pipe mode
      NULL,     // don't set maximum bytes
      NULL);    // don't set maximum time
   if ( ! fSuccess)
   {
	   printf( TEXT("SetNamedPipeHandleState failed. GLE=%d\n"), GetLastError() );
      return -1;
   }

// Send a message to the pipe server.

   cbToWrite = (lstrlen(messageString)+1)*sizeof(TCHAR);
   printf( TEXT("Sending %d byte message: \"%s\"\n"), cbToWrite, messageString);

   fSuccess = WriteFile(
		   pipeHandler,                  // pipe handle
	  messageString,             // message
      cbToWrite,              // message length
      &cbWritten,             // bytes written
      NULL);                  // not overlapped

   if ( ! fSuccess)
   {
	   printf( TEXT("WriteFile to pipe failed. GLE=%d\n"), GetLastError() );
      return -1;
   }

   printf("\nMessage sent to server, receiving reply as follows:\n");

   do
   {
   // Read from the pipe.

      fSuccess = ReadFile(
    		  pipeHandler,    // pipe handle
         chBuf,    // buffer to receive reply
		 kBufferSize*sizeof(TCHAR),  // size of buffer
         &cbRead,  // number of bytes read
         NULL);    // not overlapped

      if ( ! fSuccess && GetLastError() != ERROR_MORE_DATA )
         break;

      printf( TEXT("\"%s\"\n"), chBuf );
   } while ( ! fSuccess);  // repeat loop if ERROR_MORE_DATA

   if ( ! fSuccess)
   {
	   printf( TEXT("ReadFile from pipe failed. GLE=%d\n"), GetLastError() );
      return -1;
   }

   printf("\n<End of message, press ENTER to terminate connection and exit>");
   _getch();

   CloseHandle(pipeHandler);

   return 0;
}
