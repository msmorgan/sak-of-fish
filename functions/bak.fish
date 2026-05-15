function __bak_unbak
    argparse --strict-longopts /dry-run \
        /mode= f/force c/copy e/extension= -- $argv
    or return

    set mode $_flag_mode

    set ext .bak
    set -q _flag_extension; and set ext $_flag_extension

    if test $mode = unbak
        argparse --strict-longopts o/original -- $argv
        or return

        set -q _flag_original; or set drop_ext
    end

    set cmd mv
    set -q _flag_copy; and set cmd cp -R

    set run eval
    set -q _flag_dry_run; and set run echo

    for path in $argv
        if not set -q drop_ext
            set original $path
            set backup $path$ext
        else
            set original (string replace -r "$ext\$" '' $path)
            or { echo >&2 "$mode: $path does not have the extension $ext"; continue }
            set backup $path
        end

        set srcdst $original $backup
        test $mode = unbak; and set srcdst $srcdst[-1..1]
        set src $srcdst[1]
        set dst $srcdst[2]

        if not path filter -q $src
            echo >&2 "$mode: $src does not exist"
            continue
        end

        if path filter -q $dst; and not set -q _flag_force
            echo >&2 "$mode: refusing to overwrite $dst (-f to force)"
            continue
        end

        $run rm -rf $dst
        $run $cmd $src $dst
    end
end

function bak; __bak_unbak --mode bak $argv; end
function unbak; __bak_unbak --mode unbak $argv; end

