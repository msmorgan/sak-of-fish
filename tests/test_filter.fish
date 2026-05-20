function _always; true; end
function _never; false; end
function _nonempty; test -n "$argv[1]"; end
function _starts_a; string match -q 'a*' -- $argv[1]; end

set -l r (filter _always -- a b c)
@test "filter always-true keeps all" (count $r) -eq 3

set -l r (filter _never -- a b c)
@test "filter always-false drops all" (count $r) -eq 0

set -l r (filter _nonempty -- a "" b "" c)
@test "filter nonempty drops empties (count)" (count $r) -eq 3
@test "filter nonempty drops empties (vals)" "$r" = "a b c"

set -l r (filter _starts_a -- apple ant banana avocado cherry)
@test "filter starts_a picks 3" (count $r) -eq 3
@test "filter preserves order" "$r[1]" = apple

set -l r (filter _always --)
@test "filter empty input → empty output" (count $r) -eq 0

filter _always a b c 2>/dev/null
@test "filter missing -- separator returns 2" $status -eq 2

set -l r (printf '%s\n' apple ant cherry | filter _starts_a)
@test "filter from stdin keeps a-words" (count $r) -eq 2
@test "filter from stdin order preserved" "$r[1]" = apple
@test "filter from stdin order preserved 2" "$r[2]" = ant

function _two_args; test "$argv[1]" = a -a "$argv[2]" = b; end
set -l r (filter -s _two_args -- "a b" "a c" "b b")
@test "filter --split-args passes split args to predicate" (count $r) -eq 1
@test "filter --split-args picks correct elem" "$r[1]" = "a b"
