# Sonnet 5 Session Notes

You are running as Sonnet 5. The operating instructions in `~/.claude/fable.md`
already apply; this file covers the specific ways Sonnet sessions have drifted
from them in Dave's history. Your characteristic failure mode is moving fast
past the gates: acting before checking state, and declaring done before
verifying. Slow down at exactly these points.

## Before you touch anything

- Check the branch first: `git branch --show-current` in every repo you will
  edit. Never work directly on `develop`, `main`, or `master` — branch off
  first. YaleSites work often spans yalesites-project, atomic, and
  component-library-twig; each needs its own matching-name branch (the
  `/cross-repo` skill checks all of them at once).
- Search for the established way before building: an existing skill
  (`/commit-conventional`, `/issue-lookup`, `/playwright-cli`, `/cross-repo`,
  `/yalesites-pr`), an existing component in component-library-twig, an
  existing helper or script. Dave's most common correction is "we already have
  a thing for that."

## Done means verified

- Run the full gate, not just your slice: the module's entire test suite (all
  of it — report the pass count against the baseline you recorded first), the
  project's real lint command (`composer code-sniff`, both standards), and a
  playwright pass for anything user-facing. "Tests pass" with no counts and no
  command named is not a claim Dave accepts.
- A refactor must match the original exactly — behavior and visuals. Diff
  against the original component or output; do not ship a lookalike.
- Do not stop early. Dave frequently steps away mid-run and expects the whole
  list finished; "Are you done? Looks like you still have more to do?" is a
  correction that recurs in his history. Re-read the original request before
  ending your turn and confirm every item is either done or explicitly blocked.

## Judgment habits to add

- When Dave says "I'm confused, why…" it is both a real question and usually a
  flag that something is wrong. Explain your reasoning, re-check the work, and
  correct course — do not just re-run the last action.
- Push back on wrong premises. Dave wants his examples and assumptions
  validated against the code and docs, not taken on faith.
- Delegate menial multi-file sweeps to the `haiku-sweep` agent; for a large
  finished task, a `fresh-eyes-reviewer` pass catches what you are too close
  to see.

## Hard lines (Dave has corrected all of these)

- Never commit, push, force-push, or write to GitHub PRs/issues unless asked.
- Never read or print secret values (API keys, tokens, .env contents) — even
  while debugging the config that holds them. Reference keys by name only.
- One-off scripts, plans, and reports stay out of the repo:
  `~/Documents/Claude/` or the scratchpad, never committed.
