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
    xBool okayToContinue = this->_exists;
    rapidxml::xml_node<>    * root, 
                            * child0,
                            * child1,
                            * child2,
                            * child3;
    
    if(!okayToContinue)  return; 

    root = this->_xmlDocument.first_node(this->_rootNodeName.c_str()); // Get the root node's xmlnode object
    child0 = root->first_node("Machine"); // init with first node of the root node's children 

    std::cout << "Test" << std::endl;
    this->Machine.MachineName = child0->first_attribute("MachineName")->value(); 
    this->Machine.LoadProcedure = child0->first_attribute("LoadProcedure")->value(); 
    this->Machine.LoadProcedure = child0->first_attribute("LoadProfile")->value();

    child1 = child0->first_node("UpdateStamp");
    while(child1)
    {
        // UpdateStamp
        if(strcmp(child1->name(),"UpdateStamp") == 0) this->Machine.UpdateStamp.Value = child1->first_attribute("Value")->value(); 

        // ShellSettings
        else if(strcmp(child1->name(),"ShellSettings") == 0)
        {
            child2 = child1->first_node();

            this->Machine.ShellSettings.Enabled = child2->first_attribute("Enabled")->value();

            while(child2)
            {
                if(strcmp(child2->name(),"Prompt") == 0)
                {
                    child3 = child2->first_node();

                    this->Machine.ShellSettings.Prompt.Enabled = child3->first_attribute("Enabled")->value();

                    while(child3)
                    {
                        if(strcmp(child3->name(),"BaterryLifeThreshold") == 0)
                        {
                            this->Machine.ShellSettings.Prompt.BaterryLifeThreshold.Enabled = child3->first_attribute("Enabled")->value();
                            this->Machine.ShellSettings.Prompt.BaterryLifeThreshold.InnerXml = child3->value();
                        }
                        else if(strcmp(child3->name(),"String") == 0)
                        {
                            this->Machine.ShellSettings.Prompt.String.Color = child3->first_attribute("Color")->value();
                            this->Machine.ShellSettings.Prompt.String.InnerXml = child3->value();
                        }
                    }
                }
                else if(strcmp(child2->name(),"StartDirectory") == 0) this->Machine.ShellSettings.StartDirectory.InnerXml = child2->value();

                child2 = child2->next_sibling();
            }
        }

        // Modules
        else if(strcmp(child1->name(),"Modules") == 0)
        {
            child2 = child1->first_node();

            Root::Modules::Mod * tempMod;
            while(child2)
            {
                tempMod = new Root::Modules::Mod(); // new object
                tempMod->InnerXml = child2->value(); // Get the value
                this->Machine.Modules.Module.push_back(*tempMod); // insert into array 

                child2 = child2->next_sibling();
            }
        }

        // Directories
        else if(strcmp(child1->name(),"Directories") == 0)
        {
            child2 = child1->first_node();

            Root::Directories::Dir * tempDir;
            while(child2)
            {
                tempDir = new Root::Directories::Dir; // new object
                tempDir->Alias = child2->first_attribute("Alias")->value();
                tempDir->SecType = child2->first_attribute("SecType")->value();
                tempDir->InnerXml = child2->value(); // Get the value
                this->Machine.Directories.Directory.push_back(*tempDir); // insert into array 

                child2 = child2->next_sibling();
            }
        }

        // Programs
        else if(strcmp(child1->name(),"Programs") == 0)
        {
            child2 = child1->first_node();

            Root::Programs::Prog * tempProg;
            while(child2)
            {
                tempProg = new Root::Programs::Prog; // new object
                tempProg->Alias = child2->first_attribute("Alias")->value();
                tempProg->SecType = child2->first_attribute("SecType")->value();
                tempProg->InnerXml = child2->value(); // Get the value
                this->Machine.Programs.Program.push_back(*tempProg); // insert into array 

                child2 = child2->next_sibling();
            }
        }

        else if(strcmp(child1->name(),"Objects") == 0)
        {
            child2 = child1->first_node();

            Root::Objects::Obj * tempObj;
            while(child2)
            {
                child3 = child2->first_node();

                tempObj = new Root::Objects::Obj;
                tempObj->Type = child2->first_attribute("Type")->value();
                
                while(child3)
                {
                    if(strcmp(child3->name(),"VarName") == 0)
                    {
                        tempObj->VarName.SecType = child3->first_attribute("SecType")->value();
                        tempObj->VarName.InnerXml = child3->value();
                    }
                    else if(strcmp(child3->name(),"SimpleValue") == 0)
                    {
                        tempObj->SimpleValue.SecType = child3->first_attribute("SecType")->value();
                        tempObj->SimpleValue.InnerXml = child3->value();
                    }

                    child3 = child3->next_sibling();
                }

                this->Machine.Objects.Object.push_back(*tempObj);

                child2 = child2->next_sibling();
            }
        }

        child1 = child1->next_sibling();
    }
}
