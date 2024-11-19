#!/bin/bash
set -o pipefail
set -u

# set -e / -o errexit:
# Exit immediately if a pipeline (see Pipelines), which may consist of a single simple
# command (see Simple Commands), a list (see Lists of Commands), or a compound command
# (see Compound Commands) returns a non-zero status.
# set -o errexit

# set -E / -o errtrace:
# If set, any trap on ERR is inherited by shell functions, command substitutions, and
# commands executed in a subshell environment. The ERR trap is normally not inherited in
# such cases.
set -o errtrace

# https://stackoverflow.com/questions/6928946/mysterious-lineno-in-bash-trap-err
# https://stackoverflow.com/questions/64786/error-handling-in-bash
# https://stackoverflow.com/questions/24398691/how-to-get-the-real-line-number-of-a-failing-bash-command
# https://unix.stackexchange.com/questions/39623/trap-err-and-echoing-the-error-line
# https://unix.stackexchange.com/questions/462156/how-do-i-find-the-line-number-in-bash-when-an-error-occured
# https://unix.stackexchange.com/questions/365113/how-to-avoid-error-message-during-the-execution-of-a-bash-script
# https://shapeshed.com/unix-exit-codes/#how-to-suppress-exit-statuses
# https://stackoverflow.com/questions/30078281/raise-error-in-a-bash-script/50265513#50265513
# https://github.com/codeforester/base/blob/master/lib/stdlib.sh
__error_trapper() {
  local parent_lineno="$1"
  local code="$2"
  local commands="$3"
  echo "error exit status $code, at file $0 on or near line $parent_lineno: $commands"
}
trap '__error_trapper "${LINENO}/${BASH_LINENO}" "$?" "$BASH_COMMAND"' ERR

#false hello world
#command_not_existed hello hell

func1() {
  echo func1_in_1


  command_not_existed arg1_1 arg1_2
  func2

  echo func1_in_2
}

func2() {
  echo func2_in_1


  command_not_existed arg2_1 arg2_2

  echo func2_in_2
}

func1
false
