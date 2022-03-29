# Find duplicate files


## Brute force, without installing any packages

From https://unix.stackexchange.com/a/277707/249782

```
find . ! -empty -type f -exec md5sum {} + | sort | uniq -w32 -dD
```

Do md5sum of found files on the -exec action of find and then sort and do uniq to get the
files having same the md5sum separated by newline.

Notes:
- hashes the entire file rather than first N kB first
- doesn't compare file size before hashing
- doesn't require installing anything


## Using fdupes or fslint

From https://unix.stackexchange.com/a/277705/249782


You can use fdupes. From man fdupes:

    Searches the given path for duplicate files. Such files are found by comparing file sizes and MD5 signatures, followed by a byte-by-byte comparison.

You can call it like `fdupes -r /path/to/dup/directory` and it will print out a list of dupes.

Update

You can give it try to fslint also. After setting up fslint, go to `cd /usr/share/fslint/fslint && ./fslint /path/to/directory`
