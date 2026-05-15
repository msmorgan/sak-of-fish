function quote
    argparse -S 'd/delimiter=&' -- $argv
    or return

    set -l delimiter $_flag_delimiter \"
    set cmd string replace -ar '^|$' $delimiter[1] -- $argv

    if isatty stdin
        $cmd
    else
        cat | $cmd
    end
end

