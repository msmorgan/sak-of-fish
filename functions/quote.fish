function quote
    argparse --strict-longopts \
        "d/delimiter=&" \
        -- $argv
    or return

    set -l delimiter \"
    set -ql _flag_delimiter
    and set -l delimiter $_flag_delimiter

    string replace -ar '^|$' $delimiter[1] -- $argv
end
