/**
 * @file xConfigReader.h 
 * 
 * @brief xConfigReader class
 * 
 * @author Brando
 * 
 * Am not using the below.  Will think about it though
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
struct Root
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
                xString Color;
                xString InnerXml;
            } String;
        } Prompt;

        struct StartDirectory
        {
            xString Name = "StartDirectory";
            xString InnerXml;
        } StartDirectory;

    } ShellSettings;

    struct Modules
    {
        xString Name = "Modules";

        struct Mod
        {
            xString Name = "Module";
            xString InnerXml;
        };
        std::vector<Mod> Module;
    } Modules;

    struct Directories
    {
        xString Name = "Directories";
        struct Dir
        {
            xString Name = "Directory";
            xString Alias;
            xString SecType;
            xString InnerXml;
        };
        std::vector<Dir> Directory;
    } Directories;

    struct Programs
    {
        xString Name = "Programs";
        struct Prog
        {
            xString Name = "Program";
            xString Alias;
            xString SecType;
            xString InnerXml;
        };
        std::vector<Prog> Program;
    } Programs;

    struct Objects
    {
        xString Name = "Objects";
        struct Obj
        {
            xString Name = "Object";
            xString Type;
            
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
        std::vector<Obj> Object;
    } Objects;
};

class xConfigReader : public xXml
{
public:
    xConfigReader();
    xConfigReader(xString filepath);
    Root Machine;
private: 
};

#endif