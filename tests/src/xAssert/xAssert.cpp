/*
 * xAssert.cpp
 *
 *  Created on: Sep 2, 2021
 *      Author: BrandonMFong
 */

#include <xAssert.hpp>

char * errorOutput = NULL;
bool assertStatus = true;

void xUTResults(const char * string, ...)
{
	va_list args;

	va_start(args, string);

	if (!assertStatus) {
		printf("\n============================\n");

		if (::errorOutput != NULL) {
			printf(::errorOutput);
		}
	}

	printf("[ %s ] ", assertStatus ? "PASS" : "FAIL");

	vprintf(string, args);

	if (!assertStatus) {
		printf("\n===========================\n");
	}

	va_end(args);

	// Reset status flag
	assertStatus = true;

	if (::errorOutput != NULL) {
		free(::errorOutput);
	}
}

void xAssertNotNull(void * value, const char * string, ...) {
	va_list args;
	va_start(args, string);
	xAssert(value != NULL, string, args);
	va_end(args);
}

void xAssert(bool value, const char * string, ...)
{
	bool 	result 			= true;
	bool 	okayToContinue 	= true;
	va_list args;

	va_start(args, string);

	if (result && okayToContinue) {
		okayToContinue = !value;
	}

	if (result && okayToContinue) {
		if (::errorOutput == NULL) {
			::errorOutput = (char *) malloc(sizeof(char) * (strlen(string) + 2));

			if (::errorOutput != NULL) {
				strcpy(::errorOutput, "- ");
				result = true;
			}
		} else {
			::errorOutput = (char *) realloc(::errorOutput, (strlen(::errorOutput) + strlen(string) + 2));

			if (::errorOutput != NULL) {
				strcat(::errorOutput, "- ");
				result = true;
			}
		}
	}

	if (result && okayToContinue) {
		strcat(::errorOutput, string);
		strcat(::errorOutput, "\n");

		// Save the value of the assertion so we remember
		// to print at the end of the test run
		assertStatus = value;
	}

	va_end(args);
}
