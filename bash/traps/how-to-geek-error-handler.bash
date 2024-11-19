#!/bin/bash
# https://www.howtogeek.com/821320/how-to-trap-errors-in-bash-scripts-on-linux/

trap 'error_handler $? $LINENO' ERR

error_handler() {
    echo "Error: ($1) occurred on $2"
}

main() {
    echo "Inside main() function"
    bad_command
    second
    third
    exit $?
}

second() {
    echo "After call to main()"
    echo "Inside second() function"
}

third() {
    echo "Inside third() function"
}

main
