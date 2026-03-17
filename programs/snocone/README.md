# Snocone

Andrew Koenig's Snocone preprocessor — C-like syntactic sugar for SNOBOL4.
Originally presented at USENIX, Portland, Oregon, June 1985.

## What Snocone Adds

- `if/else`, `while`, `do/while`, `for` — structured control flow
- `procedure` — replaces `DEFINE()` + label boilerplate
- `struct` — replaces `DATA()`
- `&&` — explicit concatenation (replaces ambiguous blank)
- `#include` — file inclusion
- C-like expression syntax with proper precedence and operator table

## Files in this directory

| File | Description | Origin |
|------|-------------|--------|
| `report.md` | Andrew Koenig's full language specification | USENIX 1985 paper |
| `patches/snocone.sc.diff` | CSNOBOL4 portability diff for `snocone.sc` | Phil Budne, 2000 |
| `patches/snocone.sno.diff` | CSNOBOL4 portability diff for `snocone.sno` | Phil Budne, 2000 |
| `patches/Makefile.budne` | Unix Makefile for C-MAINBOL build | Phil Budne, 2000 |
| `patches/README.budne` | Budne's patch notes | Phil Budne, 2000 |

## Source files (not included)

The Snocone compiler source files (`snocone.sc`, `snocone.sno`, `snocone.snobol4`)
are **not included** in this repository. Mark Emmer's distribution explicitly
prohibits redistribution of these sources in any form (modified or unmodified).

To obtain them, download the original distribution:

    ftp://ftp.snobol4.com/snocone/snocone.zip

Unzip with `-a` on Unix to handle line endings correctly, then apply
Phil Budne's CSNOBOL4 portability patches if needed:

    unzip -a snocone.zip
    patch < patches/snocone.sc.diff
    patch < patches/snocone.sno.diff

## License

**`report.md`** — Andrew Koenig's USENIX 1985 conference paper. Reproduced
here for reference. Copyright Andrew Koenig / USENIX Association.

**`patches/`** — Phil Budne's original portability patches (2000). No
redistribution restriction stated by Budne; included here with attribution.

**`snocone.sc` / `snocone.sno` / `snocone.snobol4`** — Mark Emmer's
distribution. Redistribution prohibited by Emmer's licence conditions.
Not present in this repository. Obtain from the URL above.

## snobol4ever Snocone front-end

The snobol4ever project implements a Snocone front-end that translates `.sc`
source to SNOBOL4 IR natively, without using Emmer's compiler as intermediary.
This is original work derived from the Koenig specification (`report.md`) and
the operator/precedence tables documented therein.

| Repo | File | Status |
|------|------|--------|
| snobol4jvm | `src/SNOBOL4clojure/snocone.clj` | Step 1 (lexer) ✓ |
| snobol4dotnet | `Snobol4.Common/Builder/SnoconeLexer.cs` | Step 1 (lexer) ✓ |
