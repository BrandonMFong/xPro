# z shell profile
# xml parsing: sudo apt-get install libxml2-utils
# sudo apt install apt

# declare -A XMLReader=( [GitRepoDir]="/home/brandonmfong/source/repo/xPro/Config/Users/Makito.xml" )
# ${XMLReader[GitRepoDir]}

declare -A AppPointer=( [GitRepoDir]=$(xmllint --xpath "string(//GitRepoDir)" ~/.profile.xml) [ConfigFile]=$(xmllint --xpath "string(//ConfigFile)" ~/.profile.xml))
# ${AppPointer[GitRepoDir]}


# Define alias
ProgramCount=$(xmllint --xpath "count(//Program)" ${AppPointer[GitRepoDir]}/Config/Users${AppPointer[ConfigFile]});
for (( i=1; i<=$ProgramCount; i++ ))
do 
    ProgramString=$(xmllint --xpath "(//Program)[${i}]/text()" ${AppPointer[GitRepoDir]}/Config/Users${AppPointer[ConfigFile]});
    alias=$(echo $(xmllint --xpath "(//Programs/Program/@Alias)[${i}]" ${AppPointer[GitRepoDir]}/Config/Users${AppPointer[ConfigFile]}) | awk -F'[="]' '!/>/{print $(NF-1)}')
    alias ${alias}="$ProgramString";
done 


# Define modules
ModuleCount=$(xmllint --xpath "count(//Module)" ${AppPointer[GitRepoDir]}/Config/Users${AppPointer[ConfigFile]});
for (( i=1; i<=$ModuleCount; i++ ))
do 
    ModuleString=$(xmllint --xpath "(//Module)[${i}]/text()" ${AppPointer[GitRepoDir]}/Config/Users${AppPointer[ConfigFile]});
    source $ModuleString;
done 

# Prompt
color=$(echo $(xmllint --xpath "(//ShellSettings/Prompt/String/@Color)" ${AppPointer[GitRepoDir]}/Config/Users${AppPointer[ConfigFile]}) | awk -F'[="]' '!/>/{print $(NF-1)}')
PROMPT="%F{$color}$(xmllint --xpath "string(//ShellSettings/Prompt/String)" ${AppPointer[GitRepoDir]}/Config/Users${AppPointer[ConfigFile]})%f"

# Start directory
cd $(xmllint --xpath "string(//ShellSettings/StartDirectory)" ${AppPointer[GitRepoDir]}/Config/Users${AppPointer[ConfigFile]})
