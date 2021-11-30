# Author: Brando
# Date: 11/16/2021

result=0;

xproPath=~/.xpro;
xutilPath="xutil.sh";

pushd $xproPath >/dev/null 2>&1;

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

popd >/dev/null 2>&1; # $xproPath

if [ $result -eq 0 ]; then 
    printf "Successfully loaded xpro\n"
else 
    printf "Failed to load xpro\n"
fi 
