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
// struct UpdateStamp
// {
//     xString name = "UpdateStamp";
//     xString value;
// };
// REFL_TYPE(UpdateStamp)
//     REFL_FIELD(name) 
//     REFL_FIELD(value) 
// REFL_END

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
    // UpdateStamp updateStamp;
    

    // struct ShellSettings
    // {
    //     xString Name = "ShellSettings";
    //     xString Enabled;

    //     struct Prompt
    //     {
    //         xString Name = "Prompt";
    //         xString Enabled;

    //         struct BaterryLifeThreshold
    //         {
    //             xString Name = "BaterryLifeThreshold";
    //             xString Enabled;
    //             xString InnerXml;
    //         } BaterryLifeThreshold;

    //         struct String
    //         {
    //             xString Name = "String";
    //             xString InnerXml;
    //         } String;
    //     } Prompt;

    //     struct StartDirectory
    //     {
    //         xString Name = "StartDirectory";
    //     } StartDirectory;
    // } ShellSettings;

    // struct Modules
    // {
    //     xString Name = "Modules";

    //     struct Module
    //     {
    //         xString Name = "Module";
    //         xString InnerXml;
    //     };
    //     std::vector<Module> Module;
    // } Modules;

    // struct Directories
    // {
    //     xString Name = "Directories";
    //     struct Directory
    //     {
    //         xString Name = "Directory";
    //         xString Alias;
    //         xString SecType;
    //         xString InnerXml;
    //     };
    //     std::vector<Directory> Directory;
    // } Directories;

    // struct Programs
    // {
    //     xString Name = "Programs";
    //     struct Program
    //     {
    //         xString Alias;
    //         xString SecType;
    //         xString InnerXml;
    //     };
    //     std::vector<Program> Program;
    // } Programs;
};

REFL_TYPE(Root::UpdateStamp)
    REFL_FIELD(name) 
    REFL_FIELD(value) 
REFL_END
REFL_TYPE(Root)
    REFL_FIELD(name) 
    REFL_FIELD(machineName) 
    REFL_FIELD(loadProcedure) 
    REFL_FIELD(loadProfile) 
    REFL_FIELD(updateStamp) 
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