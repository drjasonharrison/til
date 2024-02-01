# Run a command that may fail

For example grep return exit code 0 if it matches the pattern, and exit code 1 when it
fails to match the pattern.

```bash
set +o errexit
grep "${PATTERN}" "${FILE_PATH}" > /dev/null 2>&1
RESULT=$?
set -o errexit
if ((RESULT)); then
    echo "Error: could not find ${PATTERN} in ${FILE_PATH}" >&2
else
    echo "Success: found ${PATTERN} in ${FILE_PATH}"
fi
```

If you want to silence the stderr output of a command and then grep for a pattern in the
stdout:

```bash
apt list 2> /dev/null | grep "${PATTERN}" > /dev/null 2>&1
```

If you want to put the output of the first command into a variable. See
https://unix.stackexchange.com/a/163814/249782

```bash
APT_LIST=$(apt list 2> /dev/null)
grep "${PATTERN}" <<< "${APT_LIST}" > /dev/null 2>&1


```
