/**
 * @file main.cpp
 * @author Brando
 * @brief 
 * @version 0.1
 * @date 2021-02-12
 * 
 * @copyright Copyright (c) 2021
 * 
 */

#include <xPro/xPro.hpp>

#define kMaxArgs 2

void help(xBool showDetails);

xBegin

    xUInt size;
    xUInt index;
    xConfigReader * configReader = new xConfigReader();

    // Handle Arguments
    help(True);

xEnd

void help(xBool showDetails)
{
    std::cout << gArg->Count() << std::endl;
}