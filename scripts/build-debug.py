#!//usr/bin/python3
"""
build-debug.py
======================
Builds debug version of source
"""

import sys 
import os 
import subprocess
import shutil

## VARIABLES START ##

status: int = 0
scriptPath: str = os.path.realpath(os.path.dirname(sys.argv[0]))
xproPath: str = os.path.dirname(scriptPath)
xproCLISourcePath: str = "{}/src/xpro-cli/Debug (mac)".format(xproPath)
binPath: str = "{}/bin".format(xproPath)
currDir: str = os.curdir
xpBuild: str = "debug-xp"

## VARIABLES END ##

## START ##

# Change xpro
os.chdir(xproPath)

if os.path.exists(binPath) is False:
    os.mkdir(binPath)

    if os.path.exists(binPath) is False:
        status = 1
        print("Could not create bin folder")

# Change to source directory
os.chdir(xproCLISourcePath)

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
    path = "{}/{}".format(binPath, xpBuild)
    if os.path.exists(path):
        print("Removing old build:", path)
        os.remove(path)

    path = shutil.copy(xpBuild, binPath)
    if path is None:
        status = 1
    else:
        print("Build copy:", path)

# Go back to dir
os.chdir(currDir)

sys.exit(status)

## END ##
