# VS Code Spell Checker: Combining Dictionaries

## The VS Code Spell Checker

* the cSpell extension for VSCode
* Name: Code Spell Checker
* Id: streetsidesoftware.code-spell-checker
* Description: Spelling checker for source code
* Version: 2.20.3
* Publisher: Street Side Software
* VS Marketplace Link: https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker
* Github: https://github.com/streetsidesoftware/vscode-spell-checker

Custom words are stored in

1. Workspace Folder cspell.json
1. Workspace Folder .vscode/cspell.json
    * and .vscode/settings.json under key "cSpell.words"
1. VS Code Preferences cSpell section.
1. User VS Code settings ~/.config/Code/User/settings.json

## find, extract, sort, de-duplicate

From the root directory where repos are checked out:

```bash
for i in ../*/.vscode/settings.json ; do
    jq '."cSpell.words"' $i \
    | grep "\"" ;
done | sort | uniq | sed "s/\"$/,/"
```

That can be copied into the user VS Code Spell Checker dictionary

## Counting duplicates

number of duplicates:
```
for i in ../*/.vscode/settings.json ; do
    jq '."cSpell.words"' $i \
    | grep "\"" ;
done | sort | wc

for i in ../*/.vscode/settings.json ; do
    jq '."cSpell.words"' $i \
    | grep "\"" ;
done | sort | uniq | wc
```
