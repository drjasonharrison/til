#!/usr/bin/env bash
#
# Docker outputs logs to stderr not stdout, redirect output for the specified container and
# pass remaining arguments to grep
# 
# Usage:
#   dockergrep.bash [container ID] -i error
#   dockergrep.bash [container name] 127.
#   dockergrep.bash [container name] -C 3 Successfully
#   
docker logs "$1" 2>&1 | grep "${@:2}" 

# ref: http://stackoverflow.com/questions/34724980/finding-a-string-in-docker-logs-of-container
