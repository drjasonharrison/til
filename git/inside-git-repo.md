# CWD inside git repo?

```bash
    set +o errexit
    IS_INSIDE_GIT_REPO="$(git rev-parse --is-inside-work-tree 2>/dev/null)"
    set -o errexit

    if [[ ${IS_INSIDE_GIT_REPO} ]]; then
        ROOT_DIR="$(git rev-parse --show-toplevel)"
    else
        ROOT_DIR="$(realpath ${DIR}/..)"
    fi
    ```


```bash
$ git rev-parse --is-inside-work-tree
true
$ cd ..
$ git rev-parse --is-inside-work-tree
fatal: not a git repository (or any parent up to mount point /)
Stopping at filesystem boundary (GIT_DISCOVERY_ACROSS_FILESYSTEM not set).
$ echo $?
128
