# Find recursively but not too deep: maxdepth

The `find` command will recursively search for files matching a pattern, type, etc. It
however can search too deeply when you just want to use it to create a list of directories
or files. Especially valuable when the paths might include whitespace characters.

## maxdepth, mindepth

Note `-maxdepth` has to go *before* the tests, patterns, arguments:

```bash
find . -maxdepth 1 -type d
```

When using GNU or Busybox there is also `-mindepth`, again, after the starting directory
path and before any tests, patterns, arguments:

```bash
find .  -mindepth 1 -maxdepth 1 -type d
```


## Examples

List of text files at the top of this repository at depth 0:

```bash
$ find . -maxdepth 0 -type f
```

Yes, there are no files is at depth zero relative to the current directory. The files are
all in the current directory, at least depth 1.

List of text files at the top of this repository at depth 1:

```bash
$ find . -maxdepth 1 -type f
./GitCommitsForNonGitUsers.md
./CONTRIBUTING.md
./README.md
```

List of directories files at the top of this repository at depth 1:

```bash
$ find . -maxdepth 1 -type d
.
./html
./web
./bitbucket-pipelines
./testing
./homebrew
./dotfiles
./git
./java
./security
./haskell
./memory
./sql
./javascript
./locale
./bash
./.vscode
./rails
./vim
./life
./OSX
./docker
./python
./ember
./ruby
./json
./.git
./deployments
```

If you don't specify a maxdepth, then the `.git` and other directories will be traversed.

```bash
$ find . -type d | wc -l
168
```
