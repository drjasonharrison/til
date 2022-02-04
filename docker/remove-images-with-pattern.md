# Remove docker images with patterns

The patterns have path like behaviours, so if there is /, you need to handle it the
pattern.

Remove all versions of docker images starting with "truck" without any / in the repository
name:

```
docker rmi $(docker images --filter=reference="truck*:*" --quiet)
```

Remove all versions of docker images with a remote docker repo and / in the repository
name and include the --force flag to make sure that images that are shared are removed:

```
docker rmi --force $(docker images --filter=reference="*/truck*:*" --quiet)
```
