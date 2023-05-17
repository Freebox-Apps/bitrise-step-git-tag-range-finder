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
    case ${#tags_array[@]} in
        0)
            tag_start="HEAD^"
            tag_end="HEAD"
        ;;
        1)
            tag_start="${tags_array[0]}"
            tag_end="HEAD"
        ;;
        *)
            tag_start="${tags_array[1]}"
            tag_end="${tags_array[0]}"
        ;;
    esac
    
    commit_start=$(git log -1 --format=%H "${tag_start}")
    commit_end=$(git log -1 --format=%H "${tag_end}")
    envman add --key GIT_TAG_START --value "${tag_start}"
    envman add --key GIT_TAG_END --value "${tag_end}"
    envman add --key GIT_COMMIT_START --value "${commit_start}"
    envman add --key GIT_COMMIT_END --value "${commit_end}"

    echo "Start commit ${tag_start} (${commit_start})"
    echo "End commit ${tag_end} (${commit_end})"
done
