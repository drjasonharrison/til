# Date Conversions

## Epoch seconds to calendar date:

This will give you the date in the local system timezone.

```bash
$ date --date=@1652827099
Tue May 17 15:38:19 PDT 2022
```

## Epoch seconds to a specific timezone

However if you want a specific timezone, define TZ on the command line:

```bash
$ TZ=utc date --date=@1652827099
Tue May 17 22:38:19 utc 2022
```

## Various formats

### YYYY-MM-DD

```bash
date +%F
```

and tomorrow's date:

```bash
TODAY=$(TZ=UTC date "+%Y-%m-%d")
echo $TODAY
TODAY_SECONDS=$(TZ=UTC date +%s -d$TODAY)
echo $TODAY_SECONDS
TOMORROW_SECONDS=$(($TODAY_SECONDS + 24 * 60 *60))
echo $TOMORROW_SECONDS
TOMORROW=$(TZ=UTC date "+%Y-%m-%d" -d@$TOMORROW_SECONDS)
echo $TOMORROW
```

### YYYY-MM-DD-HH.MM (24 hour)

```bash
TZ=UTC date "+%Y-%m-%d-%H.%M")
```
