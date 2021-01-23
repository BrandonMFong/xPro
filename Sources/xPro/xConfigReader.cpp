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
                    nodeUpdateStamp;
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
    }
}
