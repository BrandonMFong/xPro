/**
 * @file xConfigReader.cpp
 * 
 * @brief xConfigReader class
 * 
 * @author Brando
 * 
 */

#include <xPro/xConfigReader.h>

xConfigReader::xConfigReader() : xXml()
{}

xConfigReader::xConfigReader(xString filePath) : xXml(filePath)
{
    // std::cout << filePath << std::endl;
    // std::cout << this->_path << std::endl;
    xStatus status = this->_status;
    xRootConfigReader::Modules::Mod     tempMod;
    xRootConfigReader::Directories::Dir tempDir;
    xRootConfigReader::Programs::Prog   tempProg;
    xRootConfigReader::Objects::Obj     tempObj;
    pugi::xml_node                      nodeMachine,                nodeUpdateStamp,
                                        nodeShellSettings,          nodePrompt,
                                        nodeBaterryLifeThreshold,   nodeString,
                                        nodeStartDirectory,         nodeModules,
                                        nodeDirectories,            nodePrograms,
                                        nodeObjects;

    if(status)
    {
        /* Machine */
        nodeMachine = this->_xmlDocument.child("Machine");
        this->Machine.Name = nodeMachine.name();
        this->Machine.MachineName = nodeMachine.attribute("MachineName").value();
        this->Machine.LoadProcedure = nodeMachine.attribute("LoadProcedure").value();
        this->Machine.LoadProfile = nodeMachine.attribute("LoadProfile").value();
        
        /* UpdateStamp */ 
        nodeUpdateStamp = nodeMachine.child("UpdateStamp");
        this->Machine.UpdateStamp.Name = nodeUpdateStamp.name();
        this->Machine.UpdateStamp.Value = nodeUpdateStamp.attribute("Value").value();
        
        /* ShellSettings */ 
        nodeShellSettings = nodeMachine.child("ShellSettings");
        this->Machine.ShellSettings.Name = nodeShellSettings.name();
        this->Machine.ShellSettings.Enabled = nodeShellSettings.attribute("Enabled").value();

        /* Prompt */ 
        nodePrompt = nodeShellSettings.child("Prompt");
        this->Machine.ShellSettings.Prompt.Name = nodePrompt.name();
        this->Machine.ShellSettings.Prompt.Enabled = nodePrompt.attribute("Enabled").value();

        /* BaterryLifeThreshold */ 
        nodeBaterryLifeThreshold = nodePrompt.child("BaterryLifeThreshold");
        this->Machine.ShellSettings.Prompt.BaterryLifeThreshold.Name = nodeBaterryLifeThreshold.name();
        this->Machine.ShellSettings.Prompt.BaterryLifeThreshold.Enabled = nodeBaterryLifeThreshold.attribute("Enabled").value();
        this->Machine.ShellSettings.Prompt.BaterryLifeThreshold.InnerXml = nodePrompt.child_value("BaterryLifeThreshold");

        /* String */ 
        nodeString = nodePrompt.child("String");
        this->Machine.ShellSettings.Prompt.String.Name = nodeString.name();
        this->Machine.ShellSettings.Prompt.String.Color = nodeString.attribute("Color").value();
        this->Machine.ShellSettings.Prompt.String.InnerXml = nodePrompt.child_value("String");

        /* StartDirectory */ 
        nodeStartDirectory = nodeShellSettings.child("StartDirectory");
        this->Machine.ShellSettings.StartDirectory.Name = nodeStartDirectory.name();
        this->Machine.ShellSettings.StartDirectory.InnerXml = nodeShellSettings.child_value("StartDirectory");
        
        /* Modules */ 
        nodeModules = nodeMachine.child("Modules");
        for(pugi::xml_node mod : nodeModules.children("Module"))
        {
            tempMod.Name = mod.name();
            tempMod.InnerXml = mod.text().get();
            this->Machine.Modules.Module.push_back(tempMod);
        }
        
        /* Directories */ 
        nodeDirectories = nodeMachine.child("Directories");
        for(pugi::xml_node dir : nodeDirectories.children("Directory"))
        {
            tempDir.Name = dir.name();
            tempDir.Alias = dir.attribute("Alias").value();
            tempDir.SecType = dir.attribute("SecType").value();
            tempDir.InnerXml = dir.text().get();
            this->Machine.Directories.Directory.push_back(tempDir);
        }
        
        /* Programs */ 
        nodePrograms = nodeMachine.child("Programs");
        for(pugi::xml_node prog : nodePrograms.children("Program"))
        {
            tempProg.Name = prog.name();
            tempProg.Alias = prog.attribute("Alias").value();
            tempProg.SecType = prog.attribute("SecType").value();
            tempProg.InnerXml = prog.text().get();
            this->Machine.Programs.Program.push_back(tempProg);
        }
        
        /* Objects */ 
        nodeObjects = nodeMachine.child("Objects");
        for(pugi::xml_node obj : nodeObjects.children("Object"))
        {
            tempObj.Name = obj.name();
            tempObj.InnerXml = obj.text().get();

            tempObj.VarName.Name = obj.child("VarName").name();
            tempObj.VarName.SecType = obj.child("VarName").attribute("SecType").value();
            tempObj.VarName.InnerXml = obj.child("VarName").text().get();

            tempObj.SimpleValue.Name = obj.child("SimpleValue").name();
            tempObj.SimpleValue.SecType = obj.child("SimpleValue").attribute("SecType").value();
            tempObj.SimpleValue.InnerXml = obj.child("SimpleValue").text().get();

            this->Machine.Objects.Object.push_back(tempObj);
        }
    }
}
