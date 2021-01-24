/**
 * @file xAppPointer.cpp
 * @author Brando (BrandonMFong.com)
 * @brief 
 * @date 2021-01-23
 * 
 * @copyright Copyright (c) 2021
 * 
 */

#include <xPro/xAppPointer.h>

xAppPointer::xAppPointer() : xXml(kHomeProfilePath)
{
    xStatus status = this->_status;
    pugi::xml_node  nodeMachine,
                    nodeGitRepoDir,
                    nodeConfigFile;

    // if(status)
    // {
    //     // dProfileXmlPath has ~ and pugixml does not like it
    //     status = this->SetXmlDocument(this->_path);
    // }

    if(status)
    {
        /* Machine */
        nodeMachine = this->_xmlDocument.child("Machine");
        this->Machine.Name = nodeMachine.name();
        this->Machine.MachineName = nodeMachine.attribute("MachineName").value();

        /* GitRepoDir */
        nodeGitRepoDir = nodeMachine.child("GitRepoDir");
        this->Machine.GitRepoDir.Name = nodeGitRepoDir.name();
        this->Machine.GitRepoDir.InnerXml = nodeMachine.child_value("GitRepoDir");

        /* GitRepoDir */
        nodeConfigFile = nodeMachine.child("ConfigFile");
        this->Machine.ConfigFile.Name = nodeConfigFile.name();
        this->Machine.ConfigFile.InnerXml = nodeMachine.child_value("ConfigFile");
    }

    this->_status = status;
}

// TODO put this in xObject
xString xAppPointer::ToString()
{
    xString result = xEmptyString;

    result = this->Machine.GitRepoDir.InnerXml + dUserConfigDirectoryPath + this->Machine.ConfigFile.InnerXml;

    return result;
}

xAppPointer::operator std::string()
{
    return this->ToString();
}