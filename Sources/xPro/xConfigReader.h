/**
 * @file xConfigReader.h 
 * 
 * @brief xConfigReader class
 * 
 * @author Brando
 * 
 * https://github.com/veselink1/refl-cpp
 * https://medium.com/@vesko.karaganev/refl-cpp-deep-dive-86b185f68678
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
    } UpdateStamp;

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
            } BaterryLifeThreshold;

            struct String
            {
                xString Name = "String";
                xString InnerXml;
            } String;
        } Prompt;

        struct StartDirectory
        {
            xString Name = "StartDirectory";
        } StartDirectory;
    } ShellSettings;

    struct Modules
    {
        xString Name = "Modules";

        struct Module
        {
            xString Name = "Module";
            xString InnerXml;
        };
        std::vector<Module> Module;
    } Modules;

    struct Directories
    {
        xString Name = "Directories";
        struct Directory
        {
            xString Name = "Directory";
            xString Alias;
            xString SecType;
            xString InnerXml;
        };
        std::vector<Directory> Directory;
    } Directories;

    struct Programs
    {
        xString Name = "Programs";
        struct Program
        {
            xString Name = "Program";
            xString Alias;
            xString SecType;
            xString InnerXml;
        };
        std::vector<Program> Program;
    } Programs;

    struct Objects
    {
        xString Name = "Programs";
        struct Object
        {
            xString Name = "Program";
            
            struct VarName
            {
                xString SecType;
                xString InnerXml;  
            } VarName;
            
            struct SimpleValue
            {
                xString SecType;
                xString InnerXml;  
            } SimpleValue;
        };
        std::vector<Object> Object;
    } Objects;
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