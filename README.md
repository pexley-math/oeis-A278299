# OEIS A278299 -- Smallest Complete Polyomino Coloring

Solver code, data, and figures for [OEIS A278299](https://oeis.org/A278299).

## The Problem

a(n) = the smallest number of cells in a connected polyomino that can be
colored with exactly n colors such that every pair of colors shares at
least one edge.

## Results

**Known terms (proved by prior authors):**

| n | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| a(n) | 2 | 4 | 6 | 9 | 12 | 15 | 19 | 24 | 30 | 34 |

**New proved terms (this work):**

| n | 12 | 13 | 14 | 15 | 16 | 17 | 18 |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| a(n) | 40 | 46 | 56 | 61 | 69 | 77 | 90 |
| Proof | Edge | Edge | Contact | Edge | Edge | Edge | Contact |

All 7 values proved by edge bound or contact bound (pigeonhole). All
solutions verified: connected polyomino, proper coloring, all C(n,2)
color pairs edge-adjacent.

## Method

Constructive upper bounds found by simulated annealing (Numba JIT). Lower
bounds proved by two methods:

- **Edge bound:** A polyomino with k cells has at most (4k - p_min)/2
  internal edges. If this is less than C(n,2), no valid coloring exists.
- **Contact bound (pigeonhole):** With k cells and n colors, some color
  has at most floor(k/n) cells. If 4*floor(k/n) < n-1, that color cannot
  be adjacent to all others.

## Running the Solver

**Requirements:** Python 3.8+, numpy, numba

```bash
pip install numpy numba

# Run all terms n=2..18
python code/solver-a278299.py

# Run specific values
python code/solver-a278299.py --n 12
python code/solver-a278299.py --n 12-18

# Save results as JSON with log file
python code/solver-a278299.py --json results.json --verbose --log run.txt
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

## Prior Art and Acknowledgments

The sequence A278299 was created by Peter Kagey (2016). Terms a(2) through
a(11) were proved by Alec Jones, Peter Kagey, and Ryan Lee. This work extends
the sequence with 7 new proved terms a(12) through a(18).

This work was inspired by the [OEIS](https://oeis.org/) and the community of
contributors who maintain it.

## Hardware

AMD Ryzen 5 5600 (6-core / 12-thread), 16 GB RAM.

## License

[CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/) -- Peter Exley, 2026.

This work is freely available. If you find it useful, a citation or acknowledgment
is appreciated but not required.

## Links

- **OEIS page:** https://oeis.org/A278299
