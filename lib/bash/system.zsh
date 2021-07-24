
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