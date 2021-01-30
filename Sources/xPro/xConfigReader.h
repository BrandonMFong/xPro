/**
 * @file xConfigReader.h 
 * 
 * @brief xConfigReader class
 * 
 * @author Brando
 * @date 2021-01-23
 * 
 * Am not using the below.  Will think about it though
 * https://github.com/veselink1/refl-cpp
 * https://medium.com/@vesko.karaganev/refl-cpp-deep-dive-86b185f68678
 */

#ifndef _XCONFIGREADER_
#define _XCONFIGREADER_

#include <xPro/xPro.h>

/**
 * @brief The C++ xml structure for xPro User config files.  Please read xPro.xsd for more details
 * 
 */
struct xRootConfigReader : BasicXml
{
    xString MachineName;
    xString LoadProcedure;
    xString LoadProfile;

    struct UpdateStamp : BasicXml
    {
        xString Value;
    } UpdateStamp;

    struct Database : BasicXml
    {
        xString Path;
    } Database;

    struct ShellSettings : BasicXml
    {
        xString Enabled;

        struct Prompt : BasicXml
        {
            xString Enabled;

            struct BaterryLifeThreshold : BasicXml
            {
                xString Enabled;
            } BaterryLifeThreshold;

            struct String : BasicXml
            {
                xString Color;
            } String;
        } Prompt;

        struct StartDirectory : BasicXml
        {} StartDirectory;

    } ShellSettings;

    struct Modules : BasicXml
    {
        struct Mod : BasicXml
        {};
        std::vector<Mod> Module;
    } Modules;

    struct Directories : BasicXml
    {
        struct Dir : BasicXml
        {
            xString Alias;
            xString SecType;
        };
        std::vector<Dir> Directory;
    } Directories;

    struct Programs : BasicXml
    {
        struct Prog : BasicXml
        {
            xString Alias;
            xString SecType;
        };
        std::vector<Prog> Program;
    } Programs;

    struct Objects : BasicXml
    {
        struct Obj : BasicXml
        {
            xString Type;
            
            struct VarName : BasicXml
            {
                xString SecType;
            } VarName;
            
            struct SimpleValue : BasicXml
            {
                xString SecType;
            } SimpleValue;
        };
        std::vector<Obj> Object;
    } Objects;
};

/**
 * @brief Class that drives the structure for xPro User Configurations 
 * 
 */
class xConfigReader : public xXml
{
public:
    /**
     * @brief Construct a new xConfigReader object
     * 
     */
    xConfigReader();

    /**
     * @brief Construct a new xConfigReader object
     * 
     * @param filepath file path to the user configuration 
     */
    xConfigReader(xString filepath);

    /**
     * @brief Carries the xPro config structure 
     * 
     */
    xRootConfigReader Machine;
private: 
};

#endif