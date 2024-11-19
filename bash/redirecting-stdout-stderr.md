# Using redirection with non-portable "&|"

https://github.com/koalaman/shellcheck/issues/2880

```
#!/usr/bin/env bash

function foo()
{
    echo "stdout to stderr to stdout"
	echo -n "$1 " >&2 # send to stderr
    echo "stdout to stdout"
	echo "$2"         # this goes to stdout
}

function bar()
{
    echo "stdout to stderr to stdout to nl"
    $(echo -n "$1 " >&2) &| nl
    echo "stdout to stdout to nl:"
	$(echo "$2") &| nl
}

foo error out &| nl       # here both strings to single nl process
bar error out             # here both strings to separate nl processes
```
