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
RELEASE_ARG:    str = "release"
DEBUG_ARG:      str = "debug"
PACK_ARG:       str = "pack"
BUILD_ARG:      str = "build"
HELP_ARG:       str = "--help"

# See if we are in debug mode 
XP_BUILD: str = "xp"

if sys.platform == "linux" or sys.platform == "linux2":
    PLATFORM_NAME = "linux"
elif sys.platform == "darwin":
    PLATFORM_NAME = "mac"
elif sys.platform == "win32":
    PLATFORM_NAME   = "windows"
    XP_BUILD        = "{}.exe".format(XP_BUILD) # Add .exe for xp build

# Expected path for sym link
# we need this to exist for us to build
if sys.platform == "win32":
    XPRO_LINK_PATH: str = "C:\\Library\\xPro"
else:
    XPRO_LINK_PATH: str = "/Library/xPro"

SCRIPT_NAME:    str = os.path.basename(sys.argv[0])
SCRIPT_PATH:    str = os.path.realpath(os.path.dirname(sys.argv[0]))
XPRO_PATH:      str = SCRIPT_PATH
BIN_PATH:       str = os.path.join(XPRO_PATH, "bin")
DEVENV_SCRIPT:  str = "devenv.py"

## CONSTANTS END ##

## FUNCTION START ##

def help():
    """
    help
    ===================
    Prints help menu
    """
    print("usage: {scriptname} [ {debug} | {release} ] [ {build} ] [ {pack} ] [ {help} ]".format(
        scriptname  = SCRIPT_NAME,
        debug       = DEBUG_ARG,
        help        = HELP_ARG,
        release     = RELEASE_ARG,
        pack        = PACK_ARG,
        build       = BUILD_ARG
    ))

    print()

    print("\t{debug}\tRuns debug type".format(debug=DEBUG_ARG))

    print("\t{release}\tRuns release type".format(release=RELEASE_ARG))

    print("\t{build}\tBuilds the xp binary for either release or debug, depending on the specified.  Default is release".format(build=BUILD_ARG))

    print("\t{pack}\tPacks build and other deliverables".format(pack=PACK_ARG))

    print()
    
    print("See '{scriptname} {help}' for an overview of the system.".format(
        scriptname  = SCRIPT_NAME,
        help        = HELP_ARG
    ))

def build():
    result:             int = 0
    currDir:            str = os.curdir
    buildTypeString:    str = ""
    buildFolder:        str = ""
    buildPath:          str = ""
    buildName:          str = XP_BUILD

    if result == 0:
        if (DEBUG_ARG in sys.argv) and (RELEASE_ARG in sys.argv):
            print("Please choose either '{}' or '{}'".format(
                DEBUG_ARG, RELEASE_ARG
            ))
            result = 1
        elif DEBUG_ARG in sys.argv:
            buildTypeString = "Debug"
            buildName       = "debug-{}".format(buildName)
        elif RELEASE_ARG in sys.argv:
            buildTypeString = "Release"
        else:
            # defaulting to release
            buildTypeString = "Release"

    # Make sure we have the path to build
    if result == 0:
        if os.path.exists(XPRO_LINK_PATH) is False:
            result = 1
            print("We need to have '{}' to build. Please run '{}'".format(
                XPRO_LINK_PATH,
                DEVENV_SCRIPT
            ))
    
    # Change xpro
    os.chdir(XPRO_PATH)

    if result == 0:
        if os.path.exists(BIN_PATH) is False:
            os.mkdir(BIN_PATH)

            if os.path.exists(BIN_PATH) is False:
                result = 1
                print("Could not create bin folder")
    
    if result == 0:
        buildFolder = "{} ({})".format(buildTypeString, PLATFORM_NAME)
        buildPath   = os.path.join(XPRO_PATH, "src", "xpro-cli", buildFolder)

        # Change to source directory
        os.chdir(buildPath)

        # Clean
        print("Cleaning up xPro CLI")
        result = subprocess.Popen(
            [ "make", "clean" ], 
            stderr = subprocess.STDOUT
        ).wait()
        
    # Build all
    if result == 0:
        print("Building xPro CLI")
        result = subprocess.Popen(
            [ "make", "all" ], 
            stderr = subprocess.STDOUT
        ).wait()

    if result == 0:
        path = os.path.join(BIN_PATH, buildName)
        if os.path.exists(path):
            print("Removing old build:", path)
            os.remove(path)

        path = shutil.copy(buildName, BIN_PATH)
        if path is None:
            result = 1
        else:
            print("Build copy:", path)

    # Go back to dir
    os.chdir(currDir)

    return result

def main():
    status: int = 0
    building: bool = True
    packing: bool = True

    if HELP_ARG in sys.argv:
        help()
    else:       
        # Read the arguments

        # If the user specified packaging but did not say we need
        # build, then we will not build
        if PACK_ARG in sys.argv and BUILD_ARG not in sys.argv:
            building = False 

        if status == 0:
            if building:
                status = build()

    sys.exit(status)

## FUNCTION END ##

if __name__ == "__main__":
    main()
