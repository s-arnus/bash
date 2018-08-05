#!/bin/bash

array_of_commands=("stat" "ls" "chmod" "chgrp" "rsync" "du" "df")

# Variable to change if errors are encountered
command_errors="0"
# Output of the check is added in an array case of errors
array_error_output=()
function commands {
	# check if the commands in array can be found in the system
    for command in "${array_of_commands[@]}"; do
        #echo "${command}"
        type "${command}" &> /dev/null
        if [[ $? -ne 0 ]]; then
            command_errors="1"
            array_error_output+=("${command}")
        fi
    done

    if [[ ${command_errors} -eq 0 ]]; then
        echo "Command check finished successfully"
    else 
        # If errors were recorded
        # Exit and return list of commands not found
        echo "ERROR: Missing commands detected!"
        for error in "${array_error_output[@]}"; do
            printf "%s\n" "Command not found: ${error}"
        done
        exit 1
    fi

}
commands
echo "Done"