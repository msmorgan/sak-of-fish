set -l r (yield a b c)
@test "yield emits 3 args as 3 cmdsub elements" (count $r) -eq 3
@test "yield preserves arg 1" "$r[1]" = a
@test "yield preserves arg 2" "$r[2]" = b
@test "yield preserves arg 3" "$r[3]" = c

set -l r (yield "a1
a2" "b1
b2")
@test "yield preserves multi-line elements as 2 elements" (count $r) -eq 2
@test "yield multi-line elem 1 keeps newline" "$r[1]" = "a1
a2"
@test "yield multi-line elem 2 keeps newline" "$r[2]" = "b1
b2"

set -l r (yield)
@test "yield of nothing → 0 elements" (count $r) -eq 0

yield x >/dev/null
@test "yield with args exits 0" $status -eq 0

yield >/dev/null
@test "yield with no args also exits 0 (return 0 explicit)" $status -eq 0

set -l empties "" "" ""
set -l r (yield $empties)
@test "yield preserves N empty elements" (count $r) -eq 3
