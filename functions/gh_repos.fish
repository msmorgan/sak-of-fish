function gh_repos
    assert_installed -f (status function) -- gh jq
    or return

    argparse -S -N1 -X1 f/forks p/predicate= o/output= -- $argv
    or return

    set jq_filters '.[]'

    set -q _flag_forks
    or set -a jq_filters 'select(.fork | not)'

    set -q _flag_predicate
    and set -a jq_filters $_flag_predicate[1]

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

    string collect -- $repos
end
