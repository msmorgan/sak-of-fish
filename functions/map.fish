function map
    argparse -s -S -N1 s/split-args e/escape -- $argv
    or return

    if isatty stdin
        set sep (contains -i -- '--' $argv)
        or begin
            echo >&2 (status function): 'Missing -- separator'
            return 1
        end

        set cmd $argv[..(math $sep - 1)]
        set inputs $argv[(math $sep + 1)..]
    else
        set cmd $argv
        while read input
            set -a inputs "$input"
        end
    end

    for input in $inputs
        set args $input
        if set -q _flag_split_args
            set args (string split ' ' -- $input)
        end

        set output ($cmd $args | string collect -a)
        if set -q _flag_escape
            set output (string escape -- $output)
        end
        set -a outputs $output
    end

    string collect -- $outputs
end

