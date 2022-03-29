# how to extract a numeric field from a json file and do some math


```json
{
  "results": {
    "none": [
      {
        "utcTime": 1648532954
      },
      {
        "utcTime": 1648533021
      }
    ]
  }
}
```

Get difference between timestamps, sort, and output the smallest 10 values:

```bash
jq -r .results.none[].utcTime source-tile.json | awk '
    NR == 1{old = $1; next}     # if 1st line
    {print $1 - old; old = $1}  # else...
'| sort -n | head
```
