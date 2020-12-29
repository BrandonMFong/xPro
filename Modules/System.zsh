# System functions

# using goto() here because shell scripts use subshells
function goto()
{
    DirectoryCount=$(xmllint --xpath "count(//Directory)" ${AppPointer[GitRepoDir]}/Config/Users${AppPointer[ConfigFile]});
    i=1;
    for (( i=1; i<=$DirectoryCount; i++ ))
    do 
        dirString=$(xmllint --xpath "(//Directory)[${i}]/text()" ${AppPointer[GitRepoDir]}/Config/Users${AppPointer[ConfigFile]});
        alias=$(echo $(xmllint --xpath "(//Directories/Directory/@Alias)[${i}]" ${AppPointer[GitRepoDir]}/Config/Users${AppPointer[ConfigFile]}) | awk -F'[="]' '!/>/{print $(NF-1)}')

        if [[ "$1" == "$alias" ]]
        then 
            cd $dirString;
        fi 
    done 
}

function hop()
{
    for (( i=0; i<$1; i++))
    do 
        cd ..;
    done 
}

function getpath { echo $(cd $(dirname $1); pwd)/$(basename $1); }

