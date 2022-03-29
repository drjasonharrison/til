# Remove duplicates from the $PATH variable

This is only necessary for human consumption. The shell will ignore duplicate entries in PATH.

From https://www.linuxjournal.com/content/removing-duplicate-path-entries

```bash
PATH=$(echo -n $PATH | awk -v RS=: '!($0 in a) {a[$0]; printf("%s%s", length(a) > 1 ? ":" : "", $0)}')
```
