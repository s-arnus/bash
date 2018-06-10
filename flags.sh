#!/bin/bash
# Example on how to use script input flags to do carry out different actions

# Accepted flags are: -d, -t, -y

# Actions should be taken when flags are accepted in following sets:
# -t
# -d all
# -d conf
# -d script
# -d all -y
# -d conf -y
# -d script -y

f_testing() {
    echo "Testing function"
}

f_deploy() {
    if [ "$yflag" ]
    then
        printf "Option -y specified\n"
    fi
    f_config () {
        echo "Deploying configuration"
    }
    f_script() {
        echo "Deploying scripts"
    }
    f_all() {
        # Deploy both configuration and scripts
        f_config
        f_script
    }
}

tflag=
dflag=
yflag=
while getopts 'tyd:' OPTION
do
    case $OPTION in
        t) tflag=1
           ;;
        y) yflag=1
           ;;
        d) dflag=1
           bval="$OPTARG"
           ;;
        ?) printf "Usage for testing: %s -t\n" ${0##*/} >&2
           printf "Usage for deployment: %s -d (all|conf|script) [-y] \n" ${0##*/} >&2
           exit 2
           ;;
    esac
done
shift $(($OPTIND - 1))

if [ "$tflag" ]
then
    printf "Option -t specified\n"
    f_testing
fi
if [ "$dflag" ]
then
    printf 'Option -d "%s" specified\n' "$bval"
    f_deploy
    if [ "$bval" == "conf" ]
    then
        f_config
    elif [ "$bval" == "script" ]; then
        f_script
    elif [ "$bval" == "all" ]; then
        f_all
    fi
fi
printf "Remaining arguments are: %s\n" "$*"