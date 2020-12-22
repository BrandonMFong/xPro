# System functions

# using goto() here because shell scripts use subshells
function goto()
{
    DirectoryCount=$(xmllint --xpath "count(//Directory)" /home/brandonmfong/source/repo/xPro/Config/Users/Makito.xml);
    i=1;
    for (( i=1; i<=$DirectoryCount; i++ ))
    do 
        dirString=$(xmllint --xpath "(//Directory)[${i}]/text()" /home/brandonmfong/source/repo/xPro/Config/Users/Makito.xml);
        alias=$(echo $(xmllint --xpath "(//Directories/Directory/@Alias)[${i}]" /home/brandonmfong/source/repo/xPro/Config/Users/Makito.xml) | awk -F'[="]' '!/>/{print $(NF-1)}')

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