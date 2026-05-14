function findup --description 'Traverse parent directories to find a path.'
    argparse --strict-longopts --min-args 1 --max-args 1 \
        "r/relative" \
        -- $argv
    or return

    set needle (path normalize $argv[1])
    if string match -qr '^/' $needle
        path filter $needle
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

    if set -qf _flag_relative
        echo (path normalize $haystack/$needle)
    else
        echo (path resolve $haystack/$needle)
    end
end
