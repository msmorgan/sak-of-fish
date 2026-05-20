set -l spec \
    'f/forks'\t'Include forked repos' \
    'p/predicate='\t'jq predicate filter'

set -l frags (argspec parse $spec)
@test "argspec parse auto-injects h/help" (count $frags) -eq 3
@test "argspec parse h/help is first" "$frags[1]" = h/help
@test "argspec parse preserves boolean flag" "$frags[2]" = f/forks
@test "argspec parse preserves value flag with =" "$frags[3]" = p/predicate=

set -l frags (argspec parse '' '   ' '# comment' 'a/alpha'\t'hi')
@test "argspec parse skips blank lines and comments" (count $frags) -eq 2
@test "argspec parse keeps h/help and the real one" "$frags[2]" = a/alpha

argspec 2>/dev/null
@test "argspec with no subcommand returns 2" $status -eq 2

argspec bogus 2>/dev/null
@test "argspec with unknown subcommand returns 2" $status -eq 2

function _harness_spec
    yield \
        'f/forks'\t'Include forked repos' \
        'p/predicate='\t'jq predicate filter'
end
function _harness
    argparse -S (argspec parse (_harness_spec)) -- $argv; or return
    set -q _flag_help; and echo HELP; and return 0
    set -q _flag_forks; and echo FORKS
    set -q _flag_predicate; and echo "PRED=$_flag_predicate"
    echo "POS=$argv"
end

set -l r (_harness --forks user1 2>&1)
@test "argspec-driven argparse: --forks sets flag" "$r[1]" = FORKS
@test "argspec-driven argparse: positional passes through" "$r[2]" = "POS=user1"

set -l r (_harness --predicate '.x > 1' user1 2>&1)
@test "argspec-driven argparse: --predicate captures value" "$r[1]" = "PRED=.x > 1"

_harness --bogus 2>/dev/null
@test "argspec-driven argparse: unknown flag returns 2" $status -eq 2

set -l r (_harness --help 2>&1)
@test "argspec-driven argparse: --help sets _flag_help (auto-injected)" "$r[1]" = HELP

set -l help (argspec help myfn $spec)
@test "argspec help has usage line" (string match -q 'Usage: myfn*' -- $help[1]; echo $status) -eq 0
@test "argspec help mentions --help (auto-injected)" (string match -qr -- '-h, --help' (string join \n $help); echo $status) -eq 0
@test "argspec help mentions --forks" (string match -qr -- '-f, --forks' (string join \n $help); echo $status) -eq 0
@test "argspec help shows VAL for value flags" (string match -qr -- '--predicate=VAL' (string join \n $help); echo $status) -eq 0

function _no_short_spec
    yield 'verbose'\t'Be verbose'
end
set -l help (argspec help fn (_no_short_spec))
@test "argspec help handles long-only flag" (string match -qr -- '    --verbose' (string join \n $help); echo $status) -eq 0

complete -c _argspec_test_fn -e
argspec complete _argspec_test_fn $spec
set -l completes (complete -c _argspec_test_fn)
@test "argspec complete emits 2 entries per pair (3 specs → 6 lines)" (count $completes) -eq 6
@test "argspec complete emits short -h" (string match -q '*-s h*' -- (string join \n $completes); echo $status) -eq 0
@test "argspec complete emits long --help" (string match -q '*-l help*' -- (string join \n $completes); echo $status) -eq 0
@test "argspec complete marks value flags exclusive" (string match -q '*--exclusive*predicate*' -- (string join \n $completes); echo $status) -eq 0
complete -c _argspec_test_fn -e

set -l r (gh_repos --help 2>&1)
@test "gh_repos --help exits 0" $status -eq 0
@test "gh_repos --help starts with Usage" (string match -q 'Usage: gh_repos*' -- $r[1]; echo $status) -eq 0
@test "gh_repos --help mentions --forks" (string match -qr -- '-f, --forks' (string join \n $r); echo $status) -eq 0
@test "gh_repos --help mentions --predicate=VAL" (string match -qr -- '--predicate=VAL' (string join \n $r); echo $status) -eq 0

gh_repos --bogus 2>/dev/null
@test "gh_repos --bogus returns 2" $status -eq 2

gh_repos 2>/dev/null
@test "gh_repos with no positional returns 2" $status -eq 2
