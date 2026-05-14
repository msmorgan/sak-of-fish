function mkcd
    argparse -N1 -X1 -- $argv
    or return
    mkdir -p $argv[1]; and cd $argv[1]
end
