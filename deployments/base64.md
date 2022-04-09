# using base64 to encode deployment values

Use base64 encoded .env files rather than create a bunch of individual repository or
deployment pipeline variables.

You can also use this for
- AWs ECS task-definitions.
- `.npmrc` files
- etc


## To create base64 encoded environments

```bash
base64 --wrap=0 staging.env > staging.b64
base64 --wrap=0 production.env > production.b64
```

Because some `base64 -d` commands do not support line broken base64 data. And they don't
support `--ignore-garbage` like the GNU Coreutils version of base64.

## To use the base64 encode environments

Decode:

```
echo $NPMRC_base64 | base64 -d > .npmrc
echo $ENV_QC_I2LStaging_base64 | base64 -d > ./.env
echo $TASK_DEFINITION_base64 | base64 -d > task-definition.json
echo $TASK_DEFINITION_PROCESS_base64 | base64 -d > task-definition-process.json
```

Add to current environment (assumes bash like shell):


## substitute references to environment variables in a file:

```bash
/usr/local/bin/envsubst -no-unset -no-empty -i "${INPUT_FILE}" > "${OUTPUT_FILE}"
```

Confirm that the substitution didn't miss anything

```bash
/usr/local/bin/envsubst -no-unset -no-empty -i "${INPUT_FILE}" 2>&1 >/dev/null | sort | uniq
RESULT=$?
set -e
if (( RESULT )); then
    printf "Error: %s: unable to replace all referenced variables, exit code %s" "${INPUT_FILE}" "${RESULT}" >&2
    return
fi
```




## A script to copy the encoded file to the clipboard (if possible)

```bash
function print_clipboard_message {
    OUTPUT_VARIABLE="$1"
    OUTPUT_FILENAME="$2"

    ECHO
    ECHO "The contents of ${OUTPUT_FILENAME} has been copied to the"
    ECHO "system clipboard. "
    ECHO "Open the Bitbucket Repository and paste it into"
    ECHO "Repository settings->Repository variables, or into"
    ECHO "Repository settings->Deployments. Under the deployment"
    ECHO "I2L-Staging or I2L-Production as \"${OUTPUT_VARIABLE}\""
}


function print_open_file_copy_paste_message {
    OUTPUT_VARIABLE="$1"
    OUTPUT_FILENAME="$2"
    ECHO
    ECHO "Open ${OUTPUT_FILENAME} and copy the contents to the"
    ECHO "system clipboard. Then paste it into the bitbucket"
    ECHO "Repository settings->Repository variables, or into"
    ECHO "Repository settings->Deployments. Under the deployment"
    ECHO "I2L-Staging or I2L-Production as \"${OUTPUT_VARIABLE}\""
}


function copy_output_to_clipboard {
    if (( ! CREATE_ENV_FILE )); then
        return
    fi

    if (( CREATE_BASE_64 )); then
        OUTPUT_VARIABLE="TASK_DEFINITION_base64"
        OUTPUT_FILENAME="${OUTPUT_TASK_DEFINITION_JSON_B64}"
    else
        OUTPUT_VARIABLE="${OUTPUT_BITBUCKET_VARIABLE_NAME}"
        OUTPUT_FILENAME="${OUTPUT_ENV_B64_FILENAME}"
    fi

    if [[ -n "${DISPLAY+x}" && -n "${DISPLAY}" ]]; then
        case "$(uname -s)" in

           Darwin)
                pbcopy < "${OUTPUT_FILENAME}"
                print_clipboard_message "${OUTPUT_VARIABLE}" "${OUTPUT_FILENAME}"
                ;;

           Linux)
                xclip -selection clipboard  "${OUTPUT_FILENAME}"
                print_clipboard_message "${OUTPUT_VARIABLE}" "${OUTPUT_FILENAME}"
                ;;

           CYGWIN*|MINGW32*|MSYS*|MINGW*)
                ECHO "Unsupported: MS Windows. Unable to automatically copy encoded \"${OUTPUT_FILENAME}\" to the clipboard."
                print_open_file_copy_paste_message "${OUTPUT_VARIABLE}" "${OUTPUT_FILENAME}"
                ;;

           *)
                ECHO "Unrecognized OS.  Unable to automatically copy encoded \"${OUTPUT_FILENAME}\" to the clipboard."
                print_open_file_copy_paste_message "${OUTPUT_VARIABLE}" "${OUTPUT_FILENAME}"
                ;;
        esac
    fi
}
```
