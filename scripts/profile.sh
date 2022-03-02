# Author: Brando
# Date: 11/16/2021

## CONSTANTS START ##

XPRO_PATH=~/.xpro;
XUTIL_PATH="xutil.sh";

## CONSTANTS END ##

## VARIABLES START ##

result=0;

## VARIABLES END ##

## FUNCTIONS START ##

## brief: Creates bash/zsh variables
##
## returns:
##  - Sets result
function loadObjects() {

    result=0;
}

## FUNCTIONS END ##

## MAIN START ##

pushd $XPRO_PATH >/dev/null 2>&1;

# Add xpro to path 
if [ ! -d $XPRO_PATH ]; then 
    result = 1;
    printf "$XPRO_PATH does not exist\n";
else 
    PATH=$PATH:$XPRO_PATH;
fi 

# Acquire functions and variables from 
# utility script
if [ $result -eq 0 ]; then 
    source $XUTIL_PATH;
    result=$?;
fi 

# Load variables
if [ $result -eq 0 ]; then 
    loadObjects;
fi 

popd >/dev/null 2>&1; # $XPRO_PATH

if [ $result -eq 0 ]; then 
    printf "Successfully loaded xpro\n";
else 
    printf "Failed to load xpro\n";
fi 

## MAIN END ##
