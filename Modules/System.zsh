# System functions

# using goto() here because shell scripts use subshells
function goto()
{
    directory=$(xpro.getdir ${1});
    if [[ ! -z $directory ]]
    then 
        cd $directory;
    fi 
}

function hop()
{
    for (( i=0; i<$1; i++))
    do 
        cd ..;
    done 
}

function getpath { echo $(cd $(dirname $1); pwd)/$(basename $1); }

