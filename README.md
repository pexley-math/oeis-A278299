# OEIS A278299 -- Smallest Complete Polyomino Coloring

**Sequence:** [A278299](https://oeis.org/A278299)

a(n) = the smallest number of cells in a connected polyomino that can be colored with exactly n colors such that every pair of colors shares at least one edge.

Equivalently: a(n) = min |V(H)| over connected subgraphs H of the infinite grid with achromatic number >= n.

## Results

### Proved (7 new values)

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
| 12 | 40 | Edge bound: max_edges(39) = 65 < 66 = C(12,2) |
| 13 | 46 | Edge bound: max_edges(45) = 76 < 78 = C(13,2) |
| 14 | 56 | Contact bound: floor(55/14) = 3 cells, 3*4 = 12 < 13 |
| 15 | 61 | Edge bound: max_edges(60) = 104 < 105 = C(15,2) |
| 16 | 69 | Edge bound: max_edges(68) = 119 < 120 = C(16,2) |
| 17 | 77 | Edge bound: max_edges(76) = 134 < 136 = C(17,2) |
| 18 | 90 | Contact bound: floor(89/18) = 4 cells, 4*4 = 16 < 17 |

**Corrections:** a(13) = 46 (was listed as 47), a(17) = 77 (was listed as 78).

### Upper Bounds (not proved)

| n | a(n) <= | Status |
|---|---------|--------|
| 19 | 97 | Construction verified. Lower bound proof incomplete (perimeter-42 shapes untested). |
| 20 | 108 | Construction verified. Interior edge proof invalidated (duplicate edges, border accounting). |
| 21 | 119 | Construction verified. Interior edge sum proof invalidated (arithmetic error: 144 should be 142). |

All solutions verified by independent Python script: proper coloring, connected, all C(n,2) pairs witnessed.

## Running the Solver

**Requirements:** Python 3.8+, NumPy, OR-Tools

```bash
pip install numpy ortools
```

**Solve a single value:**
```bash
python code/solver-a278299.py --n 12 --verbose
```

**Verify all proofs:**
```bash
python code/verify_proofs.py
```

## Files

| File | Description |
|------|-------------|
| `code/solver-a278299.py` | Annealing solver for upper bounds |
| `code/verify_proofs.py` | Self-contained proof verification (no dependencies) |
| `proofs/proofs-all-values.md` | Formal proofs for a(12)-a(18) (a(19)-a(21) withdrawn) |
| `proofs/proof-a20-a21.md` | Interior edge proofs (INVALIDATED -- kept for reference) |
| `figures/a278299-figures.pdf` | Solution grids: a(12)-a(18) [PROVED], a(19)-a(21) [UPPER BOUND] |
| `data/a12-k40-solution.json` ... `a21-k119-solution.json` | Verified solutions (JSON) |
| `data/a13-proof-results.json` | CP-SAT UNSAT proof for a(13) (supplementary) |
| `data/a17-proof-results.json` | CP-SAT UNSAT proof for a(17) (supplementary) |
| `data/solver-results.json` | All terms a(1)-a(21) with metadata |
| `submission/oeis-draft.txt` | OEIS submission text |

## Prior Art

Known terms a(2) through a(11) were found by Alec Jones, Peter Kagey, and Ryan Lee.

## Hardware

- AMD Ryzen 5 5600 (6-core / 12-thread), 16 GB RAM
- Python 3 + OR-Tools CP-SAT + Cython/C extensions

## License

CC-BY-4.0. See [LICENSE](LICENSE).

## Author

Peter Exley, March 2026
