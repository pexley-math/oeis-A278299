# ~~Proof that a(20) = 108 and a(21) = 119~~

## WARNING: THESE PROOFS ARE INVALIDATED (22/03/2026)

**This document is kept for historical reference only. Do NOT cite these proofs.**

Three fatal flaws were identified by adversarial review (DeepSeek + verify_proofs.py):

1. **Duplicate edges allowed:** The claim I_I <= C(13,2) = 78 is wrong. The problem
   allows multiple edges between the same colour pair. 78 is a lower bound, not upper.
2. **Border accounting:** Tight cells on the interior-grid border have < 4 interior
   neighbours. The equation 2*I_I + I_N = 208 over-counts.
3. **Arithmetic error (a(21)):** Total interior edges needed = 142 (not 144).
   142 = 142 is not a contradiction.

a(20) <= 108 and a(21) <= 119 remain valid as UPPER BOUNDS (constructions verified).

---



## OEIS A278299

**Definition.** a(n) is the minimum number of cells in a polyomino admitting a proper n-coloring such that every pair of distinct colors is edge-adjacent.

**Equivalently.** a(n) = min |V(H)| over connected subgraphs H of the infinite square grid with achromatic number psi(H) >= n.

---

## Preliminaries

**Notation.** For a polyomino P with k cells:
- Internal edges E(P) = (4k - p)/2, where p is the perimeter
- Colour pairs required: C(n,2) = n(n-1)/2
- Slack = E(P) - C(n,2)

**Colour distribution.** With k cells and n colours, each colour appears floor(k/n) or ceil(k/n) times. If k = n*q + r, then r colours have (q+1) cells ("large") and (n-r) have q cells ("small").

**Degree classification.** In a polyomino:
- Degree-4 cells: interior (4 neighbours within the polyomino)
- Degree-3 cells: boundary non-corner (3 neighbours)
- Degree-2 cells: corner (2 neighbours)

**Interior grid.** For a rectangle of dimensions R x C, the interior cells (degree-4) form an (R-2) x (C-2) grid with:
- I = (R-2)(C-2) cells
- E_int = 2I - (R+C-4) edges
- B_int = 2(R+C-4) - 4 border cells (interior cells adjacent to boundary)

---

## Theorem 1: a(20) = 108

### Lower bound: a(20) > 107

**Step 1. Shape reduction.**
For k = 107, the minimum perimeter is 42 (achieved by rectangles with R+C=21). Maximum internal edges = (428-42)/2 = 193. Since C(20,2) = 190, shapes with perimeter > 42 have fewer edges and are even more constrained. We need only consider perimeter-42 shapes.

Enumeration yields 11 minimal-perimeter shapes in three families:
- Family (5,32,70): 3 shapes (9x12 minus 1 corner)
- Family (6,30,71): 7 shapes
- Family (7,28,72): 1 shape (10x11 minus 3 corners)

**Step 2. Boundary cell elimination.**
Colour distribution: 13 small (5 cells), 7 large (6 cells).

Each small colour needs degree sum >= 19 (to be adjacent to 19 others). With 5 cells at most degree 4, the maximum sum is 20. A cell of degree 3 reduces the sum by 1, degree 2 by 2. To achieve sum >= 19, a small colour can have at most one degree-3 cell and no degree-2 cells.

Therefore small colours contribute exactly (13-a) boundary cells, where a is the number with degree sum 20 (all degree-4).

For the 6-cell colours, using the constraint equations (sum of excesses = total slack), the boundary cell contribution is forced to be (24+a).

Total boundary cells = (13-a) + (24+a) = 37.

- Family (5,32,70): boundary = 37. **Consistent.**
- Family (6,30,71): boundary = 36. **36 != 37. Eliminated.**
- Family (7,28,72): boundary = 35. **35 != 37. Eliminated.**

This eliminates 8 of the 11 shapes.

**Step 3. Forcing a = 0.**
For the surviving family (5,32,70), interior = 70 cells. Small colours use (52+a) interior cells. Large colours use (18-a) interior cells plus 5 degree-2 and (19+a) degree-3 = (24+a) boundary cells. Total large = (18-a) + (24+a) = 42 = 7*6. Consistent for all a.

However, the total degree-4 cells in non-tight colours = 18-a, and since all non-boundary non-tight cells must be interior, we get 18-a = 18, so a = 0.

**Step 4. Exact adjacency structure.**
With a = 0, all 13 small colours have degree sum 19. Each has 19 neighbour slots for 19 distinct colours -- zero waste. Each small colour is adjacent to every other colour exactly once.

- Small-small edges: C(13,2) = 78
- Small-large edges: 13 * 7 = 91

**Step 5. Interior edge contradiction.**
Interior grid: 7 x 10 = 70 cells, 123 edges.
Tight interior cells: 4 * 13 = 52. Total slots: 52 * 4 = 208.

Let I_I = tight-tight interior edges, I_N = tight-nontight interior edges.
- 2*I_I + I_N = 208 (each tight cell has 4 interior neighbours)
- I_I + I_N <= 123 (total interior edges)

Subtracting: I_I >= 208 - 123 = **85**.

But total tight-tight edges = C(13,2) = **78**.

Since 85 > 78, **contradiction**. No valid 20-colouring exists on 107 cells.

### Upper bound: a(20) <= 108
Construction: Simulated annealing found a valid 108-cell polyomino with proper 20-colouring where all 190 colour pairs are edge-adjacent. Solution verified independently by pure Python (proper colouring, connectivity, all pairs witnessed). **QED.**

---

## Theorem 2: a(21) = 119

### Lower bound: a(21) > 115 (edge count)
k=115: max_edges = (460-44)/2 = 208 < 210 = C(21,2). Free proof.

### Lower bound: a(21) > 116, > 117 (corrected border counting)

For k = 116 or 117, colour distribution forces small colours (size 5) to be all-interior (degree sum must be >= 20 = 5*4). The interior grid is 8x10 with 80 cells and 32 border cells. The 4 corner cells of the interior grid have **2 boundary neighbours** (not 1).

Let s_b = small cells on interior border, s_c = small cells on interior corners (0 <= s_c <= 4).

From small cell degree sum: 2*E_SS + E_SL_int = 4*small_interior - (s_b + s_c).

From large interior degree sum: 2*E_LL_int + E_SL_int + (32 - s_b) = 4*large_interior.

Combining with interior edge total (142): the equations give **88 + s_b = s_b + s_c + 84**, forcing **s_c = 4**.

For k=116 (10 small, 11 large): s_c=4 leads to geometric contradiction (E_LL = s_b - 9 must be non-negative, but large interior cells insufficient).

For k=117 (9 small, 12 large): s_c=4 leads to **108 + s_b = s_b + s_c + 104**, same contradiction.

### Lower bound: a(21) > 118 (interior edge sum)

For k = 118: 8 small (5 cells), 13 large (6 cells). Small interior = 40, large interior = 40. Interior grid 8x10 = 80 cells, 142 edges.

**Key forced equalities** (from degree sums):
- E_SS = C(8,2) = **28 exactly** (proven: if E_SS > 28, then E_SL < 104, violating pair coverage)
- E_SL_int + E_SL_bnd = **104 exactly** (each small-large pair appears at least once, and degree sum forces equality)
- E_LL_int from large interior degree sum

**Total interior edges**: E_SS + E_SL_int + E_LL_int.

From the degree equations, this sum equals **144** (regardless of how edges are distributed between interior and boundary).

But the 8x10 interior grid has only **142** edges.

**144 > 142. Contradiction.**

This holds for ALL perimeter-44 shapes (all have the same 8x10 interior grid). Non-minimal perimeter shapes have even fewer interior edges.

### Upper bound: a(21) <= 119
Construction: Simulated annealing found a valid 119-cell polyomino with proper 21-colouring where all 210 colour pairs are edge-adjacent. Solution verified independently by pure Python (proper colouring, connectivity, all 210 pairs witnessed). **QED.**

---

## Summary of new results

| n | a(n) | Method | Correction |
|---|------|--------|------------|
| 12 | 40 | Edge bound tight | 0 |
| 13 | 46 | CP-SAT UNSAT + construction | 0 |
| 14 | 56 | Contact bound tight | 0 |
| 15 | 61 | Edge bound tight | 0 |
| 16 | 69 | Edge bound tight | 0 |
| 17 | 77 | CP-SAT UNSAT + construction | 0 |
| 18 | 90 | Contact bound tight | 0 |
| 19 | 97 | CP-SAT UNSAT (zero-slack) | +1 |
| 20 | 108 | I_I interior edge (85 > 78) | +2 |
| 21 | 119 | Interior edge sum (144 > 142) | +3 |

The formula floor((n^2+n+5)/4) is tight for n <= 18 (except n=5,9 where correction = +1) but fails with growing corrections at n = 19 (+1), n = 20 (+2), n = 21 (+3).

The problem is equivalent to finding the minimum connected subgraph H of the integer lattice with achromatic number psi(H) >= n.

## References

- Peter Kagey, "My Favorite Sequences: A278299", 2021
- Harary, Hedetniemi, "The achromatic number of a graph", J. Combin. Theory, 1970
- Computational verification: verify_a20_proof.py (pure Python, no solver)
- DeepSeek consultations: deepseek-20260321-{02,03,05,10,11,13}.txt
