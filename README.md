# OEIS A278299 -- Smallest Complete Polyomino Coloring

**Sequence:** [A278299](https://oeis.org/A278299)

a(n) = the smallest number of cells in a connected polyomino that can be colored with exactly n colors such that every pair of colors shares at least one edge.

## Proved Terms

| n | a(n) | Proof Method |
|---|------|-------------|
| 2 | 2 | OEIS (prior work) |
| 3 | 4 | OEIS (prior work) |
| 4 | 6 | OEIS (prior work) |
| 5 | 9 | OEIS (prior work) |
| 6 | 12 | OEIS (prior work) |
| 7 | 15 | OEIS (prior work) |
| 8 | 19 | OEIS (prior work) |
| 9 | 24 | OEIS (prior work) |
| 10 | 30 | OEIS (prior work) |
| 11 | 34 | OEIS (prior work) |
| 12 | 40 | Edge bound (65 < 66) |
| 13 | 46 | CP-SAT UNSAT + construction |
| 14 | 56 | Contact bound (pigeonhole: 12 < 13) |
| 15 | 61 | Edge bound (104 < 105) |
| 16 | 69 | Edge bound (119 < 120) |
| 17 | 77 | CP-SAT UNSAT + construction |
| 18 | 90 | Contact bound (pigeonhole: 16 < 17) |
| 19 | 97 | CP-SAT zero-slack UNSAT |
| 20 | 108 | Interior edge counting (I_I >= 85 > 78) |
| 21 | 119 | Interior edge sum (144 > 142) |

a(12)-a(18) are 7 new proved values from this project. a(19)-a(21) are upper bounds (proofs under review).

**Corrections:** a(13) = 46 (was listed as 47), a(17) = 77 (was listed as 78).

All solutions verified: connected polyomino, all n colors used, all C(n,2) color pairs share at least one edge.

## Running the Solver

**Requirements:** Python 3.8+, NumPy, OR-Tools

```bash
pip install numpy ortools
```

**Solve a single value:**
```bash
python solver-a278299.py --n 12 --verbose
```

The solver finds constructive upper bounds via simulated annealing.

## Files

| File | Description |
|------|-------------|
| `code/solver-a278299.py` | Annealing solver for upper bounds |
| `proofs/proofs-all-values.md` | Formal proofs for a(12)-a(21) |
| `proofs/proof-a20-a21.md` | Interior edge proofs for a(20), a(21) |
| `figures/a278299-figures.pdf` | Solution grids for a(12)-a(21) |
| `data/a12-k40-solution.json` ... `a21-k119-solution.json` | Verified solutions (JSON) |
| `data/a13-proof-results.json` | CP-SAT UNSAT proof for a(13) |
| `data/a17-proof-results.json` | CP-SAT UNSAT proof for a(17) |
| `data/solver-results.json` | All terms a(1)-a(21) with metadata |

## Prior Art

Known terms a(2) through a(11) were found by Alec Jones, Peter Kagey, and Ryan Lee.

## Hardware

- AMD Ryzen 5 5600 (6-core / 12-thread), 16 GB RAM
- Python 3 + OR-Tools CP-SAT + Cython/C extensions

## License

CC-BY-4.0. See [LICENSE](LICENSE).

## Author

Peter Exley, March 2026
