function ask
    set system_prompt \
        "You are Claude Code, Anthropic's official CLI for Claude.

CWD: $PWD
Date: $(date -I)"

    # acceptEdits, auto, bypassPermissions, default, dontAsk, plan
    set permission_mode auto

    # low, medium, high, xhigh, max
    set effort medium

    # opus, sonnet, haiku
    set model opus

    set tools (string join , Bash Edit Glob Grep Read Write WebFetch WebSearch)

    set user_message "$argv"
    if test -z $user_message
        read -P '> ' user_message
    end

    echo $prompt | claude --print --verbose \
        --no-session-persistence --no-chrome \
        --system-prompt $system_prompt \
        --permission-mode $permission_mode \
        --effort $effort \
        --model $model \
        --strict-mcp-config \
        --tools $tools \
        --allowed-tools $tools
end
