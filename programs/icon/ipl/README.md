# Icon Program Library (IPL) — Source Archive

Source: Icon 9.5.20b distribution (`icon-master`), IPL subdirectory.
Copied verbatim — no modifications. 851 `.icn` files total.

These are the canonical reference programs for the Tiny-ICON frontend.
They serve as:
- Oracle inputs (run through `icont`/`iconx` to generate expected output)
- Feature coverage targets for rung 4+ corpus expansion
- Language reference for emitter correctness

## Directory layout

| Directory | Contents | Count |
|-----------|----------|-------|
| `progs/`  | Standalone programs with `procedure main` | 275 |
| `procs/`  | Library procedures (no `main`) | 251 |
| `gprogs/` | Graphics programs (X11 — won't run headless) | 177 |
| `gprocs/` | Graphics library procedures | 140 |
| `packs/`  | Package source files | varies |
| `gpacks/` | Graphics package source | varies |
| `incl/`   | Include files | varies |
| `gincl/`  | Graphics include files | varies |

## Usage

Run any `progs/` program through the oracle:

```bash
ICONT=/home/claude/icon-master/bin/icont
ICONX=/home/claude/icon-master/bin/iconx
cp progs/hello.icn /tmp/t.icn
cd /tmp && $ICONT -s t.icn && $ICONX t
```

`procs/` files are library modules — they need to be linked with a
program that calls them (`icont` `-u` flag or `$include`).

Graphics programs (`gprogs/`, `gprocs/`) require X11 and will not run
in headless CI environments.

## License

Icon is distributed under a license permitting free use and redistribution
with attribution. See `icon-master/README` in the distribution for full terms.
