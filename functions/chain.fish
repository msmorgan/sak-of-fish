# Chain multiple commands with the same set of args.
# Examples:
# 
#   chain mkdir cd -- newdir
#   chain 'git branch' 'git checkout' -- newbranch
#   chain nvim source -- functions/chain.fish

function chain
    set i 1
    for cmd in $argv
        if test $cmd = --
            break
        end
        set -a cmds $cmd
        set i (math $i + 1)
    end

    set args $argv[(math $i + 1)..]

    for cmd in $cmds
        set cmd (string split ' ' $cmd)
        $cmd $args
        or break
    end
end
