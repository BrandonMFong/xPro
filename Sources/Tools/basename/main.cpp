/**
 * @file xpro.filename
 * 
 * @brief returns returns file name
 * 
 * @author Brando (BrandonMFong.com)
 */

#include <xPro/xPro.h>

xMain

    xFile * file;

    file = new xFile(argv[1]);

    std::cout << file->Name() << std::endl;

xReturn 