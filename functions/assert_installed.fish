function assert_installed
    argparse -S f/function= -- $argv
    or return

    set prefix $_flag_function:' '

    for cmd in $argv
        command -q $cmd
        or set -a errors "$prefix$cmd not installed"
    end

    if set -q errors[1]
        yield >&2 $errors
        return 1
    end
end

