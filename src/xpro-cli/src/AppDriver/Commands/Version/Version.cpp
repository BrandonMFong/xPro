/*
 * Version.cpp
 *
 *  Created on: Nov 29, 2021
 *      Author: brandonmfong
 */

#include "Version.hpp"
#include <Utilities/Utilities.h>

xError HandleVersion() {
	xError result = kNoError;

	printf("%s\n", VERSION);

	return result;
}
