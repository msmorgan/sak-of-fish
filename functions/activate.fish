function activate --description "Activate python virtualenv"
    argparse --max-args 1 -- $argv
    or return

    set -a argv .venv venv

    for dir in $argv
        if type -q findup
            set -f venv (findup $dir)
        else
            set -f venv (path filter -d $dir)
        end
        and break
    end

    if not path is -d $venv
        echo >&2 "$(status function): " \
            "no virtualenv named $(string join , $argv)"
        return 1
    end

    type -q deactivate; and deactivate
    source $venv/bin/activate.fish
end

