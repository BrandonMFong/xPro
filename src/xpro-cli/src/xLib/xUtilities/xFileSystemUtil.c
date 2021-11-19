/*
 * xFileSystemUtil.c
 *
 *  Created on: Oct 30, 2021
 *      Author: brandonmfong
 */

#include "xUtilities.h"

#if defined(__MACOS__)
#include <sys/syslimits.h>
#endif

char * xHomePath(xError * err) {
	char * 	result 	= xNull;
	xError 	error 	= kNoError;
	char 	tempPath[MAX_PATH_LENGTH];

	if (error == kNoError) {
#if defined(__WINDOWS__)
		sprintf(tempPath, "%s%s", getenv("HOMEDRIVE"), getenv("HOMEPATH"));
#elif defined(__MACOS__)
		sprintf(tempPath, "%s", getenv("HOME"));
#elif defined(__LINUX__)
		sprintf(tempPath, "%s", getenv("HOME"));
#else
		DLog("No architecture defined for build\n");
		error = kOSError;
#endif

		if (strlen(tempPath) == 0) {
			error = kEmptyStringError;
		}
	}

	if (error == kNoError) {
		result = xCopyString(tempPath, &error);
	}

	if (err != xNull) {
		*err = error;
	}

	return result;
}

xBool xIsFile(const char * path) {
	xBool result = access(path, F_OK) == 0;

	if (!result) {
		DLog("'%s' does not exist\n", path);
	}

	return result;
}

xBool xIsDir(const char * path) {
	xBool 	result 	= xFalse;
	DIR * 	d 		= xNull;

	d = opendir(path);
	if (d != NULL) {
		closedir(d);
		result = xTrue;
	}

	return result;
}

char * xReadFile(
	const char * 	path,
	xError * 		err
) {
	char 	* result	= xNull,
			ch 			= 0;
	xError 	error 		= kNoError;
	FILE 	* fp 		= xNull;
	xBool 	readingFile	= xTrue;
	xUInt64 fileLength 	= 0;

	// Make sure file exists
	if (!xIsFile(path)) {
		error = kFileError;
		DLog("'%s' will not be parsed\n", path);
	}

	// Open file
	if (error == kNoError) {
		fp 		= fopen(path, "r");
		error 	= fp != xNull ? kNoError : kReadError;
	}

	// Get the length of the file
	if (error == kNoError) {
		fseek(fp, 0, SEEK_END);

		fileLength 	= ftell(fp);
		error 		= fileLength > 0 ? kNoError : kFileContentError;
	}

	if (error == kNoError) {
		result 	= (char *) malloc(fileLength + 1);
		error 	= result != xNull ? kNoError : kUnknownError;

		if (error == kNoError) {
			strcpy(result, "");
		}
	}

	if (error == kNoError) {
		fseek(fp, 0, SEEK_SET); // Set to the beginning of the file

		// Read each character of the file into rawContent.  The result
		// should be the entire ascii value of the file
		readingFile = xTrue;
		while (readingFile) {
			ch = fgetc(fp);

			if (feof(fp)) {
				readingFile = xFalse;
			} else {
				strncat(result, &ch, 1);
			}
		}

		fclose(fp);

		error = strlen(result) == fileLength ? kNoError : kFileContentError;

		if (error != kNoError) {
			DLog("Could not read entire file.  Expected length: %llu. Actual: %lu\n",
					fileLength,
					strlen(result));
		}
	}

	if (err != xNull) {
		*err = error;
	}

	return result;
}

xError xMkDir(const char * path) {
	xError result = kNoError;

	if (!xIsDir(path)) {
		if (mkdir(path, 0700) == -1) {
			result = kDirectoryError;
			DLog("Could not create %s", path);
		}

		if (result == kNoError) {
			if (!xIsDir(path)) {
				result = kDirectoryError;
				DLog("Directory still does not exist, %s", path);
			}
		}
	}

	return result;
}
