# parser work arounds

## Command line arguments that start with dash ("-")

Instead of

```bash
python3 file.py --output_file output.txt --pattern -problem --some_string -abc
```

use the `=` sign to assign arguments:

```bash
python3 file.py --output_file output.txt --pattern="-problem" --some_string="-abc"
```

for a VSCode launch.json configuration file define the arguments with the equal sign and no extra quotes:

```json
args: [
    "--pattern=-pattern",
    "--some_string=-abc"
]
```
