# How to combine find, xargs, and a bash function

Demonstration of how to combine find, xargs, and a bash function into the recursive
processing of file matching a pattern.

Xargs cannot execute a bash function, you have to provide a command. That is something in
the executable PATH.  See the output of `command -v bash`.

Inspiration: https://stackoverflow.com/a/37967347/54745

```bash
function send_files {
    if (("$#" < 1)); then
        echo "Error: need to provide the path to at least one file" >&2
        return
    fi
    echo "Sending $# files" >> $HOME/md5sums.txt

    for FILE in "$@"; do
        send_single_file "${FILE}"
    done
}

function send_single_file {
    if (("$#" < 1)); then
        echo "Error: need to provide the path to at least one file" >&2
        return
    fi

    FILE="$1"
    md5sum "${FILE}" >> $HOME/md5sums.txt
}

# exporting a function with the -f option makes it available to subshells:
export -f send_single_file

function find_and_send_files {
    if (("$#" < 1)); then
        echo "Error: need to provide the path to a directory" >&2
        return
    fi
    INPUT_DIR="$1"
    echo "INPUT_DIR=${INPUT_DIR}"

    # Inspiration for the bash command https://stackoverflow.com/a/37967347/54745

    # Find files under INPUT_DIR with name matching "*.zip" and output them with nulls between them.
    # xargs will then take each null terminated argument and send it with the other two commands
    # as an argument to a bash shell that has send_files declared.

    # If we had "export -f send_files" then the "$(declare -f send_files)" would be converted
    # from a declaration of the function to a declaration of the already defined function body.
    # A real mess.
    find "${INPUT_DIR}" -name "*.zip" -print0 |
        xargs -0 bash -c "$(declare -f send_files) ;" 'send_files "$@"'
}
```

Usage:

```bash
find_and_send_files $HOME
```


## Alternatives

If you just need to call a command (found on `$PATH`)

```bash
    find "${INPUT_DIR}" -name "*.zip" |
        xargs -I{} md5sum {}
```
