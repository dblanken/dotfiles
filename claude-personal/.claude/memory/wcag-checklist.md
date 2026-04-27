# WCAG 2.1 AA Accessibility Checklist

Actionable checklist for implementing accessible web interfaces. Criteria numbers reference WCAG 2.1. Apply these when building or modifying UI components.

## Forms & Interactive Elements

### Labels & Descriptions
- Every `<input>`, `<select>`, `<textarea>` must have an associated label
  - Preferred: `<label for="field-id">` with matching `id`
  - Hidden visual label: `aria-label="Description"` (use sparingly)
  - Complex label: `aria-labelledby="id1 id2"` to compose from multiple elements
- Group related fields with `<fieldset>` and `<legend>` (e.g., radio groups, address blocks)
- Use `aria-describedby` to link hint text or instructions to the field
- Add `autocomplete` attribute for user data fields (name, email, address, etc.) [1.3.5]

### Error Handling [3.3.1, 3.3.3]
- Identify errors in text, not just color (red border alone is insufficient)
- Place error messages adjacent to the field, linked via `aria-describedby`
- Use `aria-invalid="true"` on fields with errors
- Provide suggestions for correction when possible (e.g., "Date must be MM/DD/YYYY")
- On form submission errors, either:
  - Move focus to an error summary at the top of the form, OR
  - Move focus to the first field with an error
- Use `role="alert"` or `aria-live="assertive"` for dynamically injected error messages

### Focus Management
- Visible focus indicator on all interactive elements (minimum 3:1 contrast) [2.4.7]
- Never use `outline: none` without providing a visible alternative
- Logical tab order follows visual reading order [2.4.3]
- After dynamic content changes (modal open, inline edit), move focus appropriately
- Return focus to trigger element when closing modals/dialogs/popups
- `tabindex="0"` to make non-interactive elements focusable when needed
- `tabindex="-1"` for programmatic focus (e.g., error summary heading)
- Never use `tabindex` values greater than 0

### Custom Widgets (ARIA Patterns)
- **Buttons**: Use `<button>` (not `<div onclick>`). If custom: `role="button"`, handle Enter and Space keys
- **Dialogs/Modals**: `role="dialog"`, `aria-modal="true"`, `aria-labelledby` pointing to heading, trap focus inside, restore focus on close
- **Tabs**: `role="tablist"`, `role="tab"`, `role="tabpanel"`, Arrow key navigation between tabs, `aria-selected`, `aria-controls`
- **Accordions**: `<button>` triggers with `aria-expanded`, `aria-controls` pointing to content panel
- **Combobox/Autocomplete**: `role="combobox"`, `aria-expanded`, `aria-activedescendant`, `role="listbox"` for options
- **Disclosure**: `<button aria-expanded="false/true">` controlling a related panel
- Do not use ARIA roles when a native HTML element provides the same semantics

## Content & Navigation

### Document Structure
- One `<h1>` per page matching the page title/purpose
- Heading levels must not skip (h1 -> h3 without h2 is invalid) [1.3.1]
- Use semantic HTML: `<nav>`, `<main>`, `<aside>`, `<header>`, `<footer>`, `<section>`, `<article>`
- Every page must have a `<main>` landmark
- Set `lang` attribute on `<html>` element [3.1.1]
- Mark language changes inline with `lang` attribute on the element [3.1.2]

### Navigation
- Provide a skip navigation link as the first focusable element [2.4.1]
  ```html
  <a href="#main-content" class="skip-link">Skip to main content</a>
  ```
- Consistent navigation order across pages [3.2.3]
- At least two ways to find each page (nav, search, sitemap) [2.4.5]
- Current page/section indicated in navigation (`aria-current="page"`)
- Breadcrumbs use `<nav aria-label="Breadcrumb">` with `<ol>`

### Links & Buttons
- Link text must be descriptive out of context [2.4.4]
  - Bad: "Click here", "Read more", "Learn more"
  - Good: "Read more about accessibility standards", or use `aria-label`
  - If multiple "Read more" links: differentiate with `aria-label` or `aria-labelledby`
- Links navigate, buttons perform actions. Do not use `<a>` as a button or vice versa
- Links must be visually distinguishable from surrounding text (not just by color) [1.4.1]

### Color & Contrast
- Normal text (< 18pt / < 14pt bold): minimum 4.5:1 contrast ratio [1.4.3]
- Large text (>= 18pt / >= 14pt bold): minimum 3:1 contrast ratio [1.4.3]
- UI components and graphical objects: minimum 3:1 contrast [1.4.11]
- Do not use color alone to convey information [1.4.1]
  - Example: Error states need text/icon in addition to red color
  - Example: Required fields need asterisk or text, not just color
- Text spacing must be adjustable without loss of content [1.4.12]

### Images & Media
- Informative images: descriptive `alt` text conveying the content/purpose
- Decorative images: `alt=""` (empty alt, not missing alt)
- Complex images (charts, diagrams): `alt` + longer description via `aria-describedby` or linked description
- SVG icons: `aria-hidden="true"` when decorative, or `role="img"` + `aria-label` when informative
- Video: captions [1.2.2] and audio descriptions [1.2.5] for prerecorded content

## Dynamic Content

### Live Regions
- Status messages: `role="status"` (polite) [4.1.3]
- Error alerts: `role="alert"` (assertive)
- Chat/log: `aria-live="polite"` with `aria-atomic="false"`
- Loading states: announce start and end of loading
- Toast notifications: use `role="status"` for non-critical, `role="alert"` for critical
- Place live region in DOM before content is injected into it

### Single Page Applications
- Announce route changes (move focus to new page heading or use live region)
- Update `<title>` on route change
- Manage focus on view transitions

### Keyboard
- All functionality operable via keyboard alone [2.1.1]
- No keyboard traps (except modals, which should trap intentionally) [2.1.2]
- Visible focus indicator on all interactive elements [2.4.7]
- Keyboard shortcuts: if single-character, must be remappable/disableable [2.1.4]

## Testing Checklist
- [ ] Tab through entire page - logical order, no traps, visible focus
- [ ] Screen reader test (VoiceOver on Mac, NVDA/JAWS on Windows)
- [ ] Zoom to 200% - no content loss or horizontal scrolling
- [ ] Check color contrast with browser devtools or axe
- [ ] Automated scan with axe-core or Lighthouse accessibility audit
- [ ] Test with keyboard only (no mouse)
- [ ] Test with high contrast / forced colors mode
