#!//usr/bin/python3
"""
devenv.py
======================
Use this to setup dev environment
"""

import sys 
import os 

## CONSTANTS START ##

# arguments
HELP_ARG: str = "--help"
CREATE_ARG: str = "create"
REMOVE_ARG: str = "remove"

SCRIPT_NAME:    str = os.path.basename(sys.argv[0])
SCRIPT_PATH:    str = os.path.realpath(os.path.dirname(sys.argv[0]))
XPRO_LINK_PATH: str = "/Library/xPro"
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

    if result == 0:
        print("Creating link to {} from {}".format(XPRO_PATH, XPRO_LINK_PATH))
        os.symlink(XPRO_PATH, XPRO_LINK_PATH)

    return result

def remove() -> int:
    result: int = 0

    print("remove")

    return result

def main():
    result: int = 0

    if HELP_ARG in sys.argv:
        help()
    else:
        if os.geteuid() != 0:
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