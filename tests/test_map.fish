function _id; echo $argv; end
function _upper; string upper -- $argv; end
function _double; echo "$argv$argv"; end
function _empty; end
function _multiline; printf '%s\n%s' "$argv-a" "$argv-b"; end

set -l r (map _id -- foo bar baz)
@test "map id preserves count" (count $r) -eq 3
@test "map id preserves order [1]" "$r[1]" = foo
@test "map id preserves order [3]" "$r[3]" = baz

set -l r (map _upper -- aaa bbb)
@test "map upper transforms each" "$r[1]" = AAA
@test "map upper transforms each [2]" "$r[2]" = BBB

set -l r (map _double -- x y)
@test "map double" "$r[1]" = xx
@test "map double [2]" "$r[2]" = yy

set -l r (map _empty -- a b c)
@test "map empty-cmd preserves slot count" (count $r) -eq 3

set -l r (map _multiline -- x y)
@test "map preserves multi-line per input as one element" (count $r) -eq 2
@test "map multi-line content [1]" "$r[1]" = "x-a
x-b"

set -l r (map _id --)
@test "map empty input → empty output" (count $r) -eq 0

map _id a b 2>/dev/null
@test "map missing -- separator returns 2" $status -eq 2

set -l r (printf '%s\n' foo bar | map _upper)
@test "map from stdin transforms each" (count $r) -eq 2
@test "map from stdin [1]" "$r[1]" = FOO

function _join; echo "$argv[1]+$argv[2]"; end
set -l r (map -s _join -- "a b" "c d")
@test "map --split-args splits each input" (count $r) -eq 2
@test "map --split-args splits to multiple args" "$r[1]" = "a+b"
