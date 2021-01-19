/**
 * @file xConfigReader.cpp
 * 
 * @brief xConfigReader class
 * 
 * @author Brando
 * 
 */

#include <xPro/xConfigReader.h>

xConfigReader::xConfigReader()
{}

xConfigReader::xConfigReader(xString filepath) : xXml(xDefaultConfigRootNodeName,filepath)
{
    xBool result = this->_exists;
    rapidxml::xml_node<>    * root, 
                            * child0,
                            * child1,
                            * child2;
    
    root = this->_xmlDocument.first_node(this->_rootNodeName.c_str()); // Get the root node's xmlnode object
    child0 = root->first_node(); // init with first node of the root node's children 
    while(child0)
    {
        if(child0->name() == "MachineName") this->Machine.MachineName = child0->value(); 
        else if(child0->name() == "LoadProcedure") this->Machine.LoadProcedure = child0->value(); 
        else if(child0->name() == "LoadProfile") this->Machine.LoadProcedure = child0->value();
        else if(child0->name() == "UpdateStamp")
        {
            child1 = child0->first_node();
            while(child1)
            {
                if(child1->name() == "Value") this->Machine.UpdateStamp.Value = child1->value();
            }
        }
        else if(child0->name() == "ShellSettings")
        {
            child1 = child0->first_node();
            while(child1)
            {
                if(child1->name() == "Enabled") this->Machine.ShellSettings.Enabled = child1->value();
                else if(child1->name() == "Prompt")
                {
                    child2 = child1->first_node();
                    while(child2)
                    {
                        if(child2->name() == "Enabled") this->Machine.ShellSettings.Prompt.Enabled = child2->value();
                        // Todo continue with BatteryLifeThreshold
                    }
                }
            }
        }

        child0 = child0->next_sibling();
    }

}
