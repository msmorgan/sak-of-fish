complete -c math -f

complete -c math -s s -l scale -x -d 'Decimal places (integer or "max")' \
    -a 'max 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15'

set -l __math_bases \
    hex\t"hexadecimal (0x prefix)" \
    16\t"hexadecimal" \
    octal\t"octal (0 prefix)" \
    8\t"octal"

complete -c math -s b -l base -x -d 'Output base' \
    -a "$(string escape $__math_bases)"

complete -c math -s m -l scale-mode -x -d 'Rounding mode' \
    -a 'truncate round floor ceiling'

complete -c math -s h -l help -d 'Show help'

set -l __math_functions \
    abs\t"absolute value" \
    acos\t"arc cosine" \
    asin\t"arc sine" \
    atan\t"arc tangent" \
    atan2\t"arc tangent of two variables" \
    bitand\t"bitwise AND" \
    bitor\t"bitwise OR" \
    bitxor\t"bitwise XOR" \
    ceil\t"round up to integer" \
    cos\t"cosine" \
    cosh\t"hyperbolic cosine" \
    exp\t"base-e exponential" \
    fac\t"factorial" \
    floor\t"round down to integer" \
    ln\t"base-e logarithm" \
    log\t"base-10 logarithm" \
    log10\t"base-10 logarithm" \
    log2\t"base-2 logarithm" \
    max\t"largest of arguments" \
    min\t"smallest of arguments" \
    ncr\t"n-choose-r combinations" \
    npr\t"n-choose-r permutations" \
    pow\t"x to the y" \
    round\t"round to nearest integer" \
    sin\t"sine" \
    sinh\t"hyperbolic sine" \
    sqrt\t"square root" \
    tan\t"tangent" \
    tanh\t"hyperbolic tangent"

set -l __math_constants \
    e\t"Euler's number" \
    pi\t"π" \
    tau\t"2π"

complete -c math -n 'not __fish_seen_argument -s h -l help' \
    -a "$(string escape $__math_functions) $(string escape $__math_constants)"
