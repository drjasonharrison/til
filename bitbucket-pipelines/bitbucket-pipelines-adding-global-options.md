# bitbucket pipelines: adding global options (and removing stuff from other pipelines)

## problem

Need to add global options to a bitbucket-pipeline.yml and remove all "size", "cloud",
"runtime", "atlassian-ip-ranges".

Reference: https://support.atlassian.com/bitbucket-cloud/docs/global-options/

Order of operations:

1. remove

    ```bash
    grep -v -e " size: 2x" \
        -e "size: 4x" \
        -e " cloud:" \
        -e "runtime:" \
        -e " atlassian-ip-ranges:" \
        bitbucket-pipelines.yml > bp.yml
    ```

2. compare original and "clean" file:

    ```bash
    diff --side-by-side bitbucket-pipelines.yml bp.yml
    ```

3. Add before the "definitions:" key the contents of `options.yml`

    ```yaml
    options:
      size: 4x # Quadruple resources available for this step.
      runtime:
        cloud:
          atlassian-ip-ranges: true # requires size 4x or 8x
    ```

    using sed:

    ```bash
    sed '/^definitions:$/e cat options.yml' bp.yml > bp2.yml
    ```

4. compare original and final version of the pipeline file:

    ```bash
    diff --side-by-side bitbucket-pipelines.yml bp2.yml
    ```

5. copy the file bp2.yml to bitbucket-pipelines.yml, then git add, git commit, etc...
