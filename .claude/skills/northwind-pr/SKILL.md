---
name: northwind-pr
description: Write a Northwind pull request description in the team's required format — ticket-ID title, plain-language summary, real verification evidence, honestly ticked acceptance criteria, and what was deliberately not done. Use when the user asks for a Northwind PR description, or invokes /northwind-pr.
---

# /northwind-pr

Write the pull request description for the work on the current branch, in the format below. Gather every fact first, write second. Nothing in the description may be something you did not read or run.

## 1. Read before writing anything

Run all of these before drafting a single line:

- `git branch --show-current` — the branch name carries the ticket ID (`NWP-201-issue-cards` → `NWP-201`). If it does not, check the commit subjects; if neither has one, ask the user.
- `git log main..HEAD --format='%h %s%n%b'` — what was done, in what order, and why.
- `git diff main...HEAD --stat`, then `git diff main...HEAD` — what actually changed. Read the diff itself, not just the stat.
- `git status --short` — uncommitted work is not in the PR. If there is any, say so to the user before going further.
- `docs/tickets/<TICKET-ID>.md` — the acceptance criteria, verbatim, and the out-of-scope list.
- `docs/specs/` — if a spec for this ticket exists, read it so you can note where the build departed from the plan.

If the branch has no commits ahead of `main`, stop and tell the user. There is nothing to describe.

## 2. Collect verification evidence — only what was actually run

This is the rule the whole skill exists to enforce: **never claim a verification step that was not actually run.**

A step counts as verified only if one of these is true:

1. **You ran it in this session** and saw the output. Quote the command and the relevant output line (for example the vitest summary line).
2. **The user pasted the command and its output** into this conversation. Quote it as theirs.

Nothing else counts. Not a commit message saying "tests pass", not a spec that planned to test it, not a test file existing in the diff, not something you assume the user did.

If the obvious checks have not been run, offer to run them now rather than leaving the section thin. For the merchant console that is, from `build-battle/merchant-console/`:

- `npm test`
- `npm run lint`
- `npm run build`

Ask before running anything beyond these. If a command fails, report the failure and its output — do not drop it from the description.

Browser checks ("opened /cards, issued a card, saw it in the list") can only come from the user. If they have not told you what they clicked and saw, ask. If they do not answer, list it as not verified.

Anything not verified goes in the description explicitly as **not run**, never silently omitted.

## 3. Check each acceptance criterion against the diff

Copy every checkbox from the ticket, core and stretch, in the ticket's order and wording. For each one, find the code in the diff that satisfies it.

- `[x]` — met, and you can point to where. Add the file in a short note when it helps the reviewer.
- `[ ]` with **Partial:** — some of it is done. Say which half is done and which is not.
- `[ ]` with no note, or **Not done** — nothing in the diff does it.

Do not tick a criterion because the code was intended to meet it, or because a commit message says it does. If a criterion can only be confirmed by running something that was not run, tick it on the code only if the code plainly does it, and say in the note that it was not exercised.

## 4. Write the description

Title:

```
<TICKET-ID>: <what it does>
```

Imperative, lower-case after the colon, under ~70 characters. `NWP-201: issue virtual cards from the console`.

Body, in exactly this order:

```markdown
## What changed

<One paragraph in plain language. What can someone do now that they could not before, and anything notable about how. No file list — the diff is the file list.>

## How I verified it

- `<command>` — <what it output: the summary line, the count, the error>
- <what was clicked in the browser and what appeared, if the user reported it>
- Not run: <each obvious check that was not run, so the reviewer knows>

## Acceptance criteria

- [x] **<criterion as written in the ticket>**
- [ ] **<criterion>** — Partial: <what is done, what is not>
- [ ] **<criterion>** — Not done

## Deliberately not done

- <ticket out-of-scope items that were respected, if relevant to the reviewer>
- <stretch goals skipped, and why>
- <known rough edges or follow-ups, with the ticket number if one exists (e.g. NWP-202, NWP-203)>
```

If the repository's `.github/pull_request_template.md` has sections this format does not (the ticket link, bugs fixed along the way), keep them too: put `Closes <TICKET-ID>` at the top, and add a **Bugs fixed along the way** section before **Deliberately not done** if the diff fixes anything beyond the ticket — name the file and the root cause.

## 5. Hand it over

Write the description to a file in the scratchpad directory and print it in full. Then offer:

```bash
gh pr create --title "<TICKET-ID>: <what it does>" --body-file <file>
```

Ask before running it. Opening a pull request is the user's call.

## Rules

- **No invented verification.** If it was not run in this session or pasted by the user, it is "not run". This is non-negotiable.
- **Honest ticks.** A partial criterion stated plainly beats a ticked one the reviewer finds empty.
- **Plain language.** "Ops can now issue a card and see it in the list" beats "implemented card issuance functionality".
- **Say what was left out.** The "Deliberately not done" section is never empty unless the ticket is genuinely complete, stretch goals included — and then say that.
- **No placeholders, no emoji, no filler.**
