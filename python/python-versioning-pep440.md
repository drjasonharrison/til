# Python Versioning and PEP440

## Acceptable vs unacceptable versions

* Use a `+` between the major.minor.patch and the suffix:
    * No: "2.4.0_cpu_beta_8"
    * Yes: "2.4.0+cpu_beta_8"

* Do NOT use multiple `+` or a `+` anywhere other than the major.minor.patch and the
  suffix:
    * No: "2.4.0+cpu+beta_8"
    * No: "2.4.0+cpu_beta+8"
    * No: "2.4.0_cpu+beta_8"
    * No: "2.4.0_cpu_beta+8"

## checking a version string against the regex

```python
import re
import os

from packaging import version

version_regex = re.compile(
    r"^\s*" + version.VERSION_PATTERN + r"\s*$",
    re.VERBOSE | re.IGNORECASE,
)

with open("VERSION") as fh:
  version = fh.readline().strip()

version_regex.match(version)
```

the `match` function returns None when there is no match, and a Match object when there is
a match. Valid matches:

```python
version_regex.match("2.40.0")
<re.Match object; span=(0, 6), match='2.40.0'>
version_regex.match("2.40.0+cpu")
<re.Match object; span=(0, 10), match='2.40.0+cpu'>
version_regex.match("2.40.0+cpu_beta_0")
<re.Match object; span=(0, 17), match='2.40.0+cpu_beta_0'>
version_regex.match("2.40.0+cpu_beta_0")
<re.Match object; span=(0, 17), match='2.40.0+cpu_beta_0'>
```

No match:

```python
version_regex.match("2.40.0_cpu")
version_regex.match("2.40.0-cpu")
version_regex.match("2.40.0.cpu")
version_regex.match("2.40.0_cpu+beta_0")
version_regex.match("2.40.0+cpu+beta_0")
version_regex.match("2.40.0+cpu_beta+0")
version_regex.match("2.40.0+cpu_beta+0")
version_regex.match("2.40.0_cpu_beta+0")
version_regex.match("2.40.0_cpu_beta_0")
version_regex.match("2.40.0-cpu_beta_0")
version_regex.match("2.40.0.cpu_beta_0")
```
