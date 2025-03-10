# Subprocesses, named pipes, and updating variables

## Counting operations

Occasionally you want to have a loop like:

```bash
NUM_FILES=0

for FILE in *.txt; do
    wc "${FILE}"
    NUM_FILES=$((NUM_FILES + 1))
done

echo "Processed ${NUM_FILES}
```

and `NUM_FILES` is output as expected.

## Adding a subprocess

But then you learn about using `find` which bring recursion, file/directory filtering, and
other great things, so you use a pipe:

```bash
NUM_FILES=0

find . -name *.txt | while read -r FILE; do
    wc "${FILE}"
    NUM_FILES=$((NUM_FILES + 1))
done

echo "Processed ${NUM_FILES}
```

And the final value of `NUM_FILES` is 0! Even though everything is being executed in the
loop.

This is because a subprocess is created by bash to execute the while loop, and changes to
a variable in a subprocess do not affect the parent process state.

## Named pipes

The solution is to use a `named pipe` which is like a file, but also like a pipe.

1. create with `mkfifo`
2. delete with `rm`
3. use an exit handler to delete the named pipe


```bash
NUM_FILES=0
MY_PIPE_NAME=my_pipe_name

mkfifo "${MY_PIPE_NAME}"
find . -name *.txt > "${MY_PIPE_NAME}"

while read -r FILE; do
    wc "${FILE}"
    NUM_FILES=$((NUM_FILES + 1))
done < "${MY_PIPE_NAME}"
rm "${MY_PIPE_NAME}"

echo "Processed ${NUM_FILES}
```

## Improving the error handling and clean up

```bash
function make_mypipe {
    MY_PIPE_NAME="${BASH_SOURCE[0]}-pipe.tmp"

    # create a fifo pipe for connecting STDOUT of one process and STDIN of another
    # set a trap handler for EXIT remove the fifo pipe from the filesystem
    #
    # TODO: could use a tmp file
    # TODO: could echo the MY_PIPE_NAME to return the file path rather than using the global
    #       variable to communicate the file path
    if [[ -e "${MY_PIPE_NAME}" ]]; then
        rm "${MY_PIPE_NAME}"
    fi
    trap "remove_mypipe exit" EXIT
    mkfifo "${MY_PIPE_NAME}"
}

function remove_mypipe {
    if (($# > 0)); then
        log "Exit: removing ${MY_PIPE_NAME}"
    fi
    if [[ -e "${MY_PIPE_NAME}" ]]; then
        rm "${MY_PIPE_NAME}"
    fi
    trap - EXIT  # undo: trap "remove_mypipe exit" EXIT
}

make_mypipe
find . -name *.txt > "${MY_PIPE_NAME}"

while read -r FILE; do
    wc "${FILE}"
    NUM_FILES=$((NUM_FILES + 1))
done < "${MY_PIPE_NAME}"
remove_mypipe

echo "Processed ${NUM_FILES}
```
