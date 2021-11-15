#!//usr/bin/python3
"""
install.py
======================
Installs xPro to user's environment
"""

__author__ = "Brando"
__date__ = "11/14/2021"

import sys 
import os 
import subprocess

## VARIABLES START ##

# arguments
HELP_ARG: str    = "--help"
BUILD_ARG: str   = "build"
RELEASE_BUILD_ARG: str = "-r"
DEBUG_BUILD_ARG: str = "-d"

SCRIPT_NAME: str = os.path.basename(sys.argv[0])
SCRIPT_PATH: str = os.path.realpath(os.path.dirname(sys.argv[0]))
BUILD_MAC_DEBUG: str = "build-mac-debug"
BUILD_MAC_RELEASE: str = "build-mac-release"

## VARIABLES END ##

## FUNCTION START ##

def help():
    """
    help
    ===================
    Prints help menu
    """
    print("usage: {scriptname} [ {build} ] [ {help} ]".format(
        scriptname  = SCRIPT_NAME,
        build       = BUILD_ARG,
        help        = HELP_ARG
    ))

    print()
    
    print("\t{scriptname} {build} [ {release} | {debug} ]: If passed, all makefiles will be ran to generate a clean build. Default mode is release".format(
        scriptname = SCRIPT_NAME, 
        build = BUILD_ARG,
        release = RELEASE_BUILD_ARG, 
        debug = DEBUG_BUILD_ARG
    ))

    print()

    print("See '{scriptname} {help}' for an overview of the system.".format(
        scriptname  = SCRIPT_NAME,
        help        = HELP_ARG
    ))

def build() -> int: 
    """
    build
    ================
    Runs build scripts
    """
    result:             int = 0
    indexForBuildArg:   int = sys.argv.index(BUILD_ARG)
    buildTypeArg:       str
    buildScript:        str

    if indexForBuildArg <= 0:
        result = 1
        print("index for {BUILD_ARG} is {indexForBuildArg}")

    if result == 0:
        if (indexForBuildArg + 1) < len(sys.argv):
            buildTypeArg = sys.argv[indexForBuildArg + 1]

            if buildTypeArg == DEBUG_BUILD_ARG:
                buildScript = BUILD_MAC_DEBUG
            elif buildTypeArg == RELEASE_BUILD_ARG:
                buildScript = BUILD_MAC_RELEASE 
            else: 
                print("Unknown argument {}".format(buildTypeArg))
                result = 1
        else:
            buildScript = BUILD_MAC_RELEASE 

    if result == 0:
        buildScript = "{}/{}".format(
            SCRIPT_PATH, buildScript
        ) 

        if os.path.exists(buildScript) is False:
            result = 1
            print("{} does not exist, please check environment".format(buildScript))

    if result == 0:
        result = subprocess.Popen(
            [ buildScript ], 
            stderr = subprocess.STDOUT
        ).wait()

    return result 

def install() -> int:
    """
    install
    ===============
    Installs application to home directory 
    """
    result: int = 0

    print("install")

    return result 

def main():
    result: int = 0

    if HELP_ARG in sys.argv:
        help()
    else:
        if BUILD_ARG in sys.argv:
            result = build()

        if result == 0:
            result = install()

        if result == 0:
            print("Success")
        else:
            print("Failed")

    sys.exit(result)

## FUNCTION END ##

if __name__ == "__main__":
    main()
