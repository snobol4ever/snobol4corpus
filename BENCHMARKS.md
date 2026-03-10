# SNOBOL4-plus Cross-Engine Benchmark Results

**Date**: 2026-03-10  
**Host**: Linux x86-64, Java 21.0.10  
**Engines**:
- SPITBOL v4.0f — compiled native x64 (`spitbol -b -`)
- CSNOBOL4 2.3.3 — compiled C (`snobol4 -`)
- SNOBOL4-jvm 0.2.0 — Clojure/JVM uberjar (`java -jar`)

**Methodology**: Each engine runs each benchmark at a count suited to its
own speed, timed by `TIME()` calls inside the program (startup excluded).
Results are normalized to **ms per million iterations** for comparison.
Engines run on the same machine so machine power cancels out.

**JVM startup** (cold, dynamic classload): ~8-10 seconds, excluded from all timings.

---

## Results

| Benchmark | What it measures | SPITBOL (ms/Miter) | CSNOBOL4 (ms/Miter) | JVM (ms/Miter) | JVM/SPITBOL |
|-----------|-----------------|-------------------:|--------------------:|---------------:|:-----------:|
| arith_loop | Pure arithmetic dispatch | 20 | 170 | 9,624 | **481×** |
| eval_dynamic | EVAL() dynamic expr | 370 | 1,310 | 4,070,000 | **11,000×** |
| eval_fixed | EVAL() fixed expr | 280 | 760 | 2,900,000 | **10,357×** |
| op_dispatch | Mixed +,-,*,/ operators | 70 | 400 | 25,502 | **364×** |
| string_concat | String append O(n²) | 2,000 | 6,000 | 80,200 | **40×** |
| string_manip | REPLACE + SIZE | 78 | 348 | 117,000 | **1,500×** |
| string_pattern | BREAK CSV parse | 1,080 | 4,140 | 1,020,000 | **944×** |
| table_access | TABLE write + read | 50 | 492 | 362,400 | **7,248×** |
| var_access | Identifier lookup | 91 | 407 | 50,440 | **554×** |

*Counts used: SPITBOL/CSNOBOL4 at high counts for resolution; JVM at lower counts to finish in reasonable time. All normalized to ms/Miter.*

---

## Raw Timing Data

| Benchmark | SPITBOL count | SPITBOL ms | CSNOBOL4 count | CSNOBOL4 ms | JVM count | JVM ms |
|-----------|:-------------:|:----------:|:--------------:|:-----------:|:---------:|:------:|
| arith_loop | 1,000,000 | 20 | 1,000,000 | 170 | 1,000,000 | 9,624 |
| eval_dynamic | 1,000,000 | 370 | 1,000,000 | 1,310 | 200 | 814 |
| eval_fixed | 1,000,000 | 280 | 1,000,000 | 760 | 200 | 580 |
| op_dispatch | 1,000,000 | 70 | 1,000,000 | 400 | 1,000,000 | 25,502 |
| string_concat | 100,000 | 200 | 100,000 | 600 | 10,000 | 802 |
| string_manip | 5,000,000 | 390 | 5,000,000 | 1,740 | 5,000 | 585 |
| string_pattern | 500,000 | 540 | 500,000 | 2,070 | 500 | 510 |
| table_access | 5,000 cycles | 250 | 5,000 cycles | 2,460 | 50 cycles | 1,812 |
| var_access | 10,000,000 | 910 | 10,000,000 | 4,070 | 50,000 | 2,522 |

---

## JVM Failures (silent — no output)

All involve `DEFINE`'d functions:

| Benchmark | Reason |
|-----------|--------|
| fibonacci | Recursive DEFINE (FIB calls FIB) |
| func_call | DEFINE'd INC(), 10M calls |
| func_call_overhead | DEFINE'd INC() |
| mixed_workload | DEFINE + recursion + TABLE |
| roman | Recursive DEFINE (ROMAN calls ROMAN) |
| pattern_bt | Pattern match failing — result: 0, should be 500,000 |

---

## Notes

- SPITBOL `systm.c` patched to return milliseconds (default is nanoseconds).
- CSNOBOL4 `mstime.c` already returns milliseconds.
- `indirect_dispatch.sno` excluded — SPITBOL error 022 on `$FN()` indirect call syntax.
- `string_pattern` JVM result is empty string — pattern matching partial failure.
- EVAL benchmarks show enormous JVM overhead (~10,000×) — EVAL! is the known bottleneck (Sprint 23E target).
