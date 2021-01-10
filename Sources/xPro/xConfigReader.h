/**
 * @file xConfigReader.h 
 * 
 * @brief xConfigReader class
 * 
 * @author Brando
 * 
 * https://github.com/veselink1/refl-cpp
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

REFL_TYPE(Root)
    REFL_FIELD(name) 
    REFL_FIELD(machineName) 
    REFL_FIELD(loadProcedure) 
    REFL_FIELD(loadProfile) 
    REFL_FIELD(updateStamp) 
    REFL_FIELD(shellSettings) 
    REFL_FIELD(modules) 
    REFL_FIELD(directories) 
    REFL_FIELD(programs) 
REFL_END

REFL_TYPE(Root::UpdateStamp)
    REFL_FIELD(name) 
    REFL_FIELD(value) 
REFL_END

REFL_TYPE(Root::ShellSettings)
    REFL_FIELD(name) 
    REFL_FIELD(enabled) 
    REFL_FIELD(prompt) 
    REFL_FIELD(startDirectory) 
REFL_END

REFL_TYPE(Root::ShellSettings::Prompt)
    REFL_FIELD(name) 
    REFL_FIELD(enabled) 
    REFL_FIELD(baterryLifeThreshold) 
    REFL_FIELD(string) 
REFL_END

REFL_TYPE(Root::ShellSettings::Prompt::BaterryLifeThreshold)
    REFL_FIELD(name) 
    REFL_FIELD(enabled) 
    REFL_FIELD(innerXml) 
REFL_END

REFL_TYPE(Root::ShellSettings::Prompt::String)
    REFL_FIELD(name) 
    REFL_FIELD(innerXml) 
REFL_END

REFL_TYPE(Root::Modules)
    REFL_FIELD(name) 
    REFL_FIELD(module) 
REFL_END

REFL_TYPE(Root::Modules::Module)
    REFL_FIELD(name) 
    REFL_FIELD(innerXml) 
REFL_END

REFL_TYPE(Root::Directories)
    REFL_FIELD(name) 
    REFL_FIELD(directory) 
REFL_END

REFL_TYPE(Root::Directories::Directory)
    REFL_FIELD(name) 
    REFL_FIELD(alias) 
    REFL_FIELD(secType) 
    REFL_FIELD(innerXml) 
REFL_END

REFL_TYPE(Root::Programs)
    REFL_FIELD(name) 
    REFL_FIELD(program) 
REFL_END

REFL_TYPE(Root::Programs::Program)
    REFL_FIELD(name) 
    REFL_FIELD(alias) 
    REFL_FIELD(secType) 
    REFL_FIELD(innerXml) 
REFL_END


class xConfigReader : public xXml
{
public:
    xConfigReader();
    xConfigReader(xString filepath);
    Root Machine;
private: 
};

#endif