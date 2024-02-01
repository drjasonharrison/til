# Tracing memory usage with top and grep

To track the memory usage of a process containing the word "python":

```bash
top -b -d 5| grep --color=none --line-buffered python >> memory-usage.txt &
tail -f memory-usage.txt
```

Details on options for top:

- `-b` is batch-mode operations, run until killed or number of iterations specified with
  command line option `-n` (number of iterations).
- `-d` is delay time, in seconds.
- if you have a PID, you can specify `-pN1 -pN2` or `-pN1,N2,N3...` up to 20 PIDs.

Details on options for grep:

- `--color=none` disables the use of terminal escape sequences to highlight matched
  strings.
- `--line-buffered` use line buffering to delay output and input as little as possible.

Details on options for tail:

- `-f` follow the end of the file, outputting as the file is appended to
