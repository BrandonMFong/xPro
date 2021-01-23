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

protected:
    xBool _result; /** Result of the constructors */
private:
};

#endif