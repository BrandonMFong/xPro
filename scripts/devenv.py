#!//usr/bin/python3
"""
devenv.py
======================
Use this to setup dev environment
"""

import sys 
import os 
import ctypes

## CONSTANTS START ##

# arguments
HELP_ARG: str = "--help"
CREATE_ARG: str = "create"
REMOVE_ARG: str = "remove"

if sys.platform == "win32":
    XPRO_LINK_PATH: str = "C:\\Library\\xPro"
else:
    XPRO_LINK_PATH: str = "/Library/xPro"

SCRIPT_NAME:    str = os.path.basename(sys.argv[0])
SCRIPT_PATH:    str = os.path.realpath(os.path.dirname(sys.argv[0]))
XPRO_PATH:      str = os.path.dirname(SCRIPT_PATH)

## CONSTANTS END ##

def help():
    """
    help
    ===================
    Prints help menu
    """
    print("usage: {scriptname} [ {create} | {remove} ] [ {help} ]".format(
        scriptname  = SCRIPT_NAME,
        create      = CREATE_ARG, 
        remove      = REMOVE_ARG,
        help        = HELP_ARG
    ))

    print()

def isAdmin() -> bool:
    """
    isAdmin
    =========
    Checks if user is running as sudo (unix) or admin (windows)
    """
    try:
        return os.getuid() == 0
    except AttributeError:
        return ctypes.windll.shell32.IsUserAnAdmin() != 0

def create() -> int:
    """
    create
    ==============
    Creates xpro symbolic link
    """
    result: int = 0
    
    if os.path.isdir(XPRO_LINK_PATH):
        print("{} already exists as a directory!".format(XPRO_LINK_PATH))
        result = 1
    elif os.path.isfile(XPRO_LINK_PATH):
        print("{} already exists as a file!".format(XPRO_LINK_PATH))
        result = 1

    # Create the /Library or C:\Library path 
    if result == 0:
        if os.path.isdir(os.path.dirname(XPRO_LINK_PATH)) is False:
            os.mkdir(os.path.dirname(XPRO_LINK_PATH))

            if os.path.isdir(os.path.dirname(XPRO_LINK_PATH)) is False:
                print("Error trying to create {}". os.path.dirname(XPRO_LINK_PATH))
                result = 1

    if result == 0:
        print("Creating link to {} from {}".format(XPRO_PATH, XPRO_LINK_PATH))
        os.symlink(XPRO_PATH, XPRO_LINK_PATH)

    return result

def remove() -> int:
    result: int = 0

    if os.path.exists(XPRO_LINK_PATH):
        print("Removing {}".format(XPRO_LINK_PATH))
        os.remove(XPRO_LINK_PATH)

    return result

def main():
    result: int = 0

    if HELP_ARG in sys.argv:
        help()
    else:
        if isAdmin() is False:
            print("Please run script with sudo")
            result = 1

    if result == 0:
        if CREATE_ARG in sys.argv:
            result = create()
        elif REMOVE_ARG in sys.argv:
            result = remove()
        else:
            help()

    sys.exit(result)

if __name__ == "__main__":
    main()