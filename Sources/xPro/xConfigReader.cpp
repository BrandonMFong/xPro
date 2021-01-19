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
                            * child2,
                            * child3;
    
    root = this->_xmlDocument.first_node(this->_rootNodeName.c_str()); // Get the root node's xmlnode object
    child0 = root->first_node(); // init with first node of the root node's children 

    // Machine
    this->Machine.MachineName = child0->first_attribute("MachineName")->value(); 
    this->Machine.LoadProcedure = child0->first_attribute("LoadProcedure")->value(); 
    this->Machine.LoadProcedure = child0->first_attribute("LoadProfile")->value();
    while(child0)
    {
        if(child0->name() == "UpdateStamp") this->Machine.UpdateStamp.Value = child1->first_attribute("Value")->value(); 

        // ShellSettings
        else if(child0->name() == "ShellSettings")
        {
            child1 = child0->first_node();

            while(child1)
            {
                this->Machine.ShellSettings.Enabled = child1->first_attribute("Enabled")->value();
                if(child1->name() == "Prompt")
                {
                    child2 = child1->first_node();

                    // Prompt
                    while(child2)
                    {
                        if(child2->name() == "Enabled") this->Machine.ShellSettings.Prompt.Enabled = child2->first_attribute("Enabled")->value();
                        else if(child2->name() == "BaterryLifeThreshold")
                        {
                            this->Machine.ShellSettings.Prompt.BaterryLifeThreshold.Enabled = child2->first_attribute("Enabled")->value();
                            this->Machine.ShellSettings.Prompt.BaterryLifeThreshold.InnerXml = child3->value();
                        }
                    }
                }

                child1 = child1->next_sibling();
            }
        }

        child0 = child0->next_sibling();
    }

}
