# extract the version from package.json

Several ways, some require software to be installed, some are slower due to larger
processes started up.

## node

```bash
node -e "const p = require('./package.json'); console.log(p.version)" > VERSION
```

## awk

```bash
awk -e '/version/ { gsub(".*\"version\": \"", ""); gsub("\",", ""); print }' < package.json  > VERSION
```

## grep and sed

```bash
grep version package.json | sed -e 's/.*"version": "//' -e 's/",//' > VERSION
```

## jq

```bash
jq -r .version package.json > VERSION
```
