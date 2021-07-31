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
   BOOL   fConnected = FALSE;
   DWORD  dwThreadId = 0;
   HANDLE hPipe = INVALID_HANDLE_VALUE;
   HANDLE hThread = NULL;
   LPCTSTR lpszPipename = kPipename;

}
