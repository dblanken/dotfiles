# Global Development Standards & Practices

Universal coding standards and preferences across all projects.

## Core Development Philosophy
- **Code Quality**: Readability over cleverness; consistency with existing patterns
- **Security**: Security by default; validate inputs; follow OWASP guidelines
- **Accessibility**: WCAG 2.1 A and AA minimum (always keep in mind when implementing/fixing; we must comply)
- **Performance**: Consider scalability; profile before optimizing
- **SOLID Principles**: Apply where appropriate in OOP contexts

## Exploration & Research
- Use subagents for any exploration or research tasks.
- If a task needs 3+ files or multi-file analysis, spawn a subagent (Haiku model) and return only summarized insights.

## Technology Stack & Tools
- **Backend**: PHP (Drupal, Laravel, custom), Python
- **Frontend**: JavaScript/TypeScript, Storybook, CSS
- **Tools**: Docker, Composer, NPM, Git
- **Editors**: Vim/Neovim (primary), VSCode (secondary)

## Language-Specific Standards

### PHP
- **Indentation**: 2 spaces; PSR-12; PHPUnit; Composer
- Prefer `use` statements over fully-qualified class names

### JavaScript/TypeScript
- **Indentation**: 2 spaces
- **Linting**: ESLint
- **Testing**: Playwright (E2E), Jest (unit)
- **Build Tools**: Webpack, Vite
- **Package Manager**: NPM

### CSS
- **Indentation**: 2 spaces
- **Linting**: Stylelint
- **Accessibility**: WCAG compliance required

### Python
- **Indentation**: 4 spaces
- **Testing**: pytest
- **Package Manager**: pip

### Bash
- Follow shell scripting best practices
- Proper error handling and exit codes
- Comments for complex operations

## Git Workflow Standards
- **Branch Naming**: Adapt to project conventions
- **Pre-Commit**: Always run linting and formatting checks before committing
- **Commits**: Conventional Commits format with detailed explanatory body
- **Messages**: Present tense, lowercase, include context and reasoning
- **Atomic Commits**: Create separate commits for logically distinct changes
  - One commit per logical change (e.g., separate removing workflows from updating docs)
  - Makes git history clearer and easier to revert specific changes
  - Group related changes together, but separate unrelated changes
- **Never**: Mention Claude Code in commits or pull requests

### Commit Structure
```
type(scope): brief summary

Detailed explanation when valuable:
- Why the change was made
- What problem it solves
- Important context or decisions
- References to documentation
```

## Code Quality Standards
- **Consistency**: Follow existing patterns in each codebase
- **Naming**: Descriptive names that clearly indicate purpose
- **Comments**: Document complex business logic and non-obvious decisions
- **Rule of Three**: Only refactor into abstractions after seeing the same pattern three times
- **Avoid Over-Engineering**: Only make changes that are directly requested or clearly necessary

## Anti-Patterns to Avoid
- Don't add features not explicitly requested
- Don't refactor code unrelated to the current task
- Don't add comments, docstrings, or type annotations to code you didn't change
- Don't create helpers or abstractions for one-time operations
- Don't use backwards-compatibility hacks (delete unused code instead of renaming)
- Don't design for hypothetical future requirements
- Don't modify third-party modules directly (create patches or modify our own code instead)

## Error Handling Standards
- Validate at system boundaries only (user input, external APIs); trust internal code
- Never expose sensitive data in error messages

## Security Standards
- Never commit secrets; follow OWASP Top 10
- See ~/.claude/memory/owasp-security.md for examples when working on security-sensitive code
- Use up-to-date dependencies; run vulnerability scans before adding packages

## Accessibility Standards
- **Minimum**: WCAG 2.1 A and AA — always apply when implementing or fixing UI
- See ~/.claude/memory/wcag-checklist.md for the full checklist when building or reviewing UI

## Documentation Standards
- **Professional Tone**: Never use emojis in documentation, code comments, commit messages, or any project files
- Use clear, concise language without decorative symbols
- Focus on technical accuracy and clarity over visual appeal
- Maintain comprehensive README.md files

## Reference Documentation
The following files are in ~/.claude/memory/ — read them when working in their respective areas:
- `wcag-checklist.md` — WCAG 2.1 AA compliance checklist (forms, navigation, dynamic content)
- `owasp-security.md` — OWASP Top 10 prevention with PHP/JS/Python examples
- `solid-principles.md` — SOLID principles with practical decision guide
- `llm-infrastructure.md` — LLM provider stack and routing (local only, not in dotfiles git)

## Local Model Delegation
A local Qwen3 8B model runs on the CachyOS machine (192.168.86.47:8080) and is
accessible via the `llm` CLI. Use it to offload menial tasks:

```bash
llm -m local "<prompt>" < <file>   # summarize or analyze a file
llm -m local "<prompt>"             # general lightweight query
```

Good uses: summarizing files, reading large logs, answering simple questions about
file contents, grep/search assistance.

**If `llm -m local` errors for any reason, do not retry — handle the task directly.**
See `~/.claude/memory/llm-infrastructure.md` for full setup details.

## Plans Location
- All superpowers plans go to `~/Documents/plans/` instead of the default `docs/superpowers/plans/` within each project

## Notes
- Project-specific conventions are handled by project-level CLAUDE.md files or specialized skills
- Use the most appropriate configuration based on the current project context and task requirements

## Applied Learning
When something fails repeatedly, when Dave has to re-explain, or when a workaround is found for a platform/tool limitation, add a one-line bullet here. Keep each bullet under 15 words. No explanations. Only add things that will save time in future sessions.

- *(empty — populate as lessons emerge)*
