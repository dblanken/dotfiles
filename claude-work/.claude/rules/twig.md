---
description: Twig template standards
paths:
  - "**/*.twig"
---

# Twig Standards

- Markup belongs in `.twig` files, not in PHP strings — separate concerns and
  keep syntax highlighting working. If a PHP method is building HTML/Twig in a
  string, move it to a template.
- No inline styles. Use the component library's existing components, classes,
  and data attributes; check for an existing component before writing new
  markup.
- Match the surrounding component's patterns (BEM-style classes, existing
  variables, attributes object) rather than inventing new conventions.
