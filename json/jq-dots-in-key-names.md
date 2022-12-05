# How to access json key names with dots and other special characters

```bash
{
  "1668718905.gmp": {
    "filename": "1668718905.gmp",
    "processing_time": 10,
    "pure_processing_time": 8.211173295974731,
    "version_tag": "1.8.24",
    "num_regions": 1415,
  }
}
```

With `jq`, put the keyname in double quotes, further single quoting the entire expression:

```bash
jq '.["1668718905.gmp"]' staging/job-statistics.json
```
