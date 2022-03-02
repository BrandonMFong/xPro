#!//usr/bin/python3
"""
build.py
======================
Builds source code in src directory
"""

import sys 
import os 
import subprocess
import shutil

## CONSTANTS START ##

# Arguments
DEBUG_ARG:  str = "debug"
HELP_ARG:   str = "--help"

# See if we are in debug mode 
XP_BUILD:           str = "xp"
buildTypeString:    str = "Release"
if DEBUG_ARG in sys.argv:
    buildTypeString = "Debug"
    XP_BUILD        = "debug-{}".format(XP_BUILD)

if sys.platform == "linux" or sys.platform == "linux2":
    platformName = "linux"
elif sys.platform == "darwin":
    platformName = "mac"
elif sys.platform == "win32":
    platformName    = "windows"
    XP_BUILD        = "{}.exe".format(XP_BUILD) # Add .exe for xp build

BUILD_FOLDER:   str = "{} ({})".format(buildTypeString, platformName)
SCRIPT_NAME:    str = os.path.basename(sys.argv[0])
SCRIPT_PATH:    str = os.path.realpath(os.path.dirname(sys.argv[0]))
XPRO_PATH:      str = os.path.dirname(SCRIPT_PATH)
BUILD_PATH:     str = os.path.join(XPRO_PATH, "src", "xpro-cli", BUILD_FOLDER)
BIN_PATH:       str = os.path.join(XPRO_PATH, "bin")

# Remove memory from global access
del buildTypeString
del platformName

## CONSTANTS END ##

## FUNCTION START ##

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
            print("Cleaning up xPro CLI")
            status = subprocess.Popen(
                [ "make", "clean" ], 
                stderr = subprocess.STDOUT
            ).wait()
            
        # Build all
        if status == 0:
            print("Building xPro CLI")
            status = subprocess.Popen(
                [ "make", "all" ], 
                stderr = subprocess.STDOUT
            ).wait()

        if status == 0:
            path = os.path.join(BIN_PATH, XP_BUILD)
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

## FUNCTION END ##

if __name__ == "__main__":
    main()
