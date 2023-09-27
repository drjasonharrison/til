# jq processor snippets

## get all key names

Use `keys` or `keys_unsorted`:

```bash
jq 'keys' info.json
[
  "deployment",
  "failed",
  "no_output",
  "results",
  "sending",
  "start_datetime",
  "total_time"
]
```

```bash
jq 'keys_unsorted' info.json
[
  "deployment",
  "start_datetime",
  "results",
  "no_output",
  "failed",
  "sending",
  "total_time"
]
```

## get length of an array

Pipe the array into the length operator

```bash
jq '.failed | length' info.json
15
```

## process multiple files with command line patterns

```bash
jq '.failed | length' subdir-prefix*/info.json
15
8
8
0
```

## use input_filename to find files with a matching expression

From: https://github.com/jqlang/jq/issues/743#issuecomment-993940502

```bash
$ tail -n +1 *.json
==> file1.json <==
{
    "a": "x",
    "b": "d"
}

==> file2.json <==
{
    "b": "d",
    "d": "x"
}

$ jq 'select(has("a"))|input_filename' -- *.json
"file1.json"

$ jq 'select(has("b"))|input_filename' -- *.json
"file1.json"
"file2.json"

$ jq 'select(has("d"))|input_filename' -- *.json
"file1.json"
```
