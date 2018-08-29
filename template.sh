#!/bin/bash
# Template to use for new scripts
# Records script run time inside the script
# Checks for existance of commands stored in array array_of_commands

# Attempt to use undefined variable outputs error message, and forces an exit
set -o nounset
# Causes a pipeline to return the exit status of the last command in the pipe that returned a non-zero return value.
set -o pipefail
# Abort script at first error, when a command exits with non-zero status (except in until or while loops, if-tests, list constructs)
#set -o errexit

# Start for measuring script runtime
start=$(date +%s.%N)

debugging=0
while getopts ":dh" opt; do
    case $opt in
        d)
            if [[ ${debugging} -eq 0 ]]; then
                echo "Debugging was triggered" >&2
                # Echoes all commands before executing
                #set -o verbose
                # Similar to -v, but expands commands
                set -o xtrace
                debugging=1
            fi
        ;;
        h)
            echo "Usage: $(basename $0) options (-d) (-h)"
            echo "Option -d for debugging"
            echo "Option -h for help"
            exit 1
        ;;
        \?)
            echo "Usage: $(basename $0) options (-d) (-h)"
            echo "Option -d for debugging"
            echo "Option -h for help"
            exit 1
        ;;
    esac
done

# Check for commands
array_of_commands=("getopts" "echo" "printf" "date" "bc")

# Variable to change if errors are encountered
command_errors="0"
# Output of the check is added in an array case of errors
array_error_output=()
function commands {
	# check if the commands in array can be found in the system
    for command in "${array_of_commands[@]}"; do
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

# Add script code here
# ...


echo "Done"

# End for measuring script runtime
end=$(date +%s.%N)
runtime=$(echo "${end} - ${start}" | bc -l)
echo "Script runtime (seconds.nanoseconds): ${runtime}"