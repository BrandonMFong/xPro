# Author: Brando
# Date: 11/16/2021

result=0;

xproPath="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )";
xutilPath="xutil.sh";

if [ ! -d $xproPath ]; then 
    result = 1;
    printf "$xproPath does not exist\n";
else 
    PATH=$PATH:$xproPath;
fi 

if [ $result -eq 0 ]; then 
    source $xutilPath;
    result=$?;
fi 

if [ $result -eq 0 ]; then 
    printf "Successfully loaded xpro\n"
else 
    printf "Failed to load xpro\n"
fi 
