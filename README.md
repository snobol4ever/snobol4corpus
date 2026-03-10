# SNOBOL4-corpus

Shared SNOBOL4 programs, libraries, grammars, and benchmarks for the
[SNOBOL4-plus](https://github.com/SNOBOL4-plus) organization.

Used as a Git submodule in `SNOBOL4-jvm` and `SNOBOL4-dotnet`.

---

## Layout

```
benchmarks/     canonical benchmark programs (.sno and .spt)
                loaded by runners in SNOBOL4-jvm and SNOBOL4-dotnet
programs/
  ebnf/         EBNF grammar programs
  inc/           include files (TZ, ebnf, etc.)
  rinky/         rinky programs
  sno/           general SNOBOL4 programs
  test/          test programs
```

---

## As a Submodule

```bash
# In SNOBOL4-jvm  (path: corpus/lon)
# In SNOBOL4-dotnet  (path: corpus)
git submodule update --init --recursive
```

---

## Benchmarks

See [benchmarks/README.md](benchmarks/README.md) for the full program catalog
and instructions for adding new benchmarks.
