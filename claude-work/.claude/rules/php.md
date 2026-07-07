---
description: PHP / Drupal coding standards
paths:
  - "**/*.php"
  - "**/*.module"
  - "**/*.inc"
  - "**/*.install"
  - "**/*.theme"
  - "**/*.profile"
  - "**/*.engine"
---

# PHP Standards

- **Indentation**: 2 spaces; PSR-12; PHPUnit; Composer
- Prefer `use` statements over fully-qualified class names
- Render markup through Twig templates, never PHP string concatenation — if a
  method builds HTML in a string, move it to a `.twig` file (see `twig.md`)
