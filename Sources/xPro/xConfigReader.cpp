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
                            * child1,
                            * child2,
                            * child3,
                            * child4;
    
    if(!okayToContinue)  return; 

    // Machine
    root = this->_xmlDocument.first_node(this->_rootNodeName.c_str()); // Get the root node's xmlnode object
    this->Machine.MachineName = root->first_attribute("MachineName")->value(); 
    this->Machine.LoadProcedure = root->first_attribute("LoadProcedure")->value(); 
    this->Machine.LoadProcedure = root->first_attribute("LoadProfile")->value();

    // Machine
    child1 = root->first_node("UpdateStamp");
    this->Machine.UpdateStamp.Value = child1->first_attribute("Value")->value(); 

    // ShellSettings
    child2 = child1->first_node("ShellSettings");
    this->Machine.ShellSettings.Enabled = child2->first_attribute("Enabled")->value();

    // Prompt
    child3 = child2->first_node("Prompt");
    this->Machine.ShellSettings.Prompt.Enabled = child3->first_attribute("Enabled")->value();

    // BaterryLifeThreshold
    child4 = child3->first_node("BaterryLifeThreshold");
    this->Machine.ShellSettings.Prompt.BaterryLifeThreshold.Enabled = child4->first_attribute("Enabled")->value();
    this->Machine.ShellSettings.Prompt.BaterryLifeThreshold.InnerXml = child4->value();

    // String
    child4 = child3->first_node("String");
    this->Machine.ShellSettings.Prompt.BaterryLifeThreshold.Enabled = child4->first_attribute("Color")->value();
    this->Machine.ShellSettings.Prompt.BaterryLifeThreshold.InnerXml = child4->value();

    // StartDirectory
    child3 = child2->first_node("StartDirectory");
    this->Machine.ShellSettings.StartDirectory.InnerXml = child3->value();

    // Modules
    child2 = child1->first_node("Modules");
    child3 = child2->first_node("Module");
    Root::Modules::Mod * tempMod;
    while(child3)
    {
        tempMod = new Root::Modules::Mod(); // new object
        tempMod->InnerXml = child3->value(); // Get the value
        this->Machine.Modules.Module.push_back(*tempMod); // insert into array 

        child3 = child3->next_sibling();
    }

    // Directories
    child2 = child1->first_node("Directories");
    child3 = child2->first_node("Directory");
    Root::Directories::Dir * tempDir;
    while(child3)
    {
        tempDir = new Root::Directories::Dir; // new object
        tempDir->Alias = child3->first_attribute("Alias")->value();
        tempDir->SecType = child3->first_attribute("SecType")->value();
        tempDir->InnerXml = child3->value(); // Get the value
        this->Machine.Directories.Directory.push_back(*tempDir); // insert into array 

        child3 = child3->next_sibling();
    }

    // Programs
    child2 = child1->first_node("Programs");
    child3 = child2->first_node("Program");
    Root::Programs::Prog * tempProg;
    while(child3)
    {
        tempProg = new Root::Programs::Prog; // new object
        tempProg->Alias = child3->first_attribute("Alias")->value();
        tempProg->SecType = child3->first_attribute("SecType")->value();
        tempProg->InnerXml = child3->value(); // Get the value
        this->Machine.Programs.Program.push_back(*tempProg); // insert into array 

        child3 = child3->next_sibling();
    }

    // Objects
    child2 = child1->first_node("Objects");
    child3 = child2->first_node("Object");
    Root::Objects::Obj * tempObj;
    while(child3)
    {
        tempObj = new Root::Objects::Obj;
        tempObj->Type = child3->first_attribute("Type")->value();
        
        child4 = child3->first_node("VarName");
        tempObj->VarName.SecType = child4->first_attribute("SecType")->value();
        tempObj->VarName.InnerXml = child4->value();

        child4 = child3->first_node("SimpleValue");
        tempObj->SimpleValue.SecType = child4->first_attribute("SecType")->value();
        tempObj->SimpleValue.InnerXml = child4->value();

        this->Machine.Objects.Object.push_back(*tempObj);

        child3 = child3->next_sibling();
    }
    child3.
}
