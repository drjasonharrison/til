# shellcheck shell=bash
### READ NOTES WHY THIS DOES NOT NEED #/bin/bash
# Utility bash functions for working with docker
# Usage:
#   source utils-docker.bash
#
# Author: Jason Harrison
# Date: 2021/10/18
# Updated: 2024-09-09 to use ${FUNCNAME[0]} in more error_logs

__UTILS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# save and restore shell options: https://unix.stackexchange.com/a/310963/249782
oldstate="$(
    shopt -po
    shopt -p
)"
# Bash manpage:
# CONDITIONAL EXPRESSIONS
# ...
#    -o optname
#       True if the shell option optname is enabled.
[ -o errexit ] && oldstate="$oldstate; set -o errexit"
oldstate="${oldstate//$'\n'/; }" # replace "\n" with "; "
set +o nounset
if [[ -n "${__UTILS_DOCKER_INCLUDED__}" ]]; then
    # This warning echo statement will mess with the inclusion of this file
    # into scripts that return results using stdout such as
    # tag-docker-image-for-ecr.bash -- uncomment at your own risk
    # echo "Warning utils-docker.bash already defined, ignoring evaluation from $@"
    set +o verbose +o xtrace
    eval "$oldstate" # restore all options stored.
    return
fi
readonly __UTILS_DOCKER_INCLUDED__=true
set +o verbose +o xtrace
eval "$oldstate" # restore all options stored.

# shellcheck disable=SC1090,SC1091
source "${__UTILS_DIR}/utils-bash-environment.bash" "${BASH_SOURCE[0]}"

# this will clean up docker containers, images, and volume when called
# Usage:
#   - on EXIT from the script:
#       trap utils_cleanup_docker_containers_and_images EXIT
#   - before building or loading a docker image:
#       utils_cleanup_docker_containers_and_images
function utils_cleanup_docker_containers_and_images {
    log "Removing stopped containers"
    docker container prune --force >/dev/null

    log "Removing dangling and untagged images"
    docker image prune --force >/dev/null

    log "Pruning old volumes"
    docker system prune --force --volumes >/dev/null
}

# remove images with a specific tag:version
function utils_remove_docker_images_with_tag {
    local DOCKER_TAG_VERSION_TAG

    if (($# < 1)); then
        error_log "${FUNCNAME[0]}: missing argument DOCKER_TAG_VERSION_TAG"
        exit 1
    fi

    DOCKER_TAG_VERSION_TAG="$1"

    IMAGES_WITH_TAG=$(docker image ls "${DOCKER_TAG_VERSION_TAG}" -q)
    if [ -n "${IMAGES_WITH_TAG}" ]; then
        printf "Removing all %s images\n" "${DOCKER_TAG_VERSION_TAG}" | log
        docker image rm --force "${DOCKER_TAG_VERSION_TAG}" | log
    else
        printf "No images tagged with %s to remove\n" "${DOCKER_TAG_VERSION_TAG}" | log
    fi
}

function utils_remove_container_with_name {
    local CONTAINER_NAME

    if (($# < 1)); then
        error_log "${FUNCNAME[0]}: missing argument CONTAINER_NAME"
        exit 1
    fi

    CONTAINER_NAME="$1"
    # there might not be a container running with that name, so ignore errors
    set +o errexit +o pipefail
    if [ "$(docker ps --all --quiet --filter name="${CONTAINER_NAME}" 2>/dev/null)" ]; then
        echo "Found container - ${CONTAINER_NAME}"
        if [ "$(docker ps --quiet --filter name="${CONTAINER_NAME}")" ]; then
            echo "Killing running container - ${CONTAINER_NAME}"
            docker kill "${CONTAINER_NAME}" >/dev/null
        fi
        log "Removing stopped container - ${CONTAINER_NAME}"
        docker rm "${CONTAINER_NAME}"
    fi
    set -o errexit -o pipefail
}

# a container's ancestor is the image that the container was created from
function utils_remove_containers_with_ancestor_name {
    local ANCESTOR_NAME

    if (($# < 1)); then
        error_log "${FUNCNAME[0]}: missing argument ANCESTOR_NAME"
        exit 1
    fi

    ANCESTOR_NAME="$1"

    log "Looking for containers with ancestor ${ANCESTOR_NAME}"
    readarray -t CONTAINERS_WITH_ANCESTOR < <(docker ps --quiet --all --filter ancestor="${ANCESTOR_NAME}" 2>/dev/null)
    printf "container: '%s'\n" "${CONTAINERS_WITH_ANCESTOR[@]}" | debug_log

    if ((${#CONTAINERS_WITH_ANCESTOR[@]})); then
        printf "%s: container: %s\n" "${ANCESTOR_NAME}:" "${CONTAINERS_WITH_ANCESTOR[@]}" | log
        # get list of only running containers:
        readarray -t RUNNING_CONTAINERS < <(docker ps --quiet --filter ancestor="${ANCESTOR_NAME}" 2>/dev/null)
        for container in "${RUNNING_CONTAINERS[@]}"; do
            log "Killing container ${container##/*}"
            docker kill "${container##/*}" >/dev/null
        done

        for container in "${CONTAINERS_WITH_ANCESTOR[@]}"; do
            log "Removing container ${container##/*}"
            docker rm "${container##/*}" >/dev/null
        done
    else
        log "No containers found with ancestor=${ANCESTOR_NAME}"
    fi
}

function utils_docker_image_is_in_repo_with_tag {
    # Usage:
    #  if [[ "$(utils_docker_image_is_in_repo_with_tag "${DOCKER_TAG}:{VERSION_TAG}")" == "yes" ]]; then
    #       log "exists";
    #  else
    #       log "does not exist";
    #  fi
    #
    # If there is an image in the repo with VERSION_TAG then this outputs to stdout
    # "yes", otherwise "no"
    if (("$#" < 1)); then
        error_log "${FUNCNAME[0]}: missing \$\{DOCKER_TAG\}:\$\{VERSION_TAG\}"
        log "Usage: \$\(utils_docker_image_is_in_repo_with_tag \"\$\{DOCKER_TAG\}:\$\{VERSION_TAG\}\"\)"
        exit 1
    fi
    local DOCKER_TAG_VERSION_TAG="$1"
    local RESULT=0

    set +o errexit
    docker inspect --format '{{ .Created }}' "${DOCKER_TAG_VERSION_TAG}" >/dev/null 2>&1
    RESULT=$?
    set -o errexit
    if ((RESULT)); then
        echo "no"
        return
    fi
    echo "yes"
}

function utils_remove_docker_container_using_cidfile {
    if (($# < 1)); then
        error_log "${FUNCNAME[0]}: expected CONTAINER_ID_FILE as argument"
        exit 1
    fi

    local CONTAINER_ID_FILE="$1"
    local CONTAINER_ID=""

    shopt -s inherit_errexit
    # shellcheck disable=SC2155
    declare +i local_oldstate="$(utils_get_shell_option_state)"
    shopt -u inherit_errexit
    set +o errexit

    if [[ -f "${CONTAINER_ID_FILE}" ]]; then
        log "Found CONTAINER_ID_FILE at \"${CONTAINER_ID_FILE}\""
        CONTAINER_ID=$(<"${CONTAINER_ID_FILE}")
        RESULT=$?
        if ((RESULT)); then
            error_log "when reading from \"${CONTAINER_ID_FILE}\""
            eval "${local_oldstate}"
            return 1
        fi
        log "Trying to remove container \"${CONTAINER_ID}\""
        docker container rm "${CONTAINER_ID}"
        RESULT=$?
        if ((RESULT)); then
            error_log "when removing container \"${CONTAINER_ID}\""
            eval "${local_oldstate}"
            return 1
        fi

        log "Removing ${CONTAINER_ID_FILE}"
        rm "${CONTAINER_ID_FILE}"
    else
        log "Did not find CONTAINER_ID_FILE at \"${CONTAINER_ID_FILE}\", this is good"
    fi
    eval "${local_oldstate}"
}

function utils_confirm_docker_image_exists_or_exit {
    if (($# < 2)); then
        error_log "${FUNCNAME[0]}: expected DOCKER_TAG and VERSION_TAG as arguments"
        exit 1
    fi

    local DOCKER_TAG="$1"
    local VERSION_TAG="$2"
    local FOUND_DOCKER_IMAGE_WITH_VERSION=false
    local DOCKER_IMAGES_WITH_TAG

    shopt -s nullglob
    DOCKER_IMAGES_WITH_TAG=($(docker images "${DOCKER_TAG}" --format "{{.Tag}}"))
    shopt -u nullglob # Turn off nullglob to make sure it doesn't interfere with anything later

    if ((${#DOCKER_IMAGES_WITH_TAG[@]} == 0)); then
        echo "No existing containers found for ${DOCKER_TAG}, this is bad"
    else
        for VERSION in "${DOCKER_IMAGES_WITH_TAG[@]}"; do
            debug_log "version = ${VERSION}"
            if [[ ${VERSION_TAG} == "${VERSION}" ]]; then
                debug_log "Found VERSION_TAG=${VERSION_TAG}"
                FOUND_DOCKER_IMAGE_WITH_VERSION=true
                break
            fi
        done
    fi
    debug_log "FOUND_DOCKER_IMAGE_WITH_VERSION=${FOUND_DOCKER_IMAGE_WITH_VERSION}"

    if [[ $FOUND_DOCKER_IMAGE_WITH_VERSION == "false" ]]; then
        error_log "Unable to find docker image with repository and tag of ${DOCKER_TAG}:${VERSION_TAG}"
        if [[ ${VERSION_TAG} == *"dirty"* ]]; then
            echo "Warning: TAG contains '_dirty_'. Stash or commit changes."
        fi

        echo
        echo "Found these images:"
        docker images | grep "${DOCKER_TAG}"
        exit 1
    fi
}

function utils_docker_inspect_image_and_container {
    # log docker image and container information using values DOCKER_TAG, VERSION_TAG, and
    # CONTAINER_ID_FILE
    if [[ -n ${DOCKER_TAG} ]] && [[ -n ${VERSION_TAG} ]]; then
        log ""
        log "docker image inspect:"
        docker image inspect "${DOCKER_TAG}:${VERSION_TAG}" 2>&1 | log
    else
        error_log "variables DOCKER_TAG and/or VERSION_TAG are not defined"
    fi

    if [[ -n ${CONTAINER_ID_FILE} ]]; then
        CONTAINER_ID_FILE="/tmp/${DOCKER_TAG}_${VERSION_TAG}.cid"
        CONTAINER_ID=$(<"${CONTAINER_ID_FILE}")
        log ""
        log "docker container inspect:"
        docker container inspect "${CONTAINER_ID}" 2>&1 | log
    else
        error_log "variable CONTAINER_ID_FILE is not defined"
    fi
}

function utils_docker_build_error_handler {
    # Output a somewhat useful error message about the build error
    # Usage:
    #   - on EXIT from the script:
    #       trap 'utils_docker_build_error_handler ${LINENO}' ERR

    exit_status=$?
    set +o xtrace errexit nounset
    local parent_lineno="$1"
    local message="${BASH_COMMAND}"

    if [[ -n "${message}" ]]; then
        error_log "on or near line ${parent_lineno}: ${message}; exiting with status ${exit_status}"
    else
        error_log "on or near line ${parent_lineno}; exiting with status ${exit_status}"
    fi
    log ""
    log "Suggestions:"
    log "- If the error occurred during the RUN apt-get:"
    log "    - search https://forums.developer.nvidia.com"
    log "    - search https://github.com/NVIDIA/nvidia-docker/issues"
    log "- If 'no space on device' try 'docker system prune [--volumes] --force'"
    log "- If 'no space on device' try 'docker image prune --all --force'"
    log "- If ImportError, confirm that apt-get ran correctly"
    if [ "$(uname -s)" == "Darwin" ]; then
        log "- Is the docker daemon running?"
    fi
    utils_docker_inspect_image_and_container
    exit "${exit_status}"
}


function utils_docker_run_error_handler {
    # Output a somewhat useful error message about the docker run error
    # Usage:
    #   - on ERROR from the script:
    #       trap 'utils_docker_run_error_handler ${BASH_SOURCE[0]} ${LINENO}' ERR
    for _item in "$@"; do
            echo "${_item}"
    done
    local -n _lineno="${1:-LINENO}"
    local -n _bash_lineno="${2:-BASH_LINENO}"
    local _last_command="${3:-${BASH_COMMAND}}"
    local _code="${4:-0}"

    ## Workaround for read EOF combo tripping traps
    if ! ((_code)); then
        return "${_code}"
    fi

    local _last_command_height="$(wc -l <<<"${_last_command}")"

    local -a _output_array=()
    _output_array+=(
        '---'
        "lines_history: [${_lineno} ${_bash_lineno[*]}]"
        "function_trace: [${FUNCNAME[*]}]"
        "exit_code: ${_code}"
    )

    if [[ "${#BASH_SOURCE[@]}" -gt '1' ]]; then
        _output_array+=('source_trace:')
        for _item in "${BASH_SOURCE[@]}"; do
            _output_array+=("  - ${_item}")
        done
    else
        _output_array+=("source_trace: [${BASH_SOURCE[*]}]")
    fi

    if [[ "${_last_command_height}" -gt '1' ]]; then
        _output_array+=(
            'last_command: ->'
            "${_last_command}"
        )
    else
        _output_array+=("last_command: ${_last_command}")
    fi

    _output_array+=('---')
    printf '%s\n' "${_output_array[@]}" >&2
exit 1


    exit_status=$?
    set +o xtrace errexit nounset
    local filepath=$1
    local lineno="$2"
    local message="${BASH_COMMAND}"

    echo "exit_status=${exit_status}"
    echo "filepath=$filepath"
    echo "lineno=$lineno"
    echo "caller=$(caller)"

    if [[ -n "${message}" ]]; then
        error_log "on or near line ${lineno}: ${message}; exiting with status ${exit_status}"
    else
        error_log "on or near line ${lineno}; exiting with status ${exit_status}"
    fi
    log ""
    log "Suggestions:"
    log "- If 'the input device is not a TTY' then run with --silent flag or "
    log "    set environment variable CI, BITBUCKET_BUILD_NUMBER, or DOCKER_BUILD_TIME to a non-empty string"
    log "- If error above is 'Unable to find image '${DEPLOYMENT_AWS_ECR_REPOSITORY_NAME}:latest' locally'"
    log "    re-run without the --no-build flag"
    log "- If 'no space on device' try 'docker system prune [--volumes] --force'"
    log "- If 'no space on device' try 'docker image prune --all --force'"
    log "- If ImportError, confirm that apt-get ran correctly"
    log "- If 'could not select device driver "" with capabilities: [[gpu]].'"
    log "     install nvidia-container-toolkit (see README)"
    if [ "$(uname -s)" == "Darwin" ]; then
        log "- Is the docker daemon running?"
    fi
exit 1
    utils_docker_inspect_image_and_container
    exit "${exit_status}"
}

function utils_register_docker_build_error_handler {
    trap 'utils_docker_build_error_handler "${BASH_SOURCE[0]}" "${LINENO}"' ERR
    debug_log "registered trap utils_docker_build_error_handler ERR"
}

function utils_register_docker_run_error_handler {
    trap 'utils_docker_run_error_handler "LINENO" "BASH_LINENO" "${BASH_COMMAND}" "${?}"' ERR
    return
    trap 'utils_docker_run_error_handler "${BASH_SOURCE[0]}" "${LINENO}"' ERR
    debug_log "registered trap utils_docker_run_error_handler ERR"
}

# We put this at the bottom of the script so it can use all of the definitions in the script
if [ "$LOG_LEVEL" == "debug" ]; then
    if [[ -z "$0" ]]; then
        error_log "${BASH_SOURCE[0]} possibly sourced from shell, not script"
    else
        log "${BASH_SOURCE[0]} evaluated by $*"
    fi
fi
