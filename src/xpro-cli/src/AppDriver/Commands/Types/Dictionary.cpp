/*
 * Dictionary.cpp
 *
 *  Created on: Jul 15, 2022
 *      Author: brandonmfong
 */

#include "Dictionary.hpp"

const char * const COUNT_ARG = "--count";
const char * const INDEX_ARG = "-index";
const char * const VALUE_ARG = "--value";
const char * const NAME_ARG = "--name";

Dictionary::Dictionary(xError * err) : Command(err) {


}

Dictionary::~Dictionary() {

}

const char * Dictionary::countArg() {
	return COUNT_ARG;
}

const char * Dictionary::indexArg() {
	return INDEX_ARG;
}

const char * Dictionary::valueArg() {
	return VALUE_ARG;
}

const char * Dictionary::keyArg() {
	return NAME_ARG;
}


