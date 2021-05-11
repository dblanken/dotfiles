#
# Copied from __fish_complete_directories
# I did not like that it used the full path for a directory only listing
# and I did not need to be reminded that it was a directory via the description
# Instead I reuse the function to instead strip the path and disregard the
# description.
#
# Find directories that complete $argv[1], output them as completions
# with description $argv[2] if defined, otherwise use 'Directory'.
# If no arguments are provided, attempts to complete current commandline token.
#
function __dir_only_fish_complete_directories -d "Complete directory prefixes" --argument comp desc
    if not set -q comp[1]
        set comp (commandline -ct)
    end

    # HACK: We call into the file completions by using a non-existent command.
    # If we used e.g. `ls`, we'd run the risk of completing its options or another kind of argument.
    # But since we default to file completions, if something doesn't have another completion...
    set -l dirs (complete -C"nonexitentcommandooheehoohaahaahdingdongwallawallabingbang $comp" | string match -r '[^/]*/$' | sed 's/.$//')

    if set -q dirs[1]
        printf "%s\n" $dirs
    end
end
