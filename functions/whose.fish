function whose
    argparse -N1 --strict-longopts c/command -- $argv
    or return

    for path in $argv
        set -q _flag_command
        and set path (which $path)

        pacman -Qo $path
    end
end
