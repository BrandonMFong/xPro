/**
 * @file xAppSettings.cpp
 * @author Brando
 * @brief 
 * @version 0.1
 * @date 2021-02-02
 * 
 * @copyright Copyright (c) 2021
 * 
 */

#include <xPro/xAppSettings.hpp>

// How do I get the path to the xPro config path? 
// I need to read the AppPointer in order to know the repo path 
xAppSettings::xAppSettings() : xJson()
{
    xStatus status = this->_status;
    xFile * filePath;
    xAppPointer * appPointer = new xAppPointer(); // Was thinking about making this global but I don't this it can see it

    // We are going to hard code the path to the app.json since it will 
    // not move by design
    filePath = new xFile(appPointer->Machine.GitRepoDir.InnerXml + dAppSettingsFilePath); 
    status = filePath->Exists() ? Good : Bad;

    // Get file name and path 
    if(status)
    {
        this->_name = filePath->Name();
        this->_path = filePath->Path();

        status = this->SetJsonDocument(filePath->Path());
    }


    if(status)
    {
        // TODO load the struct
        xString temp = this->_jsonDocument["Directories"]["UserConfig"];
        std::cout << temp << std::endl;

        this->Machine.RepoName = this->_jsonDocument["RepoName"];
        this->Machine.BaseConfig = this->_jsonDocument["BaseConfig"];

        // Directories
        this->Machine.Directories.UserConfig = this->_jsonDocument["Directories"]["UserConfig"];
        this->Machine.Directories.UserCache = this->_jsonDocument["Directories"]["UserCache"];
        this->Machine.Directories.CalendarCache = this->_jsonDocument["Directories"]["CalendarCache"];
        this->Machine.Directories.gitCache = this->_jsonDocument["Directories"]["gitCache"];
        this->Machine.Directories.GreetingsCache = this->_jsonDocument["Directories"]["GreetingsCache"];
        this->Machine.Directories.CalendarFileEventImport = this->_jsonDocument["Directories"]["CalendarFileEventImport"];
        this->Machine.Directories.Classes = this->_jsonDocument["Directories"]["Classes"];

        // Files
        this->Machine.Files.Debug = this->_jsonDocument["Files"]["Debug"];
        this->Machine.Files.Greetings = this->_jsonDocument["Files"]["Greetings"];
        this->Machine.Files.SessionCache = this->_jsonDocument["Files"]["SessionCache"];
        this->Machine.Files.plistConfig = this->_jsonDocument["Files"]["plistConfig"];
        this->Machine.Files.CalendarClassMod = this->_jsonDocument["Files"]["CalendarClassMod"];
        this->Machine.Files.DictionaryCache = this->_jsonDocument["Files"]["DictionaryCache"];

        // Config
        this->Machine.Files.Config.Verioning = this->_jsonDocument["Files"]["Config"]["Versioning"];

        std::cout << this->Machine.Files.Config.Verioning << std::endl;
    }

    this->_status = status;
}
