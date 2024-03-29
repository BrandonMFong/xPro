# Author: Brando
# Date: 11/16/2021

## CONSTANTS START ##

XPRO_PATH=~/.xpro;
XPRO_BIN=$XPRO_PATH/xp;
XUTIL_PATH="xutil.sh";

## CONSTANTS END ##

## VARIABLES START ##

result=0;

## VARIABLES END ##

## FUNCTIONS START ##

## xLog()
## brief: Logs with xPro: prefixed
function xLog() {
    printf "xPro: $1";
}

## loadObjects()
## brief: Creates bash/zsh variables
##
## returns:
##  - Sets result
function loadObjects() {
    objectCount=-1;

    if [ $result -eq 0 ]; then 
        objectCount=$($XPRO_BIN obj --count);
        result=$?;
    fi 

    if [ $result -eq 0 ]; then 
        if [ $objectCount -eq -1 ]; then 
            xLog "Object count is -1";
            result=1;
        fi 
    fi 

    if [ $result -eq 0 ]; then 
        for ((i=0;i<objectCount;i++)); do
            name=$($XPRO_BIN obj -index $i --name);
            value=$($XPRO_BIN obj -index $i --value);
            eval "$name"="$value";
        done
    fi 
}

## loadAliases()
## brief: Creates bash/zsh aliases
##
## returns:
##  - Sets result
function loadAliases() {
    aliasCount=-1;

    if [ $result -eq 0 ]; then 
        aliasCount=$($XPRO_BIN alias --count);
        result=$?;
    fi 

    if [ $result -eq 0 ]; then 
        if [ $aliasCount -eq -1 ]; then 
            xLog "Alias count is -1";
            result=1;
        fi 
    fi 

    if [ $result -eq 0 ]; then 
        for ((i=0;i<aliasCount;i++)); do
            name=$($XPRO_BIN alias -index $i --name);
            value=$($XPRO_BIN alias -index $i --value);
            alias "$name"="$value";
        done
    fi 
}

## FUNCTIONS END ##

## MAIN START ##

pushd $XPRO_PATH >/dev/null 2>&1;

# Add xpro to path 
if [ ! -d $XPRO_PATH ]; then 
    result = 1;
    xLog "$XPRO_PATH does not exist\n";
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

# Load aliases
if [ $result -eq 0 ]; then 
    loadAliases;
fi 

popd >/dev/null 2>&1; # $XPRO_PATH

if [ $result -eq 0 ]; then 
    xLog "Successfully loaded\n";
else 
    xLog "Failed to load\n";
fi 

## MAIN END ##
