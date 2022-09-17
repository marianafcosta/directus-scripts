# Directus workflow scripts

This is a collection of scripts to help with version-controlling the snapshot file produced by Directus. The YAML file can get incredibly big, and, from personal experience (at least for the first revisions of the snapshot feature) reviewing changes is quite a pain because:

* Things that we're not modified in the pull request move around;
* The actual changes would get scattered.

I'm sure the snapshot workflow will improve over time, but regardless I feel like having separate files for the fields, relations, and collections makes things more manageable.

# How it works

`explode_snapshot.sh` takes a Directus YAML snapshot file and uses [yq]() to parse the fields, relations, and collections. The output of this script is a folder containing 3 sub-folders for the aformentioned groups. Below is an example of how the folder structure will look like. `implode_snapshot.sh` joins them back together. `base.yml` contains root-level fields from the snapshots like the Directus version.

```
/target_folder
  /collections
    - collections_post.yml
    - ...
  /fields
    - fields_title.yml
    - ...
  /relations
    - relations_post_author.yml
    - ...
  - base.yml
```
