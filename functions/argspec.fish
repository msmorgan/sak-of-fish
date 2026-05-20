function argspec --description 'CLI surface helper: parse | help | complete'
    if not set -q argv[1]
        echo >&2 (status function): 'missing subcommand: parse, help, or complete'
        return 2
    end

    set sub $argv[1]
    set rest $argv[2..]

    switch $sub
        case parse
            __argspec_parse $rest
        case help
            __argspec_help $rest
        case complete
            __argspec_complete $rest
        case '*'
            echo >&2 (status function): "unknown subcommand: $sub"
            return 2
    end
end

function __argspec_parse
    for line in 'h/help'\t'Show help' $argv
        string match -qr '^\s*$|^\s*#' -- $line; and continue
        set frag (string trim -- (string split -m1 \t -- $line)[1])
        test -n "$frag"; and set -a out $frag
    end
    yield $out
end

function __argspec_help
    set name $argv[1]
    set spec $argv[2..]

    for line in 'h/help'\t'Show help' $spec
        string match -qr '^\s*$|^\s*#' -- $line; and continue
        set parts (string split -m1 \t -- $line)
        set frag (string trim -- $parts[1])
        set desc (string trim -- $parts[2..])

        set short ''
        set long ''
        set arg ''

        set core (string replace -r '[=!].*$' '' -- $frag)
        set tail (string sub -s (math (string length -- $core) + 1) -- $frag)
        if string match -qr '^[a-zA-Z0-9]/' -- $core
            set short (string sub -l1 -- $core)
            set long (string sub -s3 -- $core)
        else if string match -qr '^[a-zA-Z0-9]-' -- $core
            set short (string sub -l1 -- $core)
        else
            set long $core
        end

        switch (string sub -l2 -- $tail)
            case '=?'
                set arg '[=VAL]'
            case '=+'
                set arg '=VAL...'
            case '=*'
                set arg '=VAL'
        end
        test -z "$arg"; and string match -q '=*' -- $tail; and set arg '=VAL'

        set left ''
        test -n "$short"; and set left "-$short"
        if test -n "$long"
            test -n "$left"; and set left "$left, --$long$arg"
            or set left "    --$long$arg"
        else
            set left "$left$arg"
        end

        set -a lefts $left
        set -a descs $desc
    end

    set width 0
    for l in $lefts
        set len (string length -- $l)
        test $len -gt $width; and set width $len
    end

    echo "Usage: $name [OPTIONS]"
    echo
    echo "Options:"
    for i in (seq 1 (count $lefts))
        printf "  %-"$width"s  %s\n" $lefts[$i] $descs[$i]
    end
end

function __argspec_complete
    set name $argv[1]
    set spec $argv[2..]

    for line in 'h/help'\t'Show help' $spec
        string match -qr '^\s*$|^\s*#' -- $line; and continue
        set parts (string split -m1 \t -- $line)
        set frag (string trim -- $parts[1])
        set desc (string trim -- $parts[2..])

        set short ''
        set long ''
        set takes_value 0

        set core (string replace -r '[=!].*$' '' -- $frag)
        set tail (string sub -s (math (string length -- $core) + 1) -- $frag)
        if string match -qr '^[a-zA-Z0-9]/' -- $core
            set short (string sub -l1 -- $core)
            set long (string sub -s3 -- $core)
        else if string match -qr '^[a-zA-Z0-9]-' -- $core
            set short (string sub -l1 -- $core)
        else
            set long $core
        end

        string match -q '=*' -- $tail; and set takes_value 1

        set args -c $name
        test -n "$short"; and set -a args -s $short
        test -n "$long"; and set -a args -l $long
        test $takes_value -eq 1; and set -a args -x
        test -n "$desc"; and set -a args -d $desc

        complete $args
    end
end
