""" 
xPro Installer
================

"""

from shutil import copyfile as cp 
from enum import Enum 
import os 

class xError(Enum):
    kUnknownError   = -1
    kNoError        = 0
    kInstallerError = 1
    kShellProfilePathError = 2

class SystemTypes(Enum):
    Linux = 0
    Mac = 1
    Windows = 2

class Installer():
    
    def __init__(self) -> None:
        error = xError.kNoError
        self._systemType = None 

        if error == xError.kNoError:
            os.chdir(".")

        if error != xError.kNoError:
            raise Exception("Init Error for Installer")

    def setSystemType(self):
        """ 
        Asks the user for the system type 
        """
        result = xError.kNoError

        # TODO: Prompt the user
        if result == xError.kNoError: 
            self._systemType = SystemTypes.Windows

        return result 

    def setup(self):
        result = xError.kNoError
        source = str()
        destination = str()

        if result == xError.kNoError:
            source = "../terminal/powershell/profile.ps1"
            source = os.path.abspath(source)

            if os.path.exists(source) is False:
                result = xError.kShellProfilePathError
        
        if result == xError.kNoError:
            destination = os.path.expanduser("~")
            destination = "{}/.xpro/profile.ps1".format(destination)

            cp(source, destination)

            if os.path.exists(destination) is False:
                result = xError.kShellProfilePathError
        
def main():
    error = xError.kNoError
    installer = None 

    if error == xError.kNoError:
        installer = Installer()
        
        if installer is None:
            error = xError.kInstallerError
    
    if error == xError.kNoError:
        error = installer.setSystemType()

    if error == xError.kNoError:
        error = installer.setup()

if __name__ == "__main__":
    main()
