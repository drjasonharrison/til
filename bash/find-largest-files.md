# Find the largest files


Using du, sort, head

```bash
du -a /dir/ | sort -n -r | head
```

Filtering out files in .git:

```bash
du -a /dir/ | grep -v .git | sort -n -r | head
```

Only files, not in .gitignore, not under .git:
```bash
find . -type f -not -path './.git*' \
    | git check-ignore --non-matching --verbose --stdin -z \
    | xargs -I{} du -k {} \
    | sort -n -r | head
```

I couldn't gett this to work as the original has `<action>` at the end and `<filter>`
where I put `-type f`. Not sure what the author meant to put there.

Filtering out files in .gitignore (from https://stackoverflow.com/a/50912686/54745)

```bash
find "$(git rev-parse --show-toplevel)"/* -type f \
    -not -exec git check-ignore -q --no-index {} \; du -k {} | sort -n -r | head
```
