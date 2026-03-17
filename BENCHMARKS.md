# snobol4ever Cross-Engine Benchmark Results

**Date**: 2026-03-10  
**Host**: Linux x86-64, Java 21.0.10, .NET 10.0.103  
**Engines**:
- SPITBOL v4.0f — compiled native x64 (`spitbol -b -`)
- CSNOBOL4 2.3.3 — compiled C (`snobol4 -`)
- snobol4dotnet 0.1 — C#/.NET 10 threaded executor
- snobol4jvm 0.2.0 — Clojure/JVM uberjar

**Methodology**: Each engine runs each benchmark at a count suited to its
own speed, timed by `TIME()` calls inside the program (startup excluded).
Results are normalized to **ms per million iterations** for comparison.
All engines run on the same machine so machine power cancels out.

**Startup overhead** (excluded from all timings):
- SPITBOL: ~5ms
- CSNOBOL4: ~10ms
- snobol4dotnet: ~1-2s (.NET JIT)
- snobol4jvm: ~8-10s (JVM + dynamic classload)

---

## Results — ms per million iterations

| Benchmark | SPITBOL | CSNOBOL4 | DOTNET | JVM | DOTNET/SPITBOL | JVM/SPITBOL |
|-----------|--------:|---------:|-------:|----:|:--------------:|:-----------:|
| arith_loop | 20 | 170 | 12,594 | 9,624 | 630× | 481× |
| eval_dynamic | 370 | 1,310 | 355,000 | 4,070,000 | 959× | 11,000× |
| eval_fixed | 280 | 760 | 425,000 | 2,900,000 | 1,518× | 10,357× |
| op_dispatch | 70 | 400 | 39,838 | 25,502 | 569× | 364× |
| string_concat | 2,000 | 6,000 | 14,760 | 80,200 | 7× | 40× |
| string_manip | 78 | 348 | 40,400 | 117,000 | 518× | 1,500× |
| string_pattern | 1,080 | 4,140 | 752,000 | — | 696× | FAIL |
| table_access | 50 | 492 | 219,800 | 362,400 | 4,396× | 7,248× |
| var_access | 91 | 407 | 40,440 | 50,440 | 444× | 554× |
| fibonacci | — | — | 43,003† | — | — | FAIL |
| pattern_bt | 480 | 580 | 20,079‡ | FAIL | — | FAIL |

*† fibonacci: FIB(30), not per-million-iters — single call timing*  
*‡ pattern_bt: 500K iters total*

---

## Raw Timing Data

| Benchmark | SP count | SP ms | CS count | CS ms | DN count | DN ms | JVM count | JVM ms |
|-----------|:--------:|------:|:--------:|------:|:--------:|------:|:---------:|-------:|
| arith_loop | 1M | 20 | 1M | 170 | 1M | 12,594 | 1M | 9,624 |
| eval_dynamic | 1M | 370 | 1M | 1,310 | 200 | 71 | 200 | 814 |
| eval_fixed | 1M | 280 | 1M | 760 | 200 | 85 | 200 | 580 |
| op_dispatch | 1M | 70 | 1M | 400 | 1M | 39,838 | 1M | 25,502 |
| string_concat | 100K | 200 | 100K | 600 | 10K | 1,476 | 10K | 802 |
| string_manip | 5M | 390 | 5M | 1,740 | 5K | 202 | 5K | 585 |
| string_pattern | 500K | 540 | 500K | 2,070 | 500 | 376 | 500 | 510* |
| table_access | 5K cyc | 250 | 5K cyc | 2,460 | 50 cyc | 1,099 | 50 cyc | 1,812 |
| var_access | 10M | 910 | 10M | 4,070 | 50K | 2,022 | 50K | 2,522 |
| fibonacci | FIB(30) | <1 | FIB(30) | <1 | FIB(30) | 43,003 | — | FAIL |
| pattern_bt | 500K | 480 | 500K | 580 | 500K | 20,079 | 500K | FAIL† |

*\* string_pattern JVM produces empty result — partial pattern failure*  
*† pattern_bt JVM returns result=0 instead of 500000 — pattern match failing*

---

## Failures

| Benchmark | DOTNET | JVM | Notes |
|-----------|:------:|:---:|-------|
| fibonacci | ✓ | FAIL | JVM silent failure — DEFINE recursion in vm/run-program! |
| func_call | ✓ | FAIL | JVM silent failure — DEFINE |
| func_call_overhead | ✓ | FAIL | JVM silent failure — DEFINE |
| mixed_workload | ✓ | FAIL | JVM silent failure — DEFINE + recursion |
| roman | ✓ | FAIL | JVM silent failure — DEFINE recursion |
| pattern_bt | ✓ | FAIL | JVM result=0, should be 500000 |
| string_pattern | ✓ | partial | JVM result empty string |

DOTNET handles all benchmarks correctly. JVM fails on all DEFINE-based benchmarks
and has pattern match issues in the uberjar `vm/run-program!` entry point.

---

## Notes

- SPITBOL `systm.c` patched to return milliseconds (default is nanoseconds).
- CSNOBOL4 `mstime.c` already returns milliseconds, no patch needed.
- DOTNET `_timerExecute` started before `ExecuteLoop()` in threaded path (Builder.cs fix).
- `indirect_dispatch.sno` excluded — SPITBOL error 022 on `$FN()` indirect call syntax.
- EVAL benchmarks show very high interpreter overhead in both DOTNET and JVM vs SPITBOL.
  Sprint 23E (JVM inline EVAL!) targets this bottleneck.
