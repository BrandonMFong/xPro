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
    pugi::xml_node  nodeMachine,
                    nodeUpdateStamp,
                    nodeShellSettings,
                    nodePrompt,
                    nodeBaterryLifeThreshold,
                    nodeString,
                    nodeStartDirectory,
                    nodeModules;
    Root::Modules::Mod tempMod;

    if(this->_exists)
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
        
        /* ShellSettings */ 
        nodeModules = nodeMachine.child("Modules");
        for(pugi::xml_node mod : nodeModules.children("Module"))
        {
            tempMod.Name = mod.name();
            tempMod.InnerXml = mod.text().get();
            this->Machine.Modules.Module.push_back(tempMod);
        }
    }
}
