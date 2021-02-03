/**
 * @file xAppSettings.hpp
 * @author Brando
 * @brief 
 * @version 0.1
 * @date 2021-02-02
 * 
 * @copyright Copyright (c) 2021
 * 
 */

#ifndef _XAPPSETTINGS_
#define _XAPPSETTINGS_

#include <xPro/xPro.h>

/**
 * @brief Defines the app.json structure.  Pretty follows similarly to the xml family 
 * 
 */
struct xRootAppSettings : BasicJson
{
    xString RepoName;
    xString BaseConfig;

    struct Directories : BasicJson
    {
        xString UserConfig;
        xString UserCache;
        xString CalendarCache;
        xString gitCache; // following naming convention in config TODO change
        xString GreetingsCache;
        xString CalendarFileEventImport;
        xString Classes;
    } Directories;

    struct Files : BasicJson
    {
        xString Debug;
        xString Greetings;
        xString SessionCache;
        xString plistConfig;
        xString CalendarClassMod;
        xString DirectoryCache;

        struct Config : BasicJson 
        {
            xString Verioning;
        } Config;
    } Files;
};

class xAppSettings : public xJson 
{
public: 
    xAppSettings();
protected:
private:
};

#endif 
