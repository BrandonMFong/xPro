#!//usr/bin/python3
"""
install.py
======================
Installs xPro to user's environment
"""

__author__ = "Brando"
__date__ = "11/14/2021"

from io import FileIO
import sys 
import os 
import subprocess
import shutil

## CONSTANTS START ##

# arguments
HELP_ARG:           str = "--help"
RELEASE_BUILD_ARG:  str = "-r"
DEBUG_BUILD_ARG:    str = "-d"

# File system items
SCRIPT_NAME:        str = os.path.basename(sys.argv[0])
SCRIPT_PATH:        str = os.path.realpath(os.path.dirname(sys.argv[0]))
XPRO_PATH:          str = os.path.dirname(SCRIPT_PATH)
XPRO_BIN_PATH:      str = "{}/bin".format(XPRO_PATH)
BUILD_MAC_DEBUG:    str = "build-mac-debug"
BUILD_MAC_RELEASE:  str = "build-mac-release"
XPRO_DIR_NAME:      str = ".xpro"
HOME_DIR:           str = os.path.expanduser("~")
XPRO_HOME_PATH:     str = "{}/{}".format(HOME_DIR, XPRO_DIR_NAME)
XPRO_DEBUG_BUILD:   str = "debug-xp"
XPRO_RELEASE_BUILD: str = "xp"
PROFILE_NAME:       str = "profile.sh"
XPRO_PROFILE_PATH:  str = "{}/scripts/{}".format(XPRO_PATH, PROFILE_NAME)
ZSH_PROFILE_NAME:   str = ".zprofile"
ZSH_PROFILE_PATH:   str = "{}/{}".format(HOME_DIR, ZSH_PROFILE_NAME)
# ENV_CONFIG_NAME:    str = "env.xml"
# ENV_CONFIG_PATH:    str = "{}/config/{}".format(XPRO_PATH, ENV_CONFIG_NAME)
UTIL_NAME:          str = "xutil.sh"
UTIL_PATH:          str = "{}/scripts/{}".format(XPRO_PATH, UTIL_NAME)

SOURCE_XPRO_PROF:   str = "source ~/.xpro/profile.sh"
PROFILE_START_STR:  str = "###### XPRO START ######"
PROFILE_END_STR:    str = "###### XPRO END ######"

## CONSTANTS END ##

## VARIABLES START ##

# Each object in index has two elements: [source, destination]
# Use this to copy and setup user env
copySet: list = list() 

## VARIABLES END ##

## FUNCTION START ##

def help():
    """
    help
    ===================
    Prints help menu
    """
    print("usage: {scriptname} [ {help} ]".format(
        scriptname  = SCRIPT_NAME,
        help        = HELP_ARG
    ))

    print()
    
    print("\t{scriptname} [ {release} | {debug} ]: If passed, all makefiles will be ran to generate a clean build. Default mode is release".format(
        scriptname  = SCRIPT_NAME, 
        release     = RELEASE_BUILD_ARG, 
        debug       = DEBUG_BUILD_ARG
    ))

    print()

    print("See '{scriptname} {help}' for an overview of the system.".format(
        scriptname  = SCRIPT_NAME,
        help        = HELP_ARG
    ))

def checkDependencies() -> int: 
    """
    checkDependencies
    ================
    Before we attempt to setup the environment, we need to make sure we have everything
    """
    global copySet
    result: int = 0
    tempString: str 

    if os.path.exists(XPRO_BIN_PATH) is False:
        print("{} does not exist".format(XPRO_BIN_PATH))
        result = 1

    # Create task to copy bin
    if result == 0:
        if RELEASE_BUILD_ARG in sys.argv:
            bin = XPRO_RELEASE_BUILD
        elif DEBUG_BUILD_ARG is sys.argv:
            bin = XPRO_DEBUG_BUILD
        else:
            bin = XPRO_RELEASE_BUILD # default

        tempString = "{}/{}".format(XPRO_BIN_PATH, bin) 

        if os.path.exists(tempString) is False:
            print("{} does not exist!".format(tempString))
            result = 1

    if result == 0:
        # Create xpro home path if it does not exist
        if os.path.exists(XPRO_HOME_PATH) is False:
            os.mkdir(XPRO_HOME_PATH)

            if os.path.exists(XPRO_HOME_PATH) is False:
                result = 1
                print("Could not create directory {}".format(XPRO_HOME_PATH))

        if os.path.exists("{}/{}".format(XPRO_HOME_PATH, bin)):
            print("Removing existing '{}' at '{}'".format(bin, XPRO_HOME_PATH))
            os.remove("{}/{}".format(XPRO_HOME_PATH, bin))
        
        if result == 0:
            copySet.append([tempString, XPRO_HOME_PATH])

    # copy shell profile no matter what
    if result == 0:
        if os.path.exists(XPRO_PROFILE_PATH) is False:
            print("{} does not exist!".format(XPRO_PROFILE_PATH))
            result = 1
        else:
            copySet.append([XPRO_PROFILE_PATH, XPRO_HOME_PATH])

    # copy shell utilities no matter what
    if result == 0:
        if os.path.exists(UTIL_PATH) is False:
            print("{} does not exist!".format(XPRO_PROFILE_PATH))
            result = 1
        else:
            copySet.append([UTIL_PATH, XPRO_HOME_PATH])

    return result

def modifyShellProfile() -> int:
    """
    sourceXProInShellProfile
    ========================
    Inserts command to source xpro profile
    """
    result: int = 0
    fp: FileIO

    # Only read if profile already exists
    if os.path.exists(ZSH_PROFILE_PATH):
        fp = open(ZSH_PROFILE_PATH, 'r')

        if fp is None:
            result = 1
            print("Could not open {}".format(ZSH_PROFILE_PATH))

        # See if the lines already exist
        if result == 0:
            foundLine = False
            for line in fp.readlines():
                if SOURCE_XPRO_PROF in line:
                    foundLine = True
                    break 
            
            fp.close()

    if result == 0:
        fp = open(ZSH_PROFILE_PATH, 'a')
        
        if fp is None:
            result = 1
            print("Could not open {}".format(ZSH_PROFILE_PATH))
    
    # Write the line to source xpro profile
    if result == 0:
        if foundLine is False:
            fp.write("\n{}\n".format(PROFILE_START_STR))
            fp.write("{}".format(SOURCE_XPRO_PROF))
            fp.write("\n{}\n\n".format(PROFILE_END_STR))

        fp.close()

    return result 

def install() -> int:
    """
    install
    ===============
    Installs application to home directory 
    """
    result: int = 0
    
    os.chdir(XPRO_PATH)
    path = os.getcwd()

    if path != XPRO_PATH:
        result = 1
        print("Current path is not {}.  Unexpected behavior".format(XPRO_PATH))

    if result == 0:
        result = checkDependencies()

    if result == 0:
        print("Installing:")
        for command in copySet:
            if len(command) == 2:
                print("  - {}".format(os.path.basename(command[0])))
                shutil.copy(command[0], command[1])
            else:
                result = 1
                print("Unexpected amount of arguments")
                break 

    if result == 0:
        result = modifyShellProfile()

    return result 

def main():
    result: int = 0

    if HELP_ARG in sys.argv:
        help()
    else:
        result = install()

        if result == 0:
            print("Install complete")
        else:
            print("Install Failed")

    sys.exit(result)

## FUNCTION END ##

if __name__ == "__main__":
    main()
