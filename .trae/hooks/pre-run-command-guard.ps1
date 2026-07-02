# Compatibility stub for the old PreToolUse RunCommand guard.
#
# This script is intentionally not registered in hooks.json. Older package
# versions used PreToolUse and read Trae hook payloads from stdin on every
# RunCommand. On some Windows Trae host versions stdin can remain open, which
# strands powershell.exe processes and causes memory growth. Keep this stub so
# stale references fail open and exit immediately instead of hanging.

$payload = @{
    hookSpecificOutput = @{
        hookEventName = "PreToolUse"
        permissionDecision = "allow"
        permissionDecisionReason = "PreToolUse guard is disabled by default to avoid Windows PowerShell stdin hangs."
    }
}

$payload | ConvertTo-Json -Depth 5 -Compress
