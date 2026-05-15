# Using `complete -C '$cmd -'`, pair the short and long opts of a command.
function flags --description "Get flags from 'complete', paired by description"
    argparse -N1 -X1 -- $argv; or return

    set sorted (complete -C "$argv[1] -" | sort -s -t\t -k2)

    set i 1
    while true
        set parts (string split \t -- $sorted[$i])

        if test "$parts[2]" != "$desc"
            set desc "$parts[2]"
            set -a shorts (string join \t -- $short)
            set -a longs (string join \t -- $long)
            set -e short; set -e long
        end

        switch $parts[1]
            case '--*'
                set -a long (string sub -s3 -- $parts[1])
            case '-*'
                set -a short (string sub -s2 -- $parts[1])
            case ''
                break
        end

        set i (math $i + 1)
    end

    for i in (seq 1 (count $shorts))
        set short (string split \t -- $shorts[$i])
        set long (string split \t -- $longs[$i])

        echo "$(string join ',' $short)/$(string join ',' $long)"
    end
end

