# Use python http.server to serve local files

Source: https://stackoverflow.com/a/15328771/54745

```bash
python3 -m http.server
```
or if you don't want to use the default port 8000

```bash
python3 -m http.server 3333
```

or if you want to allow connections from localhost only

```bash
python3 -m http.server --bind 127.0.0.1
```

See the docs: https://docs.python.org/3/library/http.server.html#module-http.server
