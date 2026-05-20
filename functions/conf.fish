function conf
    if not type -q "$EDITOR"
        echo >&2 "$(status function): \$EDITOR ($EDITOR) is not a command"
        return 1
    end

    argparse --strict-longopts -N1 -X1 'r/reload' -- $argv
    or return

    if string match -qr '^/' (path normalize $argv[1])
        echo >&2 "Config path must be relative to ~/.config"
        return 1
    end

    set config_file $HOME/.config/$argv[1]
    set parent_dir (path dirname $config_file)

    set temp_file (mktemp --suffix=(path extension $config_file))
    set original $config_file
    test -f $original; or set original /dev/null
    cp $original $temp_file

    if not $EDITOR $temp_file
        echo >&2 "Editing failed or was cancelled."
        rm $temp_file
        return 1
    end

    if cmp -s $temp_file $original
        echo >&2 "No changes."
        rm $temp_file
        return 0
    end

    mkdir -p $parent_dir
    cp $temp_file $config_file
    rm $temp_file

    set -q _flag_reload; and source $config_file
    echo >&2 "Updated "(and echo 'and reloaded '; or echo "")"$config_file."
end
