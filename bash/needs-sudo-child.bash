#!/bin/bash

echo "Starting ${BASH_SOURCE[0]}"

EFFECTIVE_USER_ID=$(id -u)
if ! [ $EFFECTIVE_USER_ID = 0 ]; then
    echo "I am not root!"
else
    echo "I am root!"
fi

echo "EFFECTIVE_USER_ID = $EFFECTIVE_USER_ID"
echo "SUDO_USER = $SUDO_USER"
echo "REAL_USER = $(whoami)"

#echo "Calling needs-sudo-child.bash as $EFFECTIVE_USER_ID"
#./needs-sudo-child.bash

#echo "Calling needs-sudo-child.bash as $REAL_USER"
#sudo -u ./needs-sudo-child.bash

echo "Exiting ${BASH_SOURCE[0]}"

