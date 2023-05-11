#!/usr/bin/env bash
set -e

git fetch -p -P --tags --no-recurse-submodules --quiet

tags=$(git tag -l "${tag_pattern}" --sort=-creatordate)

echo -e $tags | while read -r -a tags_array; do
    commit_start=$(git show-ref -s "${tags_array[1]}")
    commit_end=$(git show-ref -s "${tags_array[0]}")
    envman add --key GIT_TAG_START --value "${tags_array[1]}"
    envman add --key GIT_TAG_END --value "${tags_array[0]}"
    envman add --key GIT_COMMIT_START --value "${commit_start}"
    envman add --key GIT_COMMIT_END --value "${commit_end}"
done

echo "Start commit $GIT_TAG_START ($GIT_COMMIT_START)"
echo "End commit $GIT_TAG_END ($GIT_COMMIT_END)"
