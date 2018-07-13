#! /bin/sh

LISTOFPATCHES="gotoline.pth newwin.pth rpmspec.pth"

INSTALLLIST=""

for PTH in $LISTOFPATCHES ; do

    echo "Do you wish to apply the $PTH (Y/N)?"
    read answer
    case $answer in 
        Y|y)
            echo "yes apply $PTH"
            INSTALLLIST="$INSTALLLIST $PTH"
            ;;
        N|n)
            echo "not appling $PTH"
            ;;
        *)
            echo "bad entry skipping application of $PTH"
            ;;
     esac

done

cat tknotepad $INSTALLLIST > tkn+

chmod 755 tkn+

echo "New executable is named tkn+"


