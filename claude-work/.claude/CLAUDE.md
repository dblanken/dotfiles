# Global Development Standards & Practices

Universal standards across all projects. Language- and UI-specific rules load
automatically from `~/.claude/rules/` (see Path-Scoped Rules); project-specific
conventions live in project-level CLAUDE.md files and specialized skills.

## Working Approach
- **Verify before done.** Run a concrete check (tests, build, lint, or a screenshot diff) and report the result before claiming work complete — no success claims without evidence.

## Core Principles
- **Readability over cleverness**; stay consistent with existing patterns in each codebase.
- **Security by default**: validate at system boundaries (user input, external APIs); trust internal code. Never commit secrets or expose sensitive data in errors. Use up-to-date dependencies and run a vulnerability scan before adding packages. See `~/.claude/memory/owasp-security.md` when working on security-sensitive code.
- **Accessibility**: WCAG 2.1 A/AA minimum on all UI — keep in mind when implementing or fixing. See `~/.claude/memory/wcag-checklist.md`.
- **Performance**: profile before optimizing; consider scalability.
- **SOLID** where it fits OOP contexts. See `~/.claude/memory/solid-principles.md`.
- **Rule of Three**: abstract only after the same pattern appears three times.

## Scope Discipline
Only make changes that are directly requested or clearly necessary.
- Don't add features, refactors, or abstractions beyond the task.
- Don't touch code unrelated to the current task.
- Don't add comments, docstrings, or type annotations to code you didn't change — but do document complex business logic or non-obvious decisions in code you do change.
- Delete unused code instead of renaming; no backwards-compatibility hacks.
- Don't design for hypothetical future requirements.
- Don't modify third-party modules directly — create patches or change our own code.
- Use descriptive names that clearly indicate purpose.

## Technology Stack & Tools
- **Backend**: PHP (Drupal), Python
- **Frontend**: JavaScript/TypeScript, Storybook, CSS
- **Tools**: Docker, Composer, NPM, Git
- **Editors**: Vim/Neovim (primary), VSCode (secondary)

## Path-Scoped Rules
Standards for specific file types load only when Claude works with matching files
(via `paths:` frontmatter), keeping this file focused on always-relevant guidance:

- `php.md` — PHP / Drupal (`*.php`, `*.module`, `*.theme`, …)
- `javascript.md` — JS / TS (`*.{js,jsx,ts,tsx,mjs,cjs}`)
- `css.md` — CSS / SCSS (`*.{css,scss,sass,less}`)
- `python.md` — Python (`*.py`)
- `bash.md` — shell scripts (`*.{sh,bash,zsh}`)
- `accessibility.md` — WCAG 2.1 A/AA for UI files (`*.tsx`, `*.scss`, `*.twig`, …)

## Git Workflow
- **Branch Naming**: adapt to project conventions.
- **Commits**: Conventional Commits format; present-tense, lowercase summary, with an explanatory body (why the change, what it solves, key context, references).
- **Atomic Commits**: one logical change per commit; group related changes, separate unrelated ones.
- **Never** mention Claude Code in commits or pull requests.

### Commit Structure
```
type(scope): brief summary

Detailed explanation when valuable:
- Why the change was made
- What problem it solves
- Important context or decisions
- References to documentation
```

### Pre-Commit Review Gate
Before committing code (i.e., before running `/commit-conventional`), run these on the
changes about to be committed, in order — then resolve findings, or note why one is
deferred, before committing:

1. **`/simplify`** — clean up the diff (quality only, no behavior change).
2. **`/code-review`** — skip only if it has already been run this session on the same changes; otherwise run it and address findings.
3. **`/security-review`** — when the diff touches auth, user input, secrets/env, external API calls, file uploads, or SQL — or whenever I ask.

Also run linting and formatting before committing.

Tool note: the gate uses the built-in `/code-review` (fast, diff-scoped, local by
default — only posts with `--comment`, and can `--fix` inline). Reserve the heavier
`/local-code-review` for branch- or PR-level review where a tracking-doc artifact is
wanted (e.g., reviewing someone else's work).

## Documentation
- **Professional tone**: never use emojis in docs, code comments, commit messages, or any project files.
- Clear, concise language; technical accuracy over visual appeal.
- Maintain comprehensive README.md files.

## Exploration & Research
- Prefer a subagent for multi-file exploration or research (roughly 3+ files); return summarized insights, not raw file dumps. Use the Haiku model for menial sweeps.
- Inline work is fine for small, known-scope lookups.

## Plans
- Superpowers plans go to `~/Documents/Claude/plans/` (not the default `docs/superpowers/plans/` within each project).

## Notes
- Use the most appropriate configuration for the current project context and task.

## Applied Learning
When something fails repeatedly, when Dave has to re-explain, or when a workaround is
found for a platform/tool limitation, add a one-line bullet here. Keep each under 15
words. No explanations. Only add things that will save time in future sessions.

- `~/.claude/CLAUDE.md` and `rules/` are stow symlinks to `~/.dotfiles/claude-work`; edit the real target.
