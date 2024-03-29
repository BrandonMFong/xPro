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
import subprocess
import hashlib
import random 
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
BIN_NAME:       str = "bin"
BIN_PATH:       str = os.path.join(XPRO_PATH, BIN_NAME)
DOCS_PATH:      str = os.path.join(XPRO_PATH, "docs")
DEVENV_SCRIPT:  str = "devenv.py"
PACKAGES_PATH:  str = os.path.join(XPRO_PATH, "packages")
ARCHIVE_TYPE:   str = "zip" # 'zip', 'tar', 'gztar', 'bztar', or 'xztar'
HASH_FILE_PATH: str = os.path.join(XPRO_PATH, ".hash")

# Default version string
DEFAULT_VERSION: str = "1.0"

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

def setup():
    """ 
    setup
    ============
    Sets up the build environment
    """

    print("Updating submodules...")

    result = subprocess.Popen(
        [ "git", "submodule", "update", "--recursive" ], 
        stderr = subprocess.STDOUT
    ).wait()

    return result

def createBuildHash():
    """
    createBuildHash
    ===============
    Calculates a random hash and writes the result into a random file that the makefile can get the contents from
    """
    result: int = 0

    # Create the hash string
    hashStr: str = hashlib.sha256(
        str(
            random.getrandbits(256)
        ).encode('utf-8')
    ).hexdigest()[0:40]

    if hashStr == None:
        print("The hash was None")
        result = 1
    elif len(hashStr) == 0:
        print("Received an empty hash")
        result = 1
    

    if result == 0:
        f = open(HASH_FILE_PATH, "w")

        if f == None: 
            result = 1
            print("There was a problem trying to open the hash file to write the build hash, file path: ", HASH_FILE_PATH)
        else:
            f.write(hashStr)

            f.close()

            if os.path.exists(HASH_FILE_PATH) is False: 
                result = 1
                print("Could not create the hash file at:", HASH_FILE_PATH)

    return result 

def cleanUpBuildHash():
    """
    cleanUpBuildHash
    =================

    Removes the build hash file 
    """
    result: int = 0

    if os.path.exists(HASH_FILE_PATH) is False:
        result = 1
        print("The build hash file does not exist")
    else:
        os.remove(HASH_FILE_PATH)

        if os.path.exists(HASH_FILE_PATH):
            result = 1 
            print("The hash file path at {} could not be removed".format(HASH_FILE_PATH))

    return result 

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

    # Setup the dev environment
    if result == 0:
        result = setup()

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

    # Create the build hash that the makefile
    # will read
    if result == 0:
        result = createBuildHash() 
        
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

    # remove the build hash file 
    if result == 0:
        result = cleanUpBuildHash()

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
    result:     list    = list()
    error:      int     = 0
    tempPath:   str     = ""
    tempDest:   str     = ""
    buildName:  str     = XP_BUILD

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

    # Readme
    if error == 0:
        tempPath = os.path.join(DOCS_PATH, "README.md")
        if os.path.exists(tempPath) is False:
            print("{} does not exist!".format(tempPath))
            result = 1
        else:
            result.append([tempPath, destination])

    # Binary
    if error == 0:
        if DEBUG_ARG in sys.argv:
            buildName = "debug-{}".format(buildName)

        tempDest = os.path.join(destination, BIN_NAME)

        if os.path.exists(tempPath) is False:
            print("{} does not exist!".format(tempPath))
            result = 1
        else:
            result.append([BIN_PATH, tempDest])

    return result, error

def getVersionString():
    """
    getVersionString
    ==============
    Gets the version string from the git repo

    The default version string will be 1.0
    """
    result: str = ""
    output: list
    
    process = subprocess.run(
        ['git', 'tag', '-l', '--sort=-creatordate'], 
        stdout  =   subprocess.PIPE, 
        text    =   True
    )

    if process.returncode != 0:
        print(
            "Error getting version, {code}.  Defaulting to {version}", 
            process.returncode, 
            DEFAULT_VERSION
        )

        result = DEFAULT_VERSION  
    else:
        output = process.stdout

        if len(output) == 0:
            result = DEFAULT_VERSION  
            print("No values were returned, will default to:", DEFAULT_VERSION)
        else:
            result = output.split('\n')[0]

    return result

def pack():
    """
    pack
    ==================
    """
    result:             int     = 0
    tmpPackagePath:     str     = os.path.join(PACKAGES_PATH, "tmp")
    copySet:            list    = list() 
    versionString:      str     = ""
    currDir:            str     = os.curdir
    outPath:            str     = ""
    archiveName:        str     = ""
    archiveDestination: str     = ""

    # Create the packages directory if it already wasn't built
    if result == 0:
        if os.path.exists(PACKAGES_PATH) is False:
            os.mkdir(PACKAGES_PATH)

            if os.path.exists(PACKAGES_PATH) is False:
                result = 1
                print("Could not create package directory")
            else:
                os.chdir(PACKAGES_PATH)

    # Make sure the tmp directory does not already exist
    if result == 0:
        if os.path.exists(tmpPackagePath):
            shutil.rmtree(tmpPackagePath)

            if os.path.exists(tmpPackagePath):
                result = 1
                print("Could not remove tmp package directory")

    # Create the direcory we are going to put all the release 
    # files into
    if result == 0:
        os.mkdir(tmpPackagePath)

        if os.path.exists(tmpPackagePath) is False:
            result = 1
            print("Could not create package directory")

    # Create sub directory that I want users to see when unarchiving
    if result == 0:
        # Gets the git version
        versionString = getVersionString() 

        # Create the name of the archive
        archiveName =  "xPro-{version}".format(
            version = versionString
        )

        archiveDestination = os.path.join(tmpPackagePath, archiveName)
        os.mkdir(archiveDestination)

        if os.path.exists(archiveDestination) is False:
            result = 1
            print("Could not create package directory")

    # Create the copy tasks
    if result == 0:
        copySet, result = createCopySet(archiveDestination)

    # Copy all the files
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

    # Create final product path
    if result == 0:
        outPath = os.path.join(
            PACKAGES_PATH, 
            "{base}.{type}".format(
                base    = archiveName,
                type    = ARCHIVE_TYPE
            )
        )

        # Removing old archive
        if os.path.exists(outPath):
            print("Removing old package archive:", outPath)
            os.remove(outPath)

            if os.path.exists(outPath):
                result = 1

    if result == 0:
        # Create the zip archive
        shutil.make_archive(
            os.path.splitext(outPath)[0], 
            ARCHIVE_TYPE, 
            tmpPackagePath
        )

        print("Archive:", outPath)

    # Make sure the tmp directory does not already exist
    if result == 0:
        if os.path.exists(tmpPackagePath):
            shutil.rmtree(tmpPackagePath)

            if os.path.exists(tmpPackagePath):
                result = 1
                print("Could not remove tmp package directory")

    os.chdir(currDir)

    return result 

def main():
    status:     int     = 0
    building:   bool    = True
    packing:    bool    = True

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
