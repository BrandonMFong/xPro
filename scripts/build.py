#!//usr/bin/python3
"""
build-debug.py
======================
Builds debug version of source

Parameters
----------------
Pass debug to build debug.  Otherwise will just build release
"""

import sys 
import os 
import subprocess
import shutil

## CONSTANTS START ##

# Arguments
DEBUG_ARG: str = "debug"
HELP_ARG: str = "--help"

BUILD_FOLDER: str = "Debug (mac)"
SCRIPT_NAME: str = os.path.basename(sys.argv[0])
SCRIPT_PATH: str = os.path.realpath(os.path.dirname(sys.argv[0]))
XPRO_PATH: str = os.path.dirname(SCRIPT_PATH)
BUILD_PATH: str = "{}/src/xpro-cli/{}".format(XPRO_PATH, BUILD_FOLDER)
BIN_PATH: str = "{}/bin".format(XPRO_PATH)
XP_BUILD: str = "debug-xp"

## CONSTANTS END ##

def help():
    """
    help
    ===================
    Prints help menu
    """
    print("usage: {scriptname} [ {debug} ] [ {help} ]".format(
        scriptname  = SCRIPT_NAME,
        debug       = DEBUG_ARG,
        help        = HELP_ARG
    ))

    print()

    print("\t{debug}\tBuild debug version".format(debug=DEBUG_ARG))

def main():
    status:     int = 0
    currDir:    str = os.curdir

    if HELP_ARG in sys.argv:
        help()
    else:
        # Change xpro
        os.chdir(XPRO_PATH)

        if os.path.exists(BIN_PATH) is False:
            os.mkdir(BIN_PATH)

            if os.path.exists(BIN_PATH) is False:
                status = 1
                print("Could not create bin folder")

        # Change to source directory
        os.chdir(BUILD_PATH)

        # Clean
        if status == 0:
            print("Building xPro CLI (debug)")
            status = subprocess.Popen(
                [ "make", "clean" ], 
                stderr = subprocess.STDOUT
            ).wait()
            
        # Build all
        if status == 0:
            print("Building xPro CLI (debug)")
            status = subprocess.Popen(
                [ "make", "all" ], 
                stderr = subprocess.STDOUT
            ).wait()

        if status == 0:
            path = "{}/{}".format(BIN_PATH, XP_BUILD)
            if os.path.exists(path):
                print("Removing old build:", path)
                os.remove(path)

            path = shutil.copy(XP_BUILD, BIN_PATH)
            if path is None:
                status = 1
            else:
                print("Build copy:", path)

        # Go back to dir
        os.chdir(currDir)

    sys.exit(status)

if __name__ == "__main__":
    main()

## END ##
