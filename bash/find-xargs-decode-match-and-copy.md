# use find with xargs, jq, match a field value and copy files

I needed to find .json files with a specific field value and copy them to a directory:

```
TARGET_UUID=0123456789abcdef
OUTPUT_DIR=matching_files
mkdir -p $OUTPUT_DIR

find . -name "*.json" | \
    xargs -I@ \
    bash -c 'if [[ $(jq -r .body.uuid @) == "$TARGET_UUID" ]]; then \
        cp @ $OUTPUT_DIR; \
    fi'
```
