# OEIS A278299 -- Smallest Complete Polyomino Coloring

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.18977760.svg)](https://doi.org/10.5281/zenodo.18977760)

Solver code, data, and figures for [OEIS A278299](https://oeis.org/A278299).

## The Problem

a(n) = the smallest number of cells in a connected polyomino that can be
colored with exactly n colors such that every pair of colors shares at least
one edge.

## Known Terms

| n | a(n) | Status |
|---|------|--------|
| 2 | 2 | OEIS DATA |
| 3 | 4 | OEIS DATA |
| 4 | 6 | OEIS DATA |
| 5 | 9 | OEIS DATA |
| 6 | 12 | OEIS DATA |
| 7 | 15 | OEIS DATA |
| 8 | 19 | OEIS DATA |
| 9 | 24 | OEIS DATA |
| 10 | 30 | OEIS DATA |
| 11 | 34 | OEIS DATA |

## Upper Bounds (this work)

| n | a(n) <= | Bounding box | Pairs |
|---|---------|-------------|-------|
| 12 | 40 | 6 X 7 | 66 |
| 13 | 47 | 9 X 7 | 78 |
| 14 | 56 | 9 X 10 | 91 |
| 15 | 61 | 9 X 8 | 105 |
| 16 | 69 | 10 X 8 | 120 |
| 17 | 78 | 9 X 11 | 136 |

All solutions verified: connected polyomino, all n colors used, all
binomial(n,2) color pairs share at least one edge.

## Method

Simulated annealing with Numba JIT compilation. Full grid sweep (all grid
sizes in profile) with all seeds run to completion. SAT (PySAT/CaDiCaL)
verifies known terms a(2)-a(11) exactly.

## Running the Solver

**Requirements:** Python 3.8+, NumPy, Numba

```bash
pip install numpy numba
```

**Usage:**

```bash
# Solve all terms (a(2) through a(17))
python code/solver-a278299.py --n 2-17 --verbose

# Solve a single value
python code/solver-a278299.py --n 12 --verbose

# Save results to JSON with log file
python code/solver-a278299.py --n 2-17 --json research/solver-results.json --log research/solver-run-log.txt
```

The solver matches the known OEIS DATA values for a(2) through a(11).
For n >= 12, the solver finds constructive upper bounds via simulated
annealing.

## Files

| File | Description |
|------|-------------|
| `code/solver-a278299.py` | Unified solver covering a(2) through a(17) |
| `code/generate-figures.py` | Figure generator (reads JSON, outputs Typst) |
| `research/solver-results.json` | Machine-readable results from a full solver run |
| `research/solver-run-log.txt` | Full solver output log |
| `submission/a278299-figures.pdf` | Solution figures for upper bounds a(12) through a(17) |

## Prior Art

Known terms a(2) through a(11) were found by Alec Jones, Peter Kagey,
and Ryan Lee.

## Hardware

- AMD Ryzen 5 5600 (6-core / 12-thread), 16 GB RAM
- Python 3 + NumPy + Numba

## License

[CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/) -- Peter Exley, 2026.

## Links

- **OEIS page:** https://oeis.org/A278299
- **Zenodo DOI:** [10.5281/zenodo.18977760](https://doi.org/10.5281/zenodo.18977760)
