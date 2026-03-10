# SNOBOL4-corpus / benchmarks

Canonical benchmark programs for all SNOBOL4-plus implementations.

Each `.sno` file is a self-contained SNOBOL4 program that writes its result
to OUTPUT. The `.spt` files are SPITBOL-dialect programs (use `-TITLE` and
`./*` preprocessor directives) from the original SPITBOL test suite.

Each implementation repo (`SNOBOL4-jvm`, `SNOBOL4-dotnet`) points to this
corpus as a Git submodule and provides its own benchmark runner that loads
programs from this folder.

---

## Benchmark Programs

| File | Bottleneck | Key operations |
|------|-----------|----------------|
| `roman.sno` | Recursive function dispatch | DEFINE, RPOS, LEN, BREAK, REPLACE, GOTO |
| `fibonacci.sno` | Deep recursion | FIB(18) ≈ 10,945 recursive calls |
| `arith_loop.sno` | Interpreter dispatch | Tight counter loop, no I/O or patterns |
| `string_pattern.sno` | Pattern matching | BREAK, CSV parsing, 200 iters |
| `string_manip.sno` | String function throughput | REPLACE, SIZE, SUBSTR, 500 iters |
| `var_access.sno` | Identifier lookup | 5 vars, read/write in tight loop, 2000 iters |
| `op_dispatch.sno` | Arithmetic operators | +, -, *, /, GE in loop |
| `pattern_bt.sno` | Pattern backtracking | Alternation of 4 choices + SPAN, 500 iters |
| `table_access.sno` | TABLE ops | 500-entry TABLE fill + sum |
| `func_call_overhead.sno` | Call/return overhead | Trivial INC(), 3000 calls |
| `mixed_workload.sno` | Combined | Pattern parse + TABLE + recursion, 200 iters |
| `eval_fixed.sno` | EVAL() compile cost | Fixed expression, 200 iters |
| `eval_dynamic.sno` | EVAL() with no reuse | Dynamic expression, 200 iters |
| `indirect_dispatch.sno` | $ indirect dispatch | $FN(X), 500 iters — contrast with eval_fixed |
| `testpgms.spt` | SPITBOL diagnostics | Full SPITBOL test suite (4 phases) |
| `testpgms-test1.spt` … `test4.spt` | SPITBOL diagnostics | Individual phases |

---

## Adding New Benchmarks

1. Write a self-contained `.sno` file here.
2. Add a header comment: name, bottleneck, expected output.
3. The final statement must write to `OUTPUT` (not a variable) so all runners
   can verify correctness without knowing variable names.
4. Update this README table.
5. Add the program to the runner in each implementation repo.
