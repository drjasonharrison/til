# Date Conversions

(I've used some of these for a while)

## Epoch seconds to calendar date:

This will give you the date in the local system timezone.

```
$ date --date=@1652827099
Tue May 17 15:38:19 PDT 2022
```

## Epoch seconds to a specific timezone

However if you want a specific timezone, define TZ on the command line:

```
$ TZ=utc date --date=@1652827099
Tue May 17 22:38:19 utc 2022
```
