# Using `complete -C '$cmd -'`, pair the short and long opts of a command.
function flags --description "Get flags from 'complete', paired by description"
    argparse -N1 -X1 -- $argv; or return

    set sorted (complete -C "$argv[1] -" | sort -s -t\t -k2)

    for line in $sorted
        set parts (string split \t -- $line)

        if test "$parts[2]" != $desc
            set desc "$parts[2]"
            if set -q short
                set -a pairs $short # Short-only option
                set -e short
            end
        end

        switch $parts[1]
            case '--*'
                set long (string sub -s3 -- $parts[1])
                set -a pairs "$short/$long"
                set -e short
                set -e long
            case '-*'
                set short (string sub -s2 -- $parts[1])
        end
    end

    if set -q short
        set -a pairs $short
    end

    string join \n -- $pairs
end

