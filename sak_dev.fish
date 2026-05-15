# sak-of-fish — dev-mode entry point.
#
# When sourced from conf.d, prepends the repo's functions/ and
# completions/ directories to $fish_function_path and $fish_complete_path,
# so edits in the repo take effect in new shells immediately.
#
# Install:
#
#     fish sak_dev.fish link
#
# Uninstall:
#
#     fish sak_dev.fish unlink

switch $argv[1]
    case "link"
        ln -s (status filename | path resolve) ~/.config/fish/conf.d/sak_dev.fish
        return
    case "unlink"
        rm ~/.config/fish/conf.d/sak_dev.fish
        return
end

set -q __sak_loaded; and return
set -g __sak_loaded 1

set __sak_root (status filename | path resolve | path dirname)

set -p fish_function_path $__sak_root/functions
set -p fish_complete_path $__sak_root/completions

