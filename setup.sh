# @file setup.sh
# @author Brando 
# @date 2021-1-25
#

## Variables Start ## 
okayToContinue=true;
out=~/.profile.xml;
gitRepoDir=$(pwd); # get the xPro directory 
configPath="${gitRepoDir}/Config/Users";
configFile="/${configFile}.xml"; # config name 
baseConfig="/Makito.xml"; # TODO read from app.json 

# Arguments
Arg1=$1;

# Flags
bashFlag="-bash";
zshFlag="-zsh";
helpFlag="-help";

# Help Variables
usage="usage: $0 [ -bash | -zsh ]";
footer="See '$0 ${helpFlag}' for an overview."

## Variables End ## 

pushd "$(dirname "$0")" > /dev/null;

    # copy profile 
    if [[ ${Arg1} == ${zshFlag} ]]
    then 
        ShellProfile=".zshrc"
    elif [[ ${Arg1} == ${bashFlag} ]]
    then 
        ShellProfile=".bashrc"
    else 
        printf "${usage}\n\n";
        printf "${footer}\n";
        okayToContinue=false;
    fi 
    cp -f ./Profile.zsh ~/$ShellProfile;

    # Create Profile pointer 
    if [[ ! -f $out ]] && ( [ $okayToContinue = true ] )
    then 
        touch $out;
    else 
        rm $out;
        touch $out;
    fi 

    # Asking if user wants to use or create
    # going to use Makito.xml as basis 
    # Have user choose if they want to create or use an existing config
    if [ $okayToContinue = true ]
    then 
        printf "What do you want to do?\nCreate New Config[1]\nUse Existing Config[2]\nSo: ";
        read choice; # TODO read from app.json
    fi 

    if ( [ $okayToContinue = true ] ) && ( [[ -z $choice ]] )
    then 
        printf "No arguments passed";
        okayToContinue=false;
    elif ( [ $okayToContinue = true ] ) && ( [[ $choice -ne 1 ]] ) && ( [[ $choice -ne 2 ]] )
    then 
        printf "Not choice 1 or 2\n";
        okayToContinue=false;
    fi 

    if [ $okayToContinue = true ]
    then
        # create new config 
        if [ $choice -eq 1 ]
        then 
            # create config file name
            read -p "Config File Name: " configFile;
            configFile="/${configFile}.xml"; # config name 
            
            # Copy base config to new config 
            cp -f "${configPath}${baseConfig}" "${configPath}${configFile}";

        # Use existing config
        else 
            printf "Choose out of the following:\n"
            ./bin/xpro.enumdir $configPath
            read -p "So: " choice;
            choice=$(($choice - 1));
            configFile="/$(./bin/xpro.selectitem -path $configPath -index $choice)";
            printf $configFile;
        fi 

        # Keeping it in this if statement because I don't want to execute it if the user input something wrong 
        # Write to apppointer 
        echo "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>" | tee -a $out;
        echo "<Machine MachineName=\"KAMANTA\">" | tee -a $out;
        echo "  <GitRepoDir>${gitRepoDir}</GitRepoDir>" | tee -a $out;
        echo "  <ConfigFile>${configFile}</ConfigFile>" | tee -a $out;
        echo "</Machine>" | tee -a $out;
    fi
popd  > /dev/null;
