if [ ! -d "archive" ]
then 
    mkdir archive/;
fi

if [ -f *.* ]
then 
    mv *.* archive; # Just doing *.* for now 
fi