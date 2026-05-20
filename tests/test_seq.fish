set -l r (seq 5)
@test "seq N → 1..N (count)" (count $r) -eq 5
@test "seq N first" "$r[1]" = 1
@test "seq N last" "$r[-1]" = 5

set -l r (seq 3 7)
@test "seq START END (count)" (count $r) -eq 5
@test "seq START END first" "$r[1]" = 3
@test "seq START END last" "$r[-1]" = 7

set -l r (seq 1 2 9)
@test "seq START STEP END (count)" (count $r) -eq 5
@test "seq START STEP END first" "$r[1]" = 1
@test "seq START STEP END third" "$r[3]" = 5
@test "seq START STEP END last" "$r[-1]" = 9

set -l r (seq 10 -2 2)
@test "seq negative step (count)" (count $r) -eq 5
@test "seq negative step first" "$r[1]" = 10
@test "seq negative step last" "$r[-1]" = 2

set -l r (seq -s , 1 3)
@test "seq -s comma separator one element" (count $r) -eq 1
@test "seq -s comma joined" "$r[1]" = "1,2,3"

set -l r (seq -f '%02d' 1 3)
@test "seq -f format padding" "$r[1]" = 01
@test "seq -f format padding last" "$r[-1]" = 03

set -l r (seq -w 1 10)
@test "seq -w equal-width pads" "$r[1]" = 01
@test "seq -w equal-width last" "$r[-1]" = 10

seq 2>/dev/null
@test "seq no args returns 1" $status -eq 1

seq 1 2 3 4 2>/dev/null
@test "seq too many args returns 1" $status -eq 1

seq 1 0 5 2>/dev/null
@test "seq increment 0 returns 2" $status -eq 2

set -l r (seq 5 5)
@test "seq START==END single value" (count $r) -eq 1
@test "seq START==END value" "$r[1]" = 5
