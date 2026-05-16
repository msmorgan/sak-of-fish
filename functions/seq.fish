function seq
    argparse -sS -xf,w -u --unknown-arguments none \
        f/format= s/separator= w/equal-width -- $argv
    or return
    set -p argv (string match -er '^-[0-9d.]' -- $argv_opts)
    if not set -q argv[1]
        echo >&2 "$(status function): expected >= 1 arguments; got 0"
        return 1
    else if set -q argv[4]
        echo >&2 "$(status function): expected <= 3 arguments; got $(count $argv)"
        return 1
    end

    set separator $_flag_separator \n; set separator $separator[1]
    set format $_flag_format '%g'; set format $format[1]

    set first 1; set increment 1
    switch (count $argv)
        case 1
            set last $argv[1]
        case 2
            set first $argv[1]; set last $argv[2]
        case 3
            set first $argv[1]; set increment $argv[2]; set last $argv[3]
    end
    if test $increment -eq 0
        echo >&2 "$(status function): increment cannot be 0"
        return 1
    end

    set cmp -le
    test $increment -lt 0; and set cmp -ge

    set i 0
    set n $first
    while test $n $cmp $last
        set -a nums (printf $format $n)
        set i (math $i + 1)
        set n (math -s max -- $first + \($i \* $increment\))
    end
    set -q nums[1]; or return 0

    if set -q _flag_equal_width
        set nums (string replace -r '\.|$' '.' -- $nums)
        set w[1] (math max 0,(string split -f1 . -- $nums | string length | string join ,))
        set w[2] (math max 0,(string split -f2 . -- $nums | string length | string join ,))
        test $w[2] -gt 0; and set w[1] (math $w[1] + 1 + $w[2])
        set nums (printf "%0$w[1].$w[2]f\n" $nums)
    end

    string join $separator -- $nums
end
