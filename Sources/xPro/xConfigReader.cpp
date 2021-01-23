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
                    nodeBaterryLifeThreshold;

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
    }
}
