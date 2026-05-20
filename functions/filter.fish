function filter
    argparse -s -S -N1 s/split-args -- $argv
    or return

    if isatty stdin
        set sep (contains -i -- '--' $argv)
        or begin
            echo >&2 (status function): 'Missing -- separator'
            return 1
        end

        set pred $argv[..(math $sep - 1)]
        set inputs $argv[(math $sep + 1)..]
    else
        set pred $argv
        while read input
            set -a inputs "$input"
        end
    end

    for input in $inputs
        set args $input
        if set -q _flag_split_args
            set args (string split ' ' -- $input)
        end

        if $pred $args >/dev/null
            set -a outputs $input
        end
    end

    string collect -- $outputs
end

