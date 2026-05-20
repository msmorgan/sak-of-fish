function findup --description 'Traverse parent directories to find a path.'
    argparse -S -N1 -X1 r/relative p/parent -- $argv
    or return

    set needle (path normalize $argv[1])
    if string match -qr '^/' $needle
        if set -q _flag_relative
            echo >&2 (status function): "absolute path incompatible with --relative"
            return 1
        end

        if set -q _flag_parent
            path filter (path normalize $needle/..)
        else
            path filter $needle
        end
        return
    end

    set haystack .
    while true
        set -l resolved (path resolve $haystack)
        if test -e $resolved/$needle
            break
        end
        set haystack $haystack/..

        if test (path resolve $haystack) = $resolved
            return 1
        end
    end

    if set -q _flag_parent
        set result $haystack
    else
        set result $haystack/$needle
    end

    if set -q _flag_relative
        path normalize $result
    else
        path resolve $result
    end
    return 0
end
