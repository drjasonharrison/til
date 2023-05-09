# Rename files with find

## See also

https://unix.stackexchange.com/questions/227662/how-to-rename-multiple-files-using-find

## add a prefix

Use `-execdir` to `cd` into the directory. should also work without the `-execdir` if you use
`dirname` to recreate the path to `$x`:

```bash
 find . -name "job-info.json" -type f -execdir \
    sh -c 'x="{}"; mv $x _.$(basename $x)' \;
```

## remove a prefix

using shell variable expansion:

```bash
find . -name "job-info.json" -type f -execdir \
    sh -c 'x="{}"; new="$(basename $x)"; new="${new/prefix///}"; mv "$x" "$new"' \;
```
