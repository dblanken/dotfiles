# SOLID Principles Reference

Practical guide to applying SOLID principles. These are guidelines, not dogma. Apply when they reduce complexity; skip when they'd add unnecessary abstraction.

## When to Apply SOLID

- Classes or modules growing beyond a single clear purpose
- Code that's difficult to test in isolation
- Changes to one feature frequently break another
- You need to extend behavior without modifying stable code

## When NOT to Apply (Over-Engineering)

- Simple scripts or one-off utilities
- Small functions with clear, limited scope
- Early stages where requirements are still forming (refactor later)
- When it would create more files/classes than the problem warrants

---

## S - Single Responsibility Principle

**A class should have one reason to change.**

Each class/module handles one concern. If you describe what a class does and use "and", it may have too many responsibilities.

```php
// Drupal: A form class handles form building and submission
// but delegates email sending to a mail service
class ContactForm extends FormBase {
  public function buildForm(array $form, FormStateInterface $form_state) {
    // Only form structure logic here
  }

  public function submitForm(array &$form, FormStateInterface $form_state) {
    // Delegates to a service for the actual work
    $this->mailService->sendContactEmail($form_state->getValues());
  }
}
```

```javascript
// JS: Separate data fetching from UI rendering
// fetch-users.js - data concern
export async function fetchUsers(filters) {
  const response = await fetch(`/api/users?${new URLSearchParams(filters)}`);
  return response.json();
}

// user-list.js - presentation concern
export function renderUserList(users, container) {
  const fragment = document.createDocumentFragment();
  users.forEach(user => {
    const el = document.createElement('div');
    el.textContent = user.name;
    fragment.appendChild(el);
  });
  container.replaceChildren(fragment);
}
```

## O - Open/Closed Principle

**Open for extension, closed for modification.**

Add new behavior by adding new code (new classes, plugins, event subscribers), not by changing existing working code.

```php
// Drupal plugin system is a natural fit
// Add new formatters by creating new plugins, not editing existing ones

/**
 * @FieldFormatter(
 *   id = "custom_date_formatter",
 *   label = @Translation("Custom Date"),
 *   field_types = {"datetime"}
 * )
 */
class CustomDateFormatter extends DateTimeFormatterBase {
  // Extends the system without modifying core formatters
}
```

```javascript
// JS: Strategy pattern for extensible behavior
const validators = {
  required: (value) => value !== '' || 'Field is required',
  email: (value) => /^[^@]+@[^@]+$/.test(value) || 'Invalid email',
  minLength: (min) => (value) => value.length >= min || `Minimum ${min} characters`,
};

// Add new validators without changing existing ones
validators.phone = (value) => /^\d{10}$/.test(value) || 'Invalid phone number';
```

## L - Liskov Substitution Principle

**Subtypes must be substitutable for their base types.**

If code works with a parent class/interface, it must work with any child class without surprises. Don't override methods in ways that break the parent's contract.

```php
// Good: Both implement the interface contract consistently
interface ContentExporter {
  public function export(NodeInterface $node): string;
}

class JsonExporter implements ContentExporter {
  public function export(NodeInterface $node): string {
    return json_encode($node->toArray());
  }
}

class CsvExporter implements ContentExporter {
  public function export(NodeInterface $node): string {
    return implode(',', $node->toArray());
  }
}

// Any ContentExporter can be used interchangeably
function exportContent(ContentExporter $exporter, NodeInterface $node): string {
  return $exporter->export($node); // works with any implementation
}
```

**Warning sign**: If you find yourself checking `instanceof` before calling a method, LSP may be violated.

## I - Interface Segregation Principle

**Clients should not depend on methods they don't use.**

Prefer small, focused interfaces over large ones. A class implementing an interface should need all of its methods.

```php
// Instead of one large interface:
// interface ContentHandler { create(); read(); update(); delete(); publish(); archive(); }

// Split by responsibility:
interface Readable {
  public function read(string $id): array;
}

interface Writable {
  public function create(array $data): string;
  public function update(string $id, array $data): void;
}

interface Publishable {
  public function publish(string $id): void;
}

// Classes implement only what they need
class ReadOnlyApi implements Readable {
  public function read(string $id): array { /* ... */ }
}

class FullApi implements Readable, Writable, Publishable {
  // Implements all, because it genuinely needs all
}
```

## D - Dependency Inversion Principle

**Depend on abstractions, not concretions.**

High-level modules should not depend on low-level modules. Both should depend on abstractions (interfaces/contracts).

```php
// Drupal: Inject services via dependency injection, not static calls
class MyController extends ControllerBase {
  public function __construct(
    private readonly EntityTypeManagerInterface $entityTypeManager,
    private readonly LoggerInterface $logger,
  ) {}

  // Don't do: \Drupal::entityTypeManager() (static coupling)
  // Do: use the injected $this->entityTypeManager
}
```

```javascript
// JS: Pass dependencies as parameters
async function processData(fetcher, transformer, storage) {
  const raw = await fetcher.getData();
  const processed = transformer.transform(raw);
  await storage.save(processed);
}

// Easy to test: pass mock implementations
// Easy to extend: swap implementations without changing this function
```

---

## Practical Decision Guide

| Situation | Apply | Skip |
|-----------|-------|------|
| Class has 2+ unrelated responsibilities | SRP | Single small function doing one thing |
| Need to add behavior variants | OCP (plugins, strategies) | Only one variant exists or is foreseeable |
| Subclass changes parent method behavior | Check LSP | No inheritance in use |
| Interface has methods some implementors don't need | ISP (split it) | Interface is small (2-3 methods) and cohesive |
| Class directly instantiates its dependencies | DIP (inject them) | Simple utility with no need for swapping |

## Rule of Three

Don't create abstractions preemptively. Wait until you see the same pattern three times before extracting an interface or base class. Two similar implementations might diverge; three confirms a real pattern.
