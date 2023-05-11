#!/usr/bin/env bash
set -e

if "$is_debug" = "true"; then
    set -x
fi

git fetch -p -P --tags --no-recurse-submodules --quiet

tags=$(git tag -l "${tag_pattern}" --sort=-creatordate)

if "$is_debug" = "true"; then
    echo $tags
fi

echo -e $tags | while read -r -a tags_array; do
    commit_start=$(git show-ref -s "${tags_array[1]}")
    commit_end=$(git show-ref -s "${tags_array[0]}")
    envman add --key GIT_TAG_START --value "${tags_array[1]}"
    envman add --key GIT_TAG_END --value "${tags_array[0]}"
    envman add --key GIT_COMMIT_START --value "${commit_start}"
    envman add --key GIT_COMMIT_END --value "${commit_end}"

    echo "Start commit ${tags_array[1]} (${commit_start})"
    echo "End commit ${tags_array[0]} (${commit_end})"
done
