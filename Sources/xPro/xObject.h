/**
 * @file xObject.h 
 * 
 * @brief xObject class
 * 
 * @author Brando
 */

#ifndef _XOBJECT_
#define _XOBJECT_

#include <xPro/xPro.h>

/**
 * @brief The base object of the xPro framework.  Every object in this framework is a child of this class
 * 
 */
class xObject
{
public:
    /**
     * @brief Construct a new xObject 
     * 
     */
    xObject();

    /**
     * @brief Returns xObject's construction flag.  Should be used outside of the hierarchy
     * 
     * @return xStatus=Bad if constructions failed
     */
    xStatus Status();

    /**
     * @brief The _initiliaized variable is set if a constructor with parameters was called 
     * 
     * @return xBool 
     */
    xBool Initialized();

protected:
    xStatus _status; /** Result of the constructors */

    /**
     * @brief This is variable is false if was initialized with no parameters
     * 
     */
    xBool _isInitialized;
private:
};

#endif