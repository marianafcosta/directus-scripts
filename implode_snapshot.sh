#!/bin/bash

# DESCRIPTION
#
# This script will take the files created by the explosion script and glue them back together into a single snapshot file.
# The snapshots folder is expected to have the following structure:
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
# ./explode_snapshot.sh <path_to_snapshot> <path_to_snapshots_folder>
#
# * path_to_snapshot: Path to the snapshot file that will be created by this script
# * path_to_snapshots_folder: Path to the folder where the individual snapshot fiels reside

# EXAMPLE
#
# ./implode_snapshot.sh ../snaphots/latest.yml ../snapshots

# NOTES
#
# * The <path_to_snapshots_folder> argument should not be followed by a `/`

export SNAPSHOTS_FILE="${1}"
export SNAPSHOTS_FOLDER="${2}"

export COLLECTIONS_FOLDER="${SNAPSHOTS_FOLDER}/collections"
export FIELDS_FOLDER="${SNAPSHOTS_FOLDER}/fields"
export RELATIONS_FOLDER="${SNAPSHOTS_FOLDER}/relations"

export BASE_FILE="${SNAPSHOTS_FOLDER}/base.yml"
export COLLECTIONS_FILE="${COLLECTIONS_FOLDER}/collections.yml"
export FIELDS_FILE="${FIELDS_FOLDER}/fields.yml"
export RELATIONS_FILE="${RELATIONS_FOLDER}/relations.yml"

echo "📸 Recreating the Directus snapshot file"

yq eval-all '[.] as $item ireduce([]; . *+ $item) | {"collections": .}' "${COLLECTIONS_FOLDER}"/*.yml > "${COLLECTIONS_FILE}"
yq eval-all '[.] as $item ireduce([]; . *+ $item) | {"fields": .}' "${FIELDS_FOLDER}"/*.yml > "${FIELDS_FILE}"
yq eval-all '[.] as $item ireduce([]; . *+ $item) | {"relations": .}' "${RELATIONS_FOLDER}"/*.yml > "${RELATIONS_FILE}"

yq eval-all '. as $item ireduce({}; . * $item)' "${BASE_FILE}" "${COLLECTIONS_FILE}" "${FIELDS_FILE}" "${RELATIONS_FILE}" > "${SNAPSHOTS_FILE}"

echo "📸 Directus snapshot ready"
