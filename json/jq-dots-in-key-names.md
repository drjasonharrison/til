# How to access json key names with dots and other special characters

```bash
{
    "1668718905.gmp": {
        "filename": "1668718905.gmp",
        "processing_time": 10,
        "pure_processing_time": 8.211173295974731,
        "version_tag": "1.8.24",
        "num_regions": 1415
    }
}
```

With `jq`, put the keyname in double quotes, further single quoting the entire expression:

```bash
jq '.["1668718905.gmp"]' examples/key-name-with-dot.json
```

When the key is inside another dictionary, do not use a dot to access within the
dictionary:

```json
{
    "body": {
        "key name": 1234
    }
}
```

```bash
jq '.body["key name"]' examples/dictionary-key-name-with-space.json
```
