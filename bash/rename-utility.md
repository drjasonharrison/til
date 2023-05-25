# The rename utility

```


## To remove "passed-" from the beginning of a bunch of files:

```
rename -v  's/^passed-*//' passed*
```

## To remove ".bak" from the end of filenames:

```
rename 's/\e.bak$//' *.bak
```



## To change the extension from .prog to .prg:
Source https://www.howtogeek.com/423214/how-to-use-the-rename-command-on-linux/

```
rename 's/.prog/.prg/' *.prog
```

## Search with groupings

Source https://www.howtogeek.com/423214/how-to-use-the-rename-command-on-linux/

The central expression of this rename command will search for strings within filenames that have the character sequence “stri” or “stra” where those sequences are immediately followed by “ng”:

- look for “string” and “strang”. The substitution term is “bang”.


```
rename 's/(stri|stra)ng/bang/' *.c
```

## Add a suffix before the file extension

Add the string "_432" after the filename, and before the file extension:

```
rename -n 's/(\w)\.(\w)/$1_432.$2/' *
```

## Using translations with rename
Source https://www.howtogeek.com/423214/how-to-use-the-rename-command-on-linux/

Using a y/ to start the pattern results in a translation rather than a substitution.

- The a-z term is a Perl expression that means all lowercase characters
- The A-Z term represents all uppercase letters in the sequence from A to Z.

The central expression in this command could be paraphrased as “if any of the lowercase letters from a to z are found in the filename, replace them with the corresponding characters from the sequence of uppercase characters from A to Z.”

To force the filenames of all “.prg” files to uppercase, use this command:

```
rename ‘y/a-z/A-Z/’ *.prg
```

##  man page for rename

```
Usage:
    rename [ -h|-m|-V ] [ -v ] [ -n ] [ -f ] [ -e|-E perlexpr]*|perlexpr
    [ files ]

Options:
    -v, -verbose
            Verbose: print names of files successfully renamed.

    -n, -nono
            No action: print names of files to be renamed, but don't rename.

    -f, -force
            Over write: allow existing files to be over-written.

    -h, -help
            Help: print SYNOPSIS and OPTIONS.

    -m, -man
            Manual: print manual page.

    -V, -version
            Version: show version number.

    -e      Expression: code to act on files name.

            May be repeated to build up code (like "perl -e"). If no -e, the
            first argument is used as code.

    -E      Statement: code to act on files name, as -e but terminated by
            ';'.
```
