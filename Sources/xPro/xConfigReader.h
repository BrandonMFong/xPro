/**
 * @file xConfigReader.h 
 * 
 * @brief xConfigReader class
 * 
 * @author Brando
 */

#ifndef _XCONFIGREADER_
#define _XCONFIGREADER_

#include <xPro/xPro.h>
#define xDefaultConfigRootNodeName "Machine"


/**
 * @brief xPro Config Structure  
 * 
 * Each struct is an element.  
 * Use InnerXml to get content of inside the element.   
 * Following .NET framework for this struct. 
 * Everything is xString or xStringArray.  
 * When Element is an array, use std::vector    
 * Goal: Code uses struct to load.  struct defines what the code looks for
 * 
 */
struct Machine
{
    xString Name = "Machine"; 
    xString MachineName;
    xString LoadProcedure;
    xString LoadProfile;

    struct UpdateStamp
    {
        xString Name = "UpdateStamp";
        xString Value;
    };

    struct ShellSettings
    {
        xString Name = "ShellSettings";
        xString Enabled;

        struct Prompt
        {
            xString Name = "Prompt";
            xString Enabled;

            struct BaterryLifeThreshold
            {
                xString Name = "BaterryLifeThreshold";
                xString Enabled;
                xString InnerXml;
            };

            struct String
            {
                xString Name = "String";
                xString InnerXml;
            };
        };

        struct StartDirectory
        {
            xString Name = "StartDirectory";
        };
    };

    struct Modules
    {
        xString Name = "Modules";

        struct Module
        {
            xString Name = "Module";
            xString InnerXml;
        };
        std::vector<Module> Module;
    };
};

class xConfigReader : public xXml
{
public:
    xConfigReader();
    xConfigReader(xString filepath);
    Machine Machine;
private: 
};

#endif