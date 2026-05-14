function ask
    set system_prompt \
        "You are Claude Code, Anthropic's official CLI for Claude.

CWD: $(pwd)
Date: $(date -I)"

    # acceptEdits, auto, bypassPermissions, default, dontAsk, plan
    set permission_mode auto

    # low, medium, high, xhigh, max
    set effort medium

    # opus, sonnet, haiku
    set model opus

    set tools (string join ',' \
                    Bash \
                    Edit \
                    Glob \
                    Grep \
                    Read \
                    Write \
                    WebFetch \
                    WebSearch \
                    )

    set prompt "$argv"
    if test -z $prompt
        printf "> "
        set prompt (head -1)
    end

#     jq -cn --arg prompt $prompt '
# .type = "message" |
# .message = (
#     .type = "text" |
#     .role = "user" |
#     .content[0] = (
#         .type = "text" |
#         .text = $prompt
#     )
# )' 
        # --input-format stream-json \
        # --output-format stream-json \
        # --replay-user-messages \
        # --include-hook-events \
        # --include-partial-messages \

    echo $prompt | claude --print --verbose \
        --no-session-persistence --no-chrome \
        --system-prompt $system_prompt \
        --permission-mode $permission_mode \
        --effort $effort \
        --model $model \
        --strict-mcp-config \
        --tools (string join , $tools) \
        --allowed-tools (string join , $tools)
end
