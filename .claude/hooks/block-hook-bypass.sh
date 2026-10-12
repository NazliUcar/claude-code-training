#!/usr/bin/env bash
# PreToolUse hook: stop Claude from pushing around the pre-push hook.
# Blocks `git push` with --no-verify, and any git command that overrides
# core.hooksPath. Exit 2 blocks the tool call and shows Claude the reason.

command="$(jq -r '.tool_input.command // empty')"

if printf '%s' "$command" | grep -Eq '(^|[^[:alnum:]_-])git([[:space:]].*)?[[:space:]]push([[:space:]]|$)' \
  && printf '%s' "$command" | grep -Eq -- '--no-verify'; then
  echo "Blocked: git push --no-verify skips the pre-push checks (tests, lint, build). Push without it; if the hook fails, fix the failure and tell the user." >&2
  exit 2
fi

if printf '%s' "$command" | grep -Eiq 'core\.hookspath|GIT_CONFIG_(COUNT|KEY|PARAMETERS)'; then
  echo "Blocked: overriding core.hooksPath would disable the pre-push checks. Ask the user if hooks need changing." >&2
  exit 2
fi

exit 0
