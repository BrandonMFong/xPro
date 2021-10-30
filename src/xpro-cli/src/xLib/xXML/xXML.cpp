/*
 * xXML.cpp
 *
 *  Created on: Oct 30, 2021
 *      Author: brandonmfong
 */

#include "xXML.h"

xXML::xXML(const char * path, xError * err) {
	xError error = kNoError;

	this->_path = xNull;

	// Read contents of file into rawContent
	if (path != xNull) {
		error = this->read(path);
	}

	if (err != xNull) {
		*err = error;
	}
}

xXML::~xXML() {
	if (this->_path != xNull) {
		free(this->_path);
	}

	if (this->_rawContent != xNull) {
		free(this->_rawContent);
	}
}

xError xXML::read(const char * path) {
	xError 	result 			= kNoError;
	FILE 	* fp 			= xNull;
	char 	ch 				= 0,
			* rawContent 	= xNull;
	xBool 	readingFile 	= xTrue;
	xUInt64 fileLength 		= 0;

	// Make sure file exists
	if (!xIsFile(path)) {
		result = kFileError;
		DLog("'%s' will not be parsed\n", path);
	}

	// Open file
	if (result == kNoError) {
		fp 		= fopen(path, "r");
		result 	= fp != xNull ? kNoError : kReadError;
	}

	// Get the length of the file
	if (result == kNoError) {
		fseek(fp, 0, SEEK_END);

		fileLength 	= ftell(fp);
		result 		= fileLength > 0 ? kNoError : kFileContentError;
	}

	if (result == kNoError) {
		rawContent 	= (char *) malloc(fileLength + 1);
		result 		= rawContent != xNull ? kNoError : kUnknownError;
	}

	if (result == kNoError) {
		fseek(fp, 0, SEEK_SET); // Set to the beginning of the file

		// Read each character of the file into rawContent.  The result
		// should be the entire ascii value of the file
		readingFile = xTrue;
		while (readingFile) {
			ch = fgetc(fp);

			if (feof(fp)) {
				readingFile = xFalse;
			} else {
				strncat(rawContent, &ch, 1);
			}
		}

		fclose(fp);

		result = strlen(rawContent) == fileLength ? kNoError : kFileContentError;

		if (result != kNoError) {
			DLog("Could not read entire file");
		} else {
			this->_rawContent = rawContent; // Save the file content
		}
	}

	if (result == kNoError) {
		this->_path = xCopyString(path, &result);
	}

	return result;
}
