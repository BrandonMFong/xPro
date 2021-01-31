/**
 * @file main.cpp
 * @author Brando
 * @brief 
 * @version 0.1
 * @date 2021-01-23
 * 
 * @copyright Copyright (c) 2021
 * 
 */

#include <xPro/xPro.h>

xBegin

    gStatus = Good;
    xQuery * database = new xQuery();

    std::cout << (database->Connected() ? "Connected" : "Not Connected") << std::endl;

    database->Close();

xEnd