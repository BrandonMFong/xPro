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
    xString name = "Machine"; 
    xString machineName;
    xString loadProcedure;
    xString loadProfile;

    struct UpdateStamp
    {
        xString name = "UpdateStamp";
        xString value;
    } updateStamp;
    

    struct ShellSettings
    {
        xString name = "ShellSettings";
        xString enabled;

        struct Prompt
        {
            xString name = "Prompt";
            xString enabled;

            struct BaterryLifeThreshold
            {
                xString name = "BaterryLifeThreshold";
                xString enabled;
                xString innerXml;
            } baterryLifeThreshold;

            struct String
            {
                xString name = "String";
                xString innerXml;
            } string;
        } prompt;

        struct StartDirectory
        {
            xString name = "StartDirectory";
        } startDirectory;
    } shellSettings;

    struct Modules
    {
        xString name = "Modules";

        struct Module
        {
            xString name = "Module";
            xString innerXml;
        };
        std::vector<Module> module;
    } modules;

    struct Directories
    {
        xString name = "Directories";
        struct Directory
        {
            xString name = "Directory";
            xString alias;
            xString secType;
            xString innerXml;
        };
        std::vector<Directory> directory;
    } directories;

    struct Programs
    {
        xString name = "Programs";
        struct Program
        {
            xString name = "Program";
            xString alias;
            xString secType;
            xString innerXml;
        };
        std::vector<Program> program;
    } programs;
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