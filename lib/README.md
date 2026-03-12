# SNOBOL4 Standard Library

This is the community standard library for SNOBOL4 — the missing stdlib that
Griswold never standardized. Files are designed for `-include` use, like
`#include <stdlib.h>` in C.

## Usage

```snobol4
-include 'library/stack.sno'
-include 'library/case.sno'
-include 'library/math.sno'
-include 'library/string.sno'
```

Run from the SNOBOL4-corpus root so paths resolve correctly.

## Files

| File | Purpose | Exports |
|------|---------|---------|
| `stack.sno` | General purpose stack | `stack_init` `stack_push` `stack_pop` `stack_peek` `stack_top` `stack_depth` |
| `case.sno` | Case conversion + case-insensitive matching | `lwr` `upr` `cap` `icase` |
| `math.sno` | Numeric utilities | `max` `min` `abs` `sign` `gcd` `lcm` |
| `string.sno` | String utilities | `lpad` `rpad` `ltrim` `rtrim` `trim` `repeat` `contains` `startswith` `endswith` `index` |

## Design Rules

Every library file follows these rules:

1. **DEFINE-only** — no executable statements at top level, no `END`
2. **Self-contained** — no `-include` dependencies on other library files
3. **Prefixed internals** — DATA types and global state use short prefixes
   to avoid collisions (`slink`/`stk` for stack, etc.)
4. **NRETURN for push-like functions** — enables pattern side-effect use:
   `subject (stack_push(x) FAIL | ...)` pushes as a side-effect
5. **FRETURN on empty/absent** — consistent with SNOBOL4 convention
6. **Tested** — each file has a corresponding `crosscheck/library/test_*.sno`

## Crosscheck Tests

```
crosscheck/library/test_stack.sno
crosscheck/library/test_case.sno
crosscheck/library/test_math.sno
crosscheck/library/test_string.sno
```

Each test prints expected output in a header comment and produces exactly
that output when run correctly.

## Relationship to `programs/inc/`

`programs/inc/` contains Lon's working include files, some of which overlap
with this library (`case.sno`, `stack.sno`, `counter.sno`, etc.). Those files
are production code — they may depend on globals like `xTrace`, use
application-specific conventions, or have Windows-era line endings.

The `library/` files are clean portable versions: no external dependencies,
no platform assumptions, consistent naming, fully documented.

## Adding a New Library File

1. Create `library/newfile.sno` — DEFINE-only, no `END`
2. Header comment listing every exported function with signature and brief description
3. Create `crosscheck/library/test_newfile.sno` — expected output in header comment
4. Verify on both csnobol4 and spitbol
5. Add to this README table
