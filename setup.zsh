pushd "$(dirname "$0")"

    cp -f ./Profile.zsh ~/.zshrc;

    # Create Profile pointer 
    out=~/.profile.xml;
    if [ ! -f $out ] 
    then 
        touch $out;
    else 
        rm $out;
        touch $out;
    fi 
    GitRepoDir=$(pwd);
    read -p "Config File Name: " ConfigFile
    ConfigFile="/$ConfigFile.xml";
    echo "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>" | tee -a $out;
    echo "<Machine MachineName=\"KAMANTA\">" | tee -a $out;
    echo "  <GitRepoDir>$GitRepoDir</GitRepoDir>" | tee -a $out;
    echo "  <ConfigFile>$ConfigFile</ConfigFile>" | tee -a $out;
    echo "</Machine>" | tee -a $out;
popd 