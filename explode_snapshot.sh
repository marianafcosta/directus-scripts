# !/bin/bash

# DESCRIPTION
#
# This script will take a snapshot created by Directus and split it up into individual files, grouped by category (i.e. collections, fields, and relations). After running
# it, the target folder should have the following structure:
#
#  /target_folder
#    /collections
#      - collections_suggestions.yml
#      - ...
#    /fields
#      - fields_suggestions_id.yml
#      - ...
#    /relations
#      - relations_suggestions_tenant.yml
#      - ...
#    - base.yml

# USAGE
#
# ./explode_snapshot.sh <path_to_snapshot> <path_to_target_folder>
#
# * path_to_snapshot: Path to the snapshot file that you have created from running the `directus schema snapshot` command wherever you're running the CMS instance
# * path_to_target_folder: Path to the folder where the new snapshot structure will reside

# EXAMPLE
#
# ./explode_snapshot.sh ../snapshots/latest.yml ../snapshots

# NOTES
#
# * To create a snapshot in a Docker container, attach a shell to that container, run the command mentioned above, and copy it over to your local machine using the command
# `docker cp <src> <dest>`
# * The <path_to_target_folder> argument should not be followed by a `/`

export SNAPSHOT_FILE="${1}"
export TARGET_FOLDER="${2}"

export COLLECTIONS_FOLDER="${TARGET_FOLDER}/collections"
export FIELDS_FOLDER="${TARGET_FOLDER}/fields"
export RELATIONS_FOLDER="${TARGET_FOLDER}/relations"

echo "💥 Exploding the Directus snapshot file into individual files"

rm -rf "${TARGET_FOLDER}/collections" "${TARGET_FOLDER}/fields" "${TARGET_FOLDER}/relations"

mkdir -p "${TARGET_FOLDER}/collections" "${TARGET_FOLDER}/fields" "${TARGET_FOLDER}/relations"

yq '.collections[]' "${SNAPSHOT_FILE}" -s 'strenv(COLLECTIONS_FOLDER)+ "/collections_" + .collection'
yq '.fields[]' "${SNAPSHOT_FILE}" -s 'strenv(FIELDS_FOLDER) + "/fields_" + .collection + "_" + .field'
yq '.relations[]' "${SNAPSHOT_FILE}" -s 'strenv(RELATIONS_FOLDER) + "/relations_" + .collection + "_" + .field'

yq '. |= pick(["version", "directus"])' "${SNAPSHOT_FILE}" > "${TARGET_FOLDER}/base.yml"

echo "💥 Directus snapshot exploded"
