""" 
xPro Installer
================


"""

from enum import Enum 

class xError(Enum):
    kUnknownError = -1
    kNoError = 0

class SystemTypes(Enum):
    Linux = 0
    Mac = 1
    Windows = 2

class Installer():
    
    def __init__(self) -> None:
        pass 

def main():
    error = xError.kNoError

    if error == xError.kNoError:
        pass 

if __name__ == "__main__":
    main()
