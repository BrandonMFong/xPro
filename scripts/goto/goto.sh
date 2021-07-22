function goto()
{
    directory=$(xpro.getdir ${1});
    if [[ ! -z $directory ]]
    then 
        cd $directory;
    fi 
}