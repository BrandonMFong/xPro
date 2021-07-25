""" 
xPro Installer
================

"""
from xPro.Logger import Logger
from shutil import copyfile as cp 
from enum import Enum 
import os 

log = Logger()

class xError(Enum):
    kUnknownError   = -1
    kNoError        = 0
    kInstallerError = 1
    kShellProfilePathError = 2
    kModuleError = 3
    kModuleCopyError = 4
    kPathError = 5
    kxProHomeDirectoryError = 6
    kModuleHomeDirectoryError = 7

class SystemTypes(Enum):
    Linux = 0
    Mac = 1
    Windows = 2

class Installer():

    kxProDirName = ".xPro"
    kModuleDirName = "modules"
    
    def __init__(self) -> None:
        error               = xError.kNoError
        self._systemType    = None 
        self._scriptPath    = os.path.realpath(__file__)
        self._saveDir       = os.path.abspath(os.getcwd()) 
        self._xproHomeDir   = str()
        self._xproModDir    = str()
        path                = str()

        if error == xError.kNoError:
            self._scriptPath = os.path.dirname(os.path.realpath(__file__))

            if os.path.exists(self._scriptPath) is False:
                error = xError.kPathError

        if error == xError.kNoError:
            os.chdir(self._scriptPath)
            path = os.path.abspath(os.getcwd())

            if self._scriptPath != path:
                error = xError.kPathError

        if error == xError.kNoError:
            error = self.createEnvironment()

        if error != xError.kNoError:
            raise Exception("Init Error for Installer ended in", error)
    
    def createEnvironment(self):
        result = xError.kNoError

        # Create the .xPro directory in the home directory 
        if result == xError.kNoError:
            self._xproHomeDir = os.path.expanduser("~")
            self._xproHomeDir = "{}/{}".format(self._xproHomeDir, self.kxProDirName)
            self._xproHomeDir = os.path.abspath(self._xproHomeDir)

            if os.path.exists(self._xproHomeDir) is False:
                os.mkdir(self._xproHomeDir)

                # Checking if it was successful
                if os.path.exists(self._xproHomeDir) is False:
                    result = xError.kxProHomeDirectoryError

        if result == xError.kNoError:
            self._xproModDir = "{}/{}".format(self._xproHomeDir, self.kModuleDirName)
            self._xproModDir = os.path.abspath(self._xproModDir)

            if os.path.exists(self._xproModDir) is False:
                os.mkdir(self._xproModDir)

                if os.path.exists(self._xproModDir) is False:
                    result = xError.kModuleHomeDirectoryError      

        return result 

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

        if result == xError.kNoError:
            result = self.copyModules()

        if result == xError.kNoError:
            result = self.copyProfile()

        return result 

    def copyProfile(self):
        result = xError.kNoError
        source = str()
        destination = str()

        if result == xError.kNoError:
            source = "{}../profiles/profile.ps1".format(self._scriptPath)
            source = os.path.abspath(source)

            if os.path.exists(source) is False:
                result = xError.kShellProfilePathError
        
        if result == xError.kNoError:
            destination = os.path.expanduser("~")
            destination = "{}/.xpro/profile.ps1".format(destination)

            cp(source, destination)

            if os.path.exists(destination) is False:
                result = xError.kShellProfilePathError
        
        return result 

    def copyModules(self):
        result = xError.kNoError
        source = str()
        destination = str()

        if result == xError.kNoError:
            source = "{}/../lib/powershell/xError.psm1".format(self._scriptPath)
            source = os.path.abspath(source)

            if os.path.exists(source) is False:
                result = xError.kModuleError
        
        if result == xError.kNoError:
            destination = os.path.expanduser("~")
            destination = "{}/.xpro/modules/xError.psm1".format(destination)
            destination = os.path.abspath(destination)

            cp(source, destination)

            if os.path.exists(destination) is False:
                result = xError.kModuleCopyError
        
        return result 

    def finish(self):
        os.chdir(self._saveDir)
            
        
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

    if installer is not None:
        installer.finish()

    if error != xError.kNoError:
        log.Error("Installer ended in ", error)

if __name__ == "__main__":
    main()
