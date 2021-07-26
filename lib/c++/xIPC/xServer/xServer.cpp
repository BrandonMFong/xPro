/*
 * xServer.cpp
 *
 *  Created on: Jul 24, 2021
 *      Author: BrandonMFong
 */

#include <xIPC/xServer/xServer.h>

namespace xPro {

xServer::xServer() : xObject() {
	xError error = kNoError;
    WSADATA wsaData;
    int iResult;
    SOCKET ListenSocket = INVALID_SOCKET;
    SOCKET ClientSocket = INVALID_SOCKET;
    struct addrinfo *result = NULL;
    struct addrinfo hints;
    int iSendResult;
    char recvbuf[DEFAULT_BUFLEN];
    int recvbuflen = DEFAULT_BUFLEN;

    // Initialize Winsock
    if (error == kNoError) {
		iResult = WSAStartup(MAKEWORD(2,2), &wsaData);
		if (iResult != 0) {
			DLog("WSAStartup failed with error: %d\n", iResult);
			error = kSocketServerInitError;
		}
    }

    if (error == kNoError) {
    	ZeroMemory(&hints, sizeof(hints));
		hints.ai_family = AF_INET;
		hints.ai_socktype = SOCK_STREAM;
		hints.ai_protocol = IPPROTO_TCP;
		hints.ai_flags = AI_PASSIVE;

		// Resolve the server address and port
		iResult = getaddrinfo(NULL, DEFAULT_PORT, &hints, &result);
		if ( iResult != 0 ) {
			DLog("getaddrinfo failed with error: %d\n", iResult);
			WSACleanup();
			error = kSocketServerInitError;
		}
    }

    if (error == kNoError) {
    	// Create a SOCKET for connecting to server
		ListenSocket = socket(result->ai_family, result->ai_socktype, result->ai_protocol);
		if (ListenSocket == INVALID_SOCKET) {
			DLog("socket failed with error: %ld\n", WSAGetLastError());
			freeaddrinfo(result);
			WSACleanup();
			error = kSocketServerInitError;
		}
    }

	this->_status = error;
}

xServer::~xServer() {
	// TODO Auto-generated destructor stub
}

xError xServer::bind() {
	xError result = this->_status;
//    int iResult;
//
//    // Setup the TCP listening socket
//	if (result == kNoError) {
//		iResult = bind( ListenSocket, result->ai_addr, (int)result->ai_addrlen);
//		if (iResult == SOCKET_ERROR) {
//			printf("bind failed with error: %d\n", WSAGetLastError());
//			freeaddrinfo(result);
//			closesocket(ListenSocket);
//			WSACleanup();
//			result = kSocketServerBindError;
//		}
//	}


	return result;
}

} /* namespace xPro */
