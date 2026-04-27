# OWASP Top 10 Security Reference

Practical prevention techniques for web application security. Apply these at system boundaries (user input, API endpoints, data storage). Examples prioritize PHP/Drupal, JavaScript, and Python.

## 1. Injection (SQL, Command, LDAP)

**Principle**: Never concatenate untrusted input into queries or commands.

**Prevention**:
- Use parameterized queries / prepared statements exclusively
- Use ORM/query builders that handle escaping
- Validate input type and format before processing

```php
// PHP/PDO - parameterized query
$stmt = $pdo->prepare('SELECT * FROM users WHERE email = :email');
$stmt->execute(['email' => $input]);

// Drupal - database API (always parameterized)
$result = \Drupal::database()->select('users', 'u')
  ->fields('u')
  ->condition('email', $input)
  ->execute();
```

```javascript
// Node.js - parameterized query (pg library)
const result = await pool.query('SELECT * FROM users WHERE email = $1', [input]);
```

```python
# Python - parameterized query
cursor.execute("SELECT * FROM users WHERE email = %s", (input,))
```

**Command injection**: Avoid shell execution functions entirely. If unavoidable, use `escapeshellarg()` (PHP) or `shlex.quote()` (Python). Prefer language-native libraries over shell commands.

## 2. Broken Authentication

**Prevention**:
- Hash passwords with bcrypt/argon2 (never MD5/SHA1 for passwords)
- Implement account lockout or rate limiting after failed attempts
- Use secure session configuration
- Regenerate session ID after login
- Set appropriate session timeouts

```php
// PHP password hashing
$hash = password_hash($password, PASSWORD_BCRYPT, ['cost' => 12]);
if (password_verify($input, $hash)) { /* authenticated */ }

// Session security
session_regenerate_id(true); // after login
ini_set('session.cookie_httponly', 1);
ini_set('session.cookie_secure', 1);
ini_set('session.cookie_samesite', 'Lax');
```

## 3. Sensitive Data Exposure

**Prevention**:
- Use HTTPS everywhere (HSTS header)
- Never store passwords in plaintext; use strong hashing
- Encrypt sensitive data at rest
- Never log sensitive data (passwords, tokens, PII)
- Never commit secrets to version control
- Use environment variables or secret management for credentials
- Set `Referrer-Policy: strict-origin-when-cross-origin`

```php
// Environment-based config (never hardcode)
$apiKey = getenv('API_KEY');

// Drupal settings.php pattern
$databases['default']['default'] = [
  'database' => getenv('DB_NAME'),
  'username' => getenv('DB_USER'),
  'password' => getenv('DB_PASS'),
];
```

## 4. XML External Entities (XXE)

**Prevention**: Disable external entity processing in XML parsers.

```php
// PHP - disable external entities
libxml_disable_entity_loader(true);
$doc = new DOMDocument();
$doc->loadXML($input, LIBXML_NONET | LIBXML_DTDLOAD);
```

```python
# Python - use defusedxml
from defusedxml import ElementTree
tree = ElementTree.parse(source)
```

- Prefer JSON over XML when possible
- If accepting XML uploads, validate and sanitize before parsing

## 5. Broken Access Control

**Prevention**:
- Deny by default; explicitly grant access
- Check authorization on every request (server-side, never client-only)
- Use indirect object references (don't expose database IDs in URLs when avoidable)
- Validate that the authenticated user has permission to access the requested resource
- Implement CORS restrictively

```php
// Drupal access checking
$entity->access('view', \Drupal::currentUser());

// PHP - verify ownership
$item = Item::find($id);
if ($item->user_id !== $currentUser->id) {
  throw new AccessDeniedHttpException();
}
```

**CORS** - Use restrictive origins (never wildcard with credentials):
```php
header('Access-Control-Allow-Origin: https://trusted-domain.com');
header('Access-Control-Allow-Methods: GET, POST');
header('Access-Control-Allow-Credentials: true');
```

**CSRF**: Use framework-provided CSRF tokens on all state-changing requests.

## 6. Security Misconfiguration

**Prevention**:
- Remove default credentials and unnecessary features
- Disable directory listing
- Set security headers on all responses
- Production error pages must not expose stack traces or internal details
- Keep frameworks and dependencies updated

**Security Headers**:
```
Strict-Transport-Security: max-age=31536000; includeSubDomains
X-Content-Type-Options: nosniff
X-Frame-Options: DENY (or SAMEORIGIN if iframes needed)
Referrer-Policy: strict-origin-when-cross-origin
Permissions-Policy: camera=(), microphone=(), geolocation=()
```

## 7. Cross-Site Scripting (XSS)

**Principle**: Encode output based on the context where it appears.

**Prevention**:
- HTML context: HTML-encode (`htmlspecialchars()` in PHP, auto-escaping in Twig/Drupal)
- JavaScript context: JSON-encode, never interpolate into inline scripts
- URL context: URL-encode (`urlencode()`, `encodeURIComponent()`)
- CSS context: CSS-escape
- Implement Content Security Policy (CSP) header
- Use `HttpOnly` and `Secure` flags on cookies

```php
// PHP - always encode output
echo htmlspecialchars($userInput, ENT_QUOTES, 'UTF-8');

// Drupal - Twig auto-escapes by default
// Only use {{ variable|raw }} when you have explicitly sanitized
// Use Xss::filter() or Html::escape() in PHP
```

```javascript
// JavaScript - always use textContent for user-provided strings
element.textContent = userInput; // safe: treats input as text, not HTML

// React auto-escapes by default in JSX expressions
// Always sanitize with DOMPurify before rendering any user-provided HTML
```

**CSP Header** (start restrictive, loosen as needed):
```
Content-Security-Policy: default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data:;
```

## 8. Insecure Deserialization

**Prevention**:
- Never deserialize untrusted data
- PHP: use `json_decode()` instead of native deserialization on user input
- Python: use JSON for data exchange; avoid native object serialization on untrusted input
- Validate and type-check all deserialized data
- Implement integrity checks (HMAC) on serialized objects

## 9. Using Components with Known Vulnerabilities

**Prevention**:
- Run `composer audit` (PHP) and `npm audit` (JS) regularly
- Pin dependency versions; review changelogs before updating
- Remove unused dependencies
- Subscribe to security advisories for critical dependencies
- Check before adding new packages: maintenance status, known CVEs, license
- Use Dependabot or Renovate for automated update PRs

## 10. Insufficient Logging & Monitoring

**What to log**:
- Authentication events (login, logout, failed attempts)
- Authorization failures (access denied)
- Input validation failures
- Application errors and exceptions
- Administrative actions

**What NOT to log**:
- Passwords or credentials
- Session tokens or API keys
- Full credit card numbers or SSNs
- Personal data beyond what's needed for debugging

**Best practices**:
- Use structured logging (JSON format)
- Include request ID for tracing
- Log at appropriate levels (ERROR for failures, WARN for suspicious activity, INFO for audit trail)
- Set up alerts for repeated authentication failures or unusual patterns

## Quick Decision Reference

| Scenario | Action |
|----------|--------|
| User input in SQL | Parameterized query |
| User input in HTML | HTML-encode output |
| User input in URL | URL-encode |
| User input in shell command | Avoid; use language APIs instead |
| Storing passwords | bcrypt or argon2, cost >= 12 |
| API authentication | Token-based, HTTPS only, short expiry |
| File uploads | Validate type, rename, store outside webroot |
| Error messages to users | Generic message; log details server-side |
| New dependency | Check audit, CVEs, maintenance, license |
