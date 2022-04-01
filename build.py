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
import pdb

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
PACKAGES_PATH:  str = os.path.join(XPRO_PATH, "packages")

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
    """
    build
    ==================
    """
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

def createCopySet(destination: str):
    """
    createCopySet
    ====================
    Creates an array of copy tasks we will be doing 

    Parameters
    ------------------
    destination: The path we will be copying everything to

    Return
    ------------------
    [[source0, destination], [source1, destination], ...]
    """
    result: list = list()
    error: int = 0
    tempPath: str = ""
    tempDest: str = ""
    buildName: str = XP_BUILD

    # Scripts
    if error == 0:
        tempPath = os.path.join(XPRO_PATH, "scripts")
        tempDest = os.path.join(destination, "scripts")
        if os.path.exists(tempPath) is False:
            print("{} does not exist!".format(tempPath))
            result = 1
        else:
            result.append([tempPath, tempDest])

    # Schemas
    if error == 0:
        tempPath = os.path.join(XPRO_PATH, "schema")
        tempDest = os.path.join(destination, "schema")
        if os.path.exists(tempPath) is False:
            print("{} does not exist!".format(tempPath))
            result = 1
        else:
            result.append([tempPath, tempDest])

    # Binary
    if error == 0:
        if DEBUG_ARG in sys.argv:
            buildName = "debug-{}".format(buildName)

        tempPath = os.path.join(XPRO_PATH, "bin", buildName)
        tempDest = os.path.join(destination, buildName)

        if os.path.exists(tempPath) is False:
            print("{} does not exist!".format(tempPath))
            result = 1
        else:
            result.append([tempPath, tempDest])

    return result, error

def pack():
    """
    pack
    ==================
    """
    result: int = 0
    tmpPackagePath: str = os.path.join(PACKAGES_PATH, "tmp")
    copySet: list = list() 

    # Create the packages directory if it already wasn't built
    if result == 0:
        if os.path.exists(PACKAGES_PATH) is False:
            os.mkdir(PACKAGES_PATH)

            if os.path.exists(PACKAGES_PATH) is False:
                result = 1
                print("Could not create package directory")

    # Create the direcory we are going to put all the release 
    # files into
    if result == 0:
        if os.path.exists(tmpPackagePath) is False:
            os.mkdir(tmpPackagePath)

            if os.path.exists(tmpPackagePath) is False:
                result = 1
                print("Could not create package directory")

    if result == 0:
        copySet, result = createCopySet(tmpPackagePath)

    if result == 0:
        print("Packing:")
        for command in copySet:
            if len(command) == 2:
                print("  - {}".format(os.path.basename(command[0])))
                if os.path.isdir(command[0]):
                    shutil.copytree(command[0], command[1])
                else:
                    shutil.copy(command[0], command[1])
            else:
                result = 1
                print("Unexpected amount of arguments")
                break  

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

        # Same thing as above
        if BUILD_ARG in sys.argv and PACK_ARG not in sys.argv:
            packing = False 

        if status == 0 and building:
            status = build()

        if status == 0 and packing:
            status = pack()

    sys.exit(status)

## FUNCTION END ##

if __name__ == "__main__":
    main()
