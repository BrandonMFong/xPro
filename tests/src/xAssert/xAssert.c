/*
 * xAssert.cpp
 *
 *  Created on: Sep 2, 2021
 *      Author: BrandonMFong
 */

#include <xAssert.h>

char * errorOutput = xNull;
xBool assertStatus = TRUE;

void xUTResults(const char * string, ...)
{
	va_list args;

	va_start(args, string);

	if (!assertStatus) {
		printf("\n============================\n");

		if (errorOutput != xNull) {
			printf("%s", errorOutput);
		}
	}

	printf("\n[ %s ] ", assertStatus ? "PASS" : "FAIL");

	vprintf(string, args);

	if (!assertStatus) {
		printf("\n===========================\n");
	}

	va_end(args);

	// Reset status flag
	assertStatus = TRUE;

	if (errorOutput != xNull) {
		free(errorOutput);
	}
}

void xAssertNotNull(void * value, const char * string, ...) {
	va_list args;
	va_start(args, string);
	xAssert(value != NULL, string, args);
	va_end(args);
}

void xAssert(xBool value, const char * string, ...)
{
	xBool 	result 			= TRUE;
	xBool 	okayToContinue 	= TRUE;
	va_list args;

	va_start(args, string);

	if (result && okayToContinue) {
		okayToContinue = !value;
	}

	if (result && okayToContinue) {
		if (errorOutput == NULL) {
			errorOutput = (char *) malloc(sizeof(char) * (strlen(string) + 2));

			if (errorOutput != NULL) {
				strcpy(errorOutput, "- ");
				result = TRUE;
			}
		} else {
			errorOutput = (char *) realloc(errorOutput, (strlen(errorOutput) + strlen(string) + 2));

			if (errorOutput != NULL) {
				strcat(errorOutput, "- ");
				result = TRUE;
			}
		}
	}

	if (result && okayToContinue) {
		strcat(errorOutput, string);
		strcat(errorOutput, "\n");

		// Save the value of the assertion so we remember
		// to print at the end of the test run
		assertStatus = value;
	}

	va_end(args);
}
