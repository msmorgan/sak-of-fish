function __gh_repos_spec
    yield \
        'f/forks'\t'Include forked repos' \
        'p/predicate='\t'jq predicate filter (e.g. .stargazers_count > 10)' \
        'o/output='\t'jq output expression (default: .full_name)'
end

complete -c gh_repos -f
argspec complete gh_repos (__gh_repos_spec)

function gh_repos
    set spec (__gh_repos_spec)

    argparse -S (argspec parse $spec) -- $argv
    or return

    if set -q _flag_help
        argspec help (status function) $spec
        return 0
    end

    if test (count $argv) -ne 1
        echo >&2 (status function): "expected 1 argument; got "(count $argv)
        return 2
    end

    assert_installed -f (status function) -- gh jq
    or return

    set jq_filters '.[]'

    set -q _flag_forks
    or set -a jq_filters 'select(.fork | not)'

    set -q _flag_predicate
    and set -a jq_filters "select($_flag_predicate[1])"

    if set -q _flag_output
        set -a jq_filters $_flag_output
    else
        set -a jq_filters '.full_name'
    end

    set per_page 100
    set owner $argv[1]

    set next "/users/$owner/repos?per_page=$per_page&sort=full_name"
    while set -q next[1]
        set response (string split -m1 \r\n\r\n -- (gh api -i $next[1] | string collect))
        set header $response[1]
        set next (string match -rg '^Link:.*<([^>]+)>; rel="next"' -- $header)

        set body $response[2]
        set -a repos (echo $body | jq -r (string join '|' $jq_filters))
    end

    yield $repos
end
