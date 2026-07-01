# UserPromptSubmit hook for Superpowers for Trae.
# Keep this short: it is injected on every user prompt.

$ErrorActionPreference = "Stop"

Write-Output @"
<SUPERPOWERS_RUNTIME_REMINDER>
Before responding or acting, check whether a Superpowers skill applies. Use Trae native Skill(name="<skill>") before file reads, shell commands, implementation, debugging, planning, or completion claims. Bugs and failed tests require Skill(name="systematic-debugging"); production code requires Skill(name="test-driven-development"); completion claims require Skill(name="verification-before-completion").
</SUPERPOWERS_RUNTIME_REMINDER>
"@
