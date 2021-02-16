/**
 * @file main.cpp
 * @author Brando 
 * @brief 
 * @version 0.1
 * @date 2021-02-03
 * 
 * @copyright Copyright (c) 2021
 * 
 */

#include <xPro/xPro.hpp>

#define dMaxArgs 2

xBegin
    xUInt size;
    xString value;
    xBool userAskedForHelp = False;
    xString delimiterString = "/";
    xAppSettings * settingsReader = new xAppSettings();

    std::cout << gStatus << std::endl;
    
    if(gStatus)
    {
        std::cout << gArg->Count() << std::endl;
        gStatus = gArg->Count() != dMaxArgs ? Bad : Good; 
    }

    if(!gStatus) 
    {
        std::cout << "usage: " << gArg->Values()[0] << std::endl;
        std::cout << "See '"<< gArg->Values()[0] << " " << dHelpArgument << "' for an overview of the system." << std::endl;
        std::cout << dFooter << std::endl;
    }

    if(gStatus)
    {
        size = gArg->Values().size();
        for(xUInt i = 0; i < size; i++)
        {
            value = gArg->Values()[i];
            if(value == dHelpArgument)
            {
                userAskedForHelp = True;
                break;
            }
        }

        if(userAskedForHelp)
        {
            std::cout << "usage: " << gArg->Values()[0] << std::endl;
            
            std::cout << "\nAvailable Commands: " << std::endl;

            std::cout << dFooter << std::endl;
        }
    }

xEnd
