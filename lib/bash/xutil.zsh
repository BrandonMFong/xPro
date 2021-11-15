
function goto()
{
    directory=$(xp dir ${1});
    if [[ ! -z $directory ]]
    then 
        cd $directory;
    fi 
}