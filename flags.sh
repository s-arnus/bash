#!/bin/bash
# Example on how to use script input flags to do carry out different actions

# Attempt to use undefined variable outputs error message, and forces an exit
set -o nounset
# Causes a pipeline to return the exit status of the last command in the pipe that returned a non-zero return value.
set -o pipefail
# Abort script at first error, when a command exits with non-zero status (except in until or while loops, if-tests, list constructs)
#set -o errexit

# Start for measuring script runtime
start=$(date +%s.%N)

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

function instructions {
# Print how to use this script
echo "Usage: $(basename $0) (-t [-d] | -e (all|conf|script) [-y] [-d]) "
echo "Accepted flags are: -h, -d, -t, -e, -y"
echo "-h for help"
echo "-d for debug"
echo "-t for test"
echo "-e for execute deployment"
echo "-y for yes (do not ask manual input for execution)"
echo ""
echo "Following sets of flags and options are allowed. Options in square bracets are optional:"
echo "  Running tests"
echo "      -t [-d]"
echo "  Executing deployment for all or some parts"
echo "      -e (all|conf|script) [-y] [-d]"
echo ""
echo "Example command to start tests: $(basename $0) -t"
echo "Example command to start deployment execution: $(basename $0) -e all"
}

debugging="0"
test="0"
execution="0"
yesinput="0"
while getopts ":dhte:y" opt; do
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
            instructions
            exit 1
        ;;
        t)
            echo "-t was triggered" >&2
            test=1
        ;;
        e)
            echo "-e was triggered. Parameter: $OPTARG" >&2
            if [[ ${OPTARG} == "all" ]]; then
                echo "Parameter all selected"
            elif [[ ${OPTARG} == "conf" ]]; then
                echo "Parameter conf selected"
            elif [[ ${OPTARG} == "script" ]]; then
                echo "Parameter script selected"
            else
                instructions
                exit 1
            fi
            execution=1
        ;;
        y)
            echo "-y was triggered" >&2
            yesinput=1
        ;;
        \?)
            echo "Invalid option" >&2
            instructions
            exit 1
        ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            instructions
            exit 1
        ;;
    esac
done

# Declaring functions
function f_test {
    echo "Running test function"
}
function f_deployment {
    echo "Running deployment function"
    if [[ ${yesinput} -eq 1 ]]; then
        echo "Not asking for confirmation"
    fi
}

# Checing what actions to start and starting them
# If testing was selected then start that
if [[ ${test} -eq 1 ]]; then
    echo "Starting testing"
    f_test
fi
# If deployment was selected then start it
if [[ ${execution} -eq 1 ]]; then
    echo "Starting deployment execution"
    f_deployment
fi

# End for measuring script runtime
end=$(date +%s.%N)
runtime=$(echo "${end} - ${start}" | bc -l)
echo "Script runtime (seconds.nanoseconds): ${runtime}"