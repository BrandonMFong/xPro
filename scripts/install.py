#!//usr/bin/python3
"""
install.py
======================
Installs xPro to user's environment
"""

__author__ = "Brando"
__date__ = "11/14/2021"

from    io import FileIO
import  sys 
import  os 
import  shutil

## CONSTANTS START ##

# arguments
HELP_ARG:           str = "--help"
PROFILE_PATH_ARG:   str = "--profile"

# File system items
# xp bin name
if sys.platform == "win32":
    XP_BUILD: str = "xp.exe"
else:
    XP_BUILD: str = "xp"

# Shell profile
if sys.platform == "linux" or sys.platform == "linux2":
    SHELL_PROFILE_NAME: str = ".bashrc"
elif sys.platform == "darwin":
    SHELL_PROFILE_NAME: str = ".zshrc"
elif sys.platform == "win32":
    SHELL_PROFILE_NAME: str = "profile.ps1"

# util name
if sys.platform in ["linux", "linux2", "darwin"]:
    UTIL_NAME: str = "xutil.sh"
elif sys.platform == "win32":
    UTIL_NAME: str = "xutil.psm1"

# Profile name
if sys.platform == "win32":
    XPRO_PROFILE_NAME: str = "profile.ps1"
else:
    XPRO_PROFILE_NAME: str = "profile.sh"

XPRO_DIR_NAME:          str = ".xpro"
XPRO_SHELL_REL_PATH:    str = os.path.join(XPRO_DIR_NAME, XPRO_PROFILE_NAME)
SCRIPT_NAME:            str = os.path.basename(sys.argv[0])
SCRIPT_PATH:            str = os.path.realpath(os.path.dirname(sys.argv[0]))
XPRO_PATH:              str = os.path.dirname(SCRIPT_PATH)
XPRO_BIN_PATH:          str = os.path.join(XPRO_PATH, "bin")
HOME_DIR:               str = os.path.expanduser("~")
XPRO_HOME_PATH:         str = os.path.join(HOME_DIR, XPRO_DIR_NAME)
PROJ_PROFILE_PATH:      str = os.path.join(XPRO_PATH, "scripts", XPRO_PROFILE_NAME)
UTIL_PATH:              str = os.path.join(XPRO_PATH, "scripts", UTIL_NAME)

# Determining the path to shell profile
if sys.platform == "win32":
    SHELL_PROFILE_PATH: str = ""
    if HELP_ARG not in sys.argv:
        if PROFILE_PATH_ARG in sys.argv:
            SHELL_PROFILE_PATH = sys.argv[sys.argv.index(PROFILE_PATH_ARG) + 1]
        else:
            raise Exception("Windows installation requires user to profile path to {} arg".format(PROFILE_PATH_ARG)) 
else:
    SHELL_PROFILE_PATH: str = os.path.join(HOME_DIR, SHELL_PROFILE_NAME)

# statement to source shell profile
PROFILE_START_STR:  str = "\n###### XPRO START ######"

if sys.platform == "win32":
    IF_STATEMENT_STR:   str = "\nif (Test-Path -Path ~\\{}) {{".format(XPRO_SHELL_REL_PATH)
    SOURCE_XPRO_PROF:   str = "\n\t. ~\\{}".format(XPRO_SHELL_REL_PATH)
    FI_STATEMENT_STR:   str = "\n}"
else:
    IF_STATEMENT_STR:   str = "\nif [ -f ~/{} ]; then".format(XPRO_SHELL_REL_PATH)
    SOURCE_XPRO_PROF:   str = "\n\tsource ~/{}".format(XPRO_SHELL_REL_PATH)
    FI_STATEMENT_STR:   str = "\nfi"

PROFILE_END_STR:    str = "\n###### XPRO END ######\n"

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
    print("usage: {scriptname} [ {profilePath} <Full path to profile> ] [ {help} ]".format(
        scriptname  = SCRIPT_NAME,
        help        = HELP_ARG,
        profilePath = PROFILE_PATH_ARG
    ))

    print()

    print("Arguments:")

    # Profile Path Argument
    print(
        "\t[ {} ] : Only include value for this item if you are running on a windows system".format(
            PROFILE_PATH_ARG
        )
    )

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
    global      copySet
    result:     int = 0
    tempString: str 

    if os.path.exists(XPRO_BIN_PATH) is False:
        print("{} does not exist".format(XPRO_BIN_PATH))
        result = 1

    # Create task to copy bin
    if result == 0:
        tempString = os.path.join(XPRO_BIN_PATH, XP_BUILD) 

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

        path = os.path.join(XPRO_HOME_PATH, XP_BUILD)
        if os.path.exists(path):
            print("Removing existing '{}' at '{}'".format(XP_BUILD, XPRO_HOME_PATH))
            os.remove(path)
        
        if result == 0:
            copySet.append([tempString, XPRO_HOME_PATH])

    # copy shell profile no matter what
    if result == 0:
        if os.path.exists(PROJ_PROFILE_PATH) is False:
            print("{} does not exist!".format(PROJ_PROFILE_PATH))
            result = 1
        else:
            copySet.append([PROJ_PROFILE_PATH, XPRO_HOME_PATH])

    # copy shell utilities no matter what
    if result == 0:
        if os.path.exists(UTIL_PATH) is False:
            print("{} does not exist!".format(PROJ_PROFILE_PATH))
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
    result:     int = 0
    fp:         FileIO
    foundLine:  bool = False

    # Only read if profile already exists
    if os.path.exists(SHELL_PROFILE_PATH):
        fp = open(SHELL_PROFILE_PATH, 'r')

        if fp is None:
            result = 1
            print("Could not open {}".format(SHELL_PROFILE_PATH))

        # See if the lines already exist
        if result == 0:
            foundLine = False
            for line in fp.readlines():
                if SOURCE_XPRO_PROF.strip() in line:
                    foundLine = True
                    break 
            
            fp.close()

    if result == 0:
        fp = open(SHELL_PROFILE_PATH, 'a')
        
        if fp is None:
            result = 1
            print("Could not open {}".format(SHELL_PROFILE_PATH))
    
    # Write the line to source xpro profile
    if result == 0:
        if foundLine is False:
            fp.write(PROFILE_START_STR)
            fp.write(IF_STATEMENT_STR)
            fp.write(SOURCE_XPRO_PROF)
            fp.write(FI_STATEMENT_STR)
            fp.write(PROFILE_END_STR)

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
