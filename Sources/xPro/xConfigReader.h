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
    // xString loadProcedure;
    // xString loadProfile;

    struct UpdateStamp
    {
        xString name = "UpdateStamp";
        xString value;
    } updateStamp;
    

    // struct ShellSettings
    // {
    //     xString name = "ShellSettings";
    //     xString enabled;

    //     struct Prompt
    //     {
    //         xString name = "Prompt";
    //         xString enabled;

    //         struct BaterryLifeThreshold
    //         {
    //             xString name = "BaterryLifeThreshold";
    //             xString enabled;
    //             xString innerXml;
    //         } baterryLifeThreshold;

    //         struct String
    //         {
    //             xString name = "String";
    //             xString innerXml;
    //         } string;
    //     } prompt;

    //     struct StartDirectory
    //     {
    //         xString name = "StartDirectory";
    //     } startDirectory;
    // } shellSettings;

    // struct Modules
    // {
    //     xString name = "Modules";

    //     struct Module
    //     {
    //         xString name = "Module";
    //         xString innerXml;
    //     };
    //     std::vector<Module> module;
    // } modules;

    // struct Directories
    // {
    //     xString name = "Directories";
    //     struct Directory
    //     {
    //         xString name = "Directory";
    //         xString alias;
    //         xString secType;
    //         xString innerXml;
    //     };
    //     std::vector<Directory> directory;
    // } directories;

    // struct Programs
    // {
    //     xString name = "Programs";
    //     struct Program
    //     {
    //         xString name = "Program";
    //         xString alias;
    //         xString secType;
    //         xString innerXml;
    //     };
    //     std::vector<Program> program;
    // } programs;
};


REFL_AUTO(type(xString));
// REFL_AUTO(
//     type(Root),
//     field(name, Table{"No"})
// );

REFL_TYPE(Root)
    REFL_FIELD(name, serializable(), IsStruct{"No"})
    REFL_FIELD(machineName, serializable(), IsStruct{"No"}) 
    // REFL_FIELD(loadProcedure, serializable()) 
    // REFL_FIELD(loadProfile, serializable()) 
    REFL_FIELD(updateStamp, serializable(), IsStruct{"Yes"}) 
    // REFL_FIELD(shellSettings, serializable()) 
    // REFL_FIELD(modules, serializable()) 
    // REFL_FIELD(directories, serializable()) 
    // REFL_FIELD(programs, serializable()) 
REFL_END

// REFL_TYPE(Root::UpdateStamp)
//     REFL_FIELD(name, serializable()) 
//     REFL_FIELD(value, serializable()) 
// REFL_END

// REFL_TYPE(Root::ShellSettings)
//     REFL_FIELD(name, serializable()) 
//     REFL_FIELD(enabled, serializable()) 
//     REFL_FIELD(prompt, serializable()) 
//     REFL_FIELD(startDirectory, serializable()) 
// REFL_END

// REFL_TYPE(Root::ShellSettings::Prompt)
//     REFL_FIELD(name, serializable()) 
//     REFL_FIELD(enabled, serializable()) 
//     REFL_FIELD(baterryLifeThreshold, serializable()) 
//     REFL_FIELD(string, serializable()) 
// REFL_END

// REFL_TYPE(Root::ShellSettings::Prompt::BaterryLifeThreshold)
//     REFL_FIELD(name, serializable()) 
//     REFL_FIELD(enabled, serializable()) 
//     REFL_FIELD(innerXml, serializable()) 
// REFL_END

// REFL_TYPE(Root::ShellSettings::Prompt::String)
//     REFL_FIELD(name, serializable()) 
//     REFL_FIELD(innerXml, serializable()) 
// REFL_END

// REFL_TYPE(Root::Modules)
//     REFL_FIELD(name, serializable()) 
//     REFL_FIELD(module, serializable()) 
// REFL_END

// REFL_TYPE(Root::Modules::Module)
//     REFL_FIELD(name, serializable()) 
//     REFL_FIELD(innerXml, serializable()) 
// REFL_END

// REFL_TYPE(Root::Directories)
//     REFL_FIELD(name, serializable()) 
//     REFL_FIELD(directory, serializable()) 
// REFL_END

// REFL_TYPE(Root::Directories::Directory)
//     REFL_FIELD(name, serializable()) 
//     REFL_FIELD(alias, serializable()) 
//     REFL_FIELD(secType, serializable()) 
//     REFL_FIELD(innerXml, serializable()) 
// REFL_END

// REFL_TYPE(Root::Programs)
//     REFL_FIELD(name, serializable()) 
//     REFL_FIELD(program, serializable()) 
// REFL_END

// REFL_TYPE(Root::Programs::Program)
//     REFL_FIELD(name, serializable()) 
//     REFL_FIELD(alias, serializable()) 
//     REFL_FIELD(secType, serializable()) 
//     REFL_FIELD(innerXml, serializable()) 
// REFL_END

class xConfigReader : public xXml
{
public:
    xConfigReader();
    xConfigReader(xString filepath);
    Root Machine;
private: 
};

#endif