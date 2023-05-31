# Working with lists of files

## Copy all files after a filename

sed has a "quit" command which quits after a match. Use TAC to reverse the list of files
(if ls doesn't have a flag to already do that):

```bash
FIRST_FILE=1685469547
\ls  /path/to/large/directory/of/files/* | tac | sed "/${FIRST_FILE}*/q" | xargs -I @ cp @ .
```

## Remove all files before a filename:

Use `sed` "quit" command along with `ls` and `head` to get the first file that matches a
pattern:

```bash
DELETE_FILES_BEFORE=$(ls *.jpg | head -1)
\ls | sed "/${DELETE_FILES_BEFORE}/q" | xargs -I @ rm @
```
