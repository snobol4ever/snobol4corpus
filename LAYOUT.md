# snobol4corpus Layout

All SNOBOL4 source programs live here. One canonical home per file.
Engine repos do not keep their own copies.

```
snobol4corpus/
│
├── crosscheck/          ← PRIMARY harness feed — self-contained, deterministic, fast
│   ├── hello/           ← smoke tests: hello world, empty string, multi-line output
│   ├── arith/           ← arithmetic, assignment, integer/real ops
│   ├── strings/         ← concat, SIZE, TRIM, REPLACE, string ops
│   ├── patterns/        ← ANY SPAN BREAK LEN ARB BAL, pattern matching
│   ├── capture/         ← . and $ capture, conditional assignment
│   ├── control/         ← goto, :S :F, loops, label resolution
│   ├── functions/       ← DEFINE, CALL, RETURN, FRETURN, recursion
│   ├── arrays/          ← ARRAY, TABLE, DATA types
│   └── code/            ← CODE(), EVAL(), dynamic execution
│
├── benchmarks/          ← performance programs (timing comparisons)
│
├── programs/            ← real-world programs (may need I/O, -INCLUDE, input)
│   ├── beauty/          ← beauty.sno — merged beautifier + driver
│   ├── lon/             ← Lon's collection
│   │   ├── sno/         ← general programs
│   │   └── rinky/       ← rinky/social media programs
│   ├── dotnet/          ← programs sourced from snobol4dotnet tests
│   ├── gimpel/          ← Gimpel book examples (to populate)
│   └── icon/            ← ICON language translation demos
│
├── generated/           ← pinned worm outputs that passed crosscheck
│                           (starts empty, grows via run-worm-batch)
│
├── inc/                 ← shared .inc include files
│
└── run/                 ← oracle runner scripts
    ├── run-csnobol4.sh
    ├── run-spitbol.sh
    └── sno.mk
```

## Rules for crosscheck/

Programs in `crosscheck/` MUST be:
- Self-contained — no `-INCLUDE`, no external file I/O
- Deterministic — no `DATE()`, `TIME()`, random numbers
- Fast — complete in < 1 second on any engine
- Named for what they test

## Rules for generated/

Programs land here via `run-worm-batch` when they pass crosscheck.
They are regression guards — do not edit by hand.
