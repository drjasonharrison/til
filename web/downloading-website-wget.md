# Mirroring or downloading all of the files from a website

## Using wget

```bash
mkdir python.motionmetrics.net
cd !$
wget -mpEk "https://python.motionmetrics.net"
```

Options to wget (from the man page):
 - `-m`, `--mirror`: mirror, turns on options for recursion, time-stamping, infinite
        recursion depth, keeps FTP directory listings.
 - `-p`, `--page-requisites`: download all the files that are necessary to properly
        display a given HTML page
 - `-E`, `--adjust-extension`: adjust file extensions, use `.html`, `.css` etc if the url
        is missing the extension
 - `-k`, `--convert-links`: after download, convert links in `.html` files to use relative links

## Continuing a large file download

If a download is interrupted, use the `-c` or `--continue` flag to continue the download

```bash
wget bigfile
control-C
wget --continue bigfile
```

Example:

```bash
wget --continue python.motionmetrics.net/packages/torch-2.0.1+cu118-cp310-cp310-linux_x86_64.whl
```

## Copyright

```text
Copyright (c) 1996-2011, 2015, 2018 Free Software Foundation, Inc.

Permission is granted to copy, distribute and/or modify this document under the terms of the
GNU Free Documentation License, Version 1.3 or any later version published by the Free Software
Foundation; with no Invariant Sections, with no Front-Cover Texts, and with no Back-Cover
Texts.  A copy of the license is included in the section entitled "GNU Free Documentation
License".
```
