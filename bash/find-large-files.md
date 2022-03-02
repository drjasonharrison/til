# Find large files

all files under current working directory

```bash
find . -type f -printf '%s %p\n' | sort -nr | head 
```

When in git working copy, ignore the .git files:

```bash
find . -type f -printf '%s %p\n' | grep -v .git | sort -nr | head 
```
