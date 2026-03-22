# OEIS A278299 -- Smallest Complete Polyomino Coloring

**Sequence:** [A278299](https://oeis.org/A278299)

a(n) = the smallest number of cells in a connected polyomino that can be colored with exactly n colors such that every pair of colors shares at least one edge.

## New Proved Terms

| n | a(n) | Proof Method |
|---|------|-------------|
| 12 | 40 | Edge bound: 65 < 66 |
| 13 | 46 | Edge bound: 76 < 78 |
| 14 | 56 | Contact bound: 12 < 13 |
| 15 | 61 | Edge bound: 104 < 105 |
| 16 | 69 | Edge bound: 119 < 120 |
| 17 | 77 | Edge bound: 134 < 136 |
| 18 | 90 | Contact bound: 16 < 17 |

All solutions verified: connected polyomino, proper coloring, all C(n,2) color pairs edge-adjacent.

## Method

Simulated annealing with Numba JIT compilation. For each n, the solver searches across multiple grid dimensions and random seeds to find the smallest valid polyomino. Lower bounds proved by edge bound (max internal edges < required pairs) or contact bound (pigeonhole on cells per color).

## Running the Solver

**Requirements:** Python 3.8+, numpy, numba

```bash
pip install numpy numba
```

```bash
# Run all terms n=2..18
python code/solver-a278299.py

# Run specific values
python code/solver-a278299.py --n 12
python code/solver-a278299.py --n 12-18

# Save results to JSON with log
python code/solver-a278299.py --json results.json --log run.txt --verbose
```

**Verify all proofs** (no dependencies required):

```bash
python code/verify_proofs.py
```

## Files

| File | Description |
|------|-------------|
| `code/solver-a278299.py` | Simulated annealing solver (Numba JIT) |
| `code/verify_proofs.py` | Self-contained proof verification (no dependencies) |
| `proofs/proofs-all-values.md` | Formal proofs for all 7 values |
| `figures/a278299-figures.pdf` | Colored solution grids |
| `figures/a278299-figures.typ` | Typst source for figures |
| `data/a12-k40-solution.json` | Verified 12-color solution (40 cells) |
| `data/a13-k46-solution.json` | Verified 13-color solution (46 cells) |
| `data/a14-k56-solution.json` | Verified 14-color solution (56 cells) |
| `data/a15-k61-solution.json` | Verified 15-color solution (61 cells) |
| `data/a16-k69-solution.json` | Verified 16-color solution (69 cells) |
| `data/a17-k77-solution.json` | Verified 17-color solution (77 cells) |
| `data/a18-k90-solution.json` | Verified 18-color solution (90 cells) |
| `data/solver-results.json` | Full solver run data |
| `submission/oeis-draft.txt` | OEIS submission text |

## Prior Art

Known terms a(2) through a(11) were found by Alec Jones, Peter Kagey, and Ryan Lee.

## Hardware

AMD Ryzen 5 5600 (6-core / 12-thread), 16 GB RAM.

## License

CC-BY-4.0. See [LICENSE](LICENSE).

## Author

Peter Exley, March 2026
