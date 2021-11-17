
function goto()
{
    if [ ! -f $(which xp) ]; then 
        printf "binary xp does not exist, please make sure environment is set up";
    else 
        directory=$(xp dir ${1});

        if [ $? -ne 0 ]; then 
            printf "Error orccured: $?\n";
        else 
            if [[ ! -z $directory ]]
            then 
                cd $directory;
            fi 
        fi 
    fi 
}