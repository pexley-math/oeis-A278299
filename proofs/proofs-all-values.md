# Formal Proofs: a(12) through a(18) for OEIS A278299

## OEIS A278299

**Definition.** a(n) is the minimum number of cells in a polyomino admitting a proper n-coloring such that every pair of distinct colors is edge-adjacent.

**Equivalently.** a(n) = min |V(H)| over connected subgraphs H of the infinite square grid with achromatic number psi(H) >= n.

---

## Proof Methods

Three types of impossibility argument are used:

**1. Edge bound.** A polyomino with k cells has internal edges E = (4k - p)/2, where p is the perimeter. For n colors, we need E >= C(n,2) = n(n-1)/2. Since p >= p_min(k) (the minimum perimeter for k cells), we get max E = (4k - p_min(k))/2. If this is less than C(n,2), no valid coloring exists.

**2. Contact bound (pigeonhole).** Each color i must be edge-adjacent to all n-1 other colors. A cell has at most 4 edge-neighbours, so a color with q cells has degree sum at most 4q. To achieve n-1 distinct adjacencies requires degree sum >= n-1, giving q >= ceil((n-1)/4). Therefore k >= n * ceil((n-1)/4). Equivalently: with k cells and n colors, at least one color has at most floor(k/n) cells. If floor(k/n) * 4 < n-1, that color cannot be adjacent to all others.

**3. Interior edge counting.** For larger n, neither bound alone suffices. We analyse the interior grid structure, counting how many interior edges are consumed by small-small, small-large, and large-large colour pairs, and show the total exceeds the available interior edges.

Each proof below establishes both directions: impossibility of k-1 (lower bound) and construction of k (upper bound).

---

## Theorem 1: a(12) = 40

### Lower bound: a(12) > 39 (edge bound)

For k = 39 cells: C(12,2) = 66 edges required.

Minimum perimeter for 39 cells: A 5x8 rectangle has 40 cells and perimeter 2(5+8) = 26. Removing one corner cell gives 39 cells with perimeter 26 (corner cells have 2 internal neighbours, so removing one does not change the perimeter). No configuration of 39 cells achieves perimeter less than 26, since any rectangle R x C with R*C >= 39 requires R + C >= 13 (verified: 6x7 = 42, R+C = 13, p = 26; and 5x8 = 40, R+C = 13, p = 26; while R+C = 12 gives at most 6x6 = 36 < 39).

Maximum internal edges for 39 cells: (4 * 39 - 26) / 2 = (156 - 26) / 2 = 65.

Since **65 < 66**, no polyomino with 39 cells has enough internal edges for 12 colors. **QED** (lower bound).

### Upper bound: a(12) <= 40

A 5x8 rectangular polyomino (40 cells) with a valid 12-coloring exists where all C(12,2) = 66 color pairs are edge-adjacent. Solution verified by independent Python script: proper coloring (no adjacent same-color), connected polyomino, all 66 pairs witnessed. See `data/a12-k40-solution.json`. **QED.**

---

## Theorem 2: a(13) = 46

### Lower bound: a(13) > 45 (edge bound)

For k = 45 cells: C(13,2) = 78 edges required.

Minimum perimeter for 45 cells: R + C = 14 (7x7 = 49, 6x8 = 48), p_min = 28. Maximum edges: (180 - 28)/2 = 76 < 78. This gives a(13) > 45 by edge bound alone.

**QED** (lower bound).

### Upper bound: a(13) <= 46

A 46-cell polyomino (7x7 with 3 corners removed) with a valid 13-coloring exists where all 78 color pairs are edge-adjacent. Solution verified independently. See `data/a13-k46-solution.json`. **QED.**

---

## Theorem 3: a(14) = 56

### Lower bound: a(14) > 55 (contact bound)

For k = 55 cells with n = 14 colors: by pigeonhole, at least one color is assigned at most floor(55/14) = 3 cells.

A color with 3 cells has degree sum at most 3 * 4 = 12. But it must be adjacent to all 13 other colors, requiring degree sum >= 13.

Since **12 < 13**, no valid 14-coloring exists on 55 cells. **QED** (lower bound).

### Upper bound: a(14) <= 56

With k = 56 = 14 * 4 cells, each color gets exactly 4 cells, and 4 * 4 = 16 >= 13 neighbour slots suffice. A valid 56-cell polyomino with proper 14-coloring exists where all C(14,2) = 91 pairs are edge-adjacent. Solution verified independently. See `data/a14-k56-solution.json`. **QED.**

---

## Theorem 4: a(15) = 61

### Lower bound: a(15) > 60 (edge bound)

For k = 60 cells: C(15,2) = 105 edges required.

Minimum perimeter for 60 cells: 6x10 = 60 cells exactly, perimeter 2(6+10) = 32. This is optimal since R + C = 16 is the smallest sum with R * C >= 60.

Maximum internal edges: (4 * 60 - 32) / 2 = (240 - 32) / 2 = 104.

Since **104 < 105**, no polyomino with 60 cells has enough internal edges for 15 colors. **QED** (lower bound).

### Upper bound: a(15) <= 61

A 61-cell polyomino with a valid 15-coloring exists where all 105 color pairs are edge-adjacent. Solution verified independently. See `data/a15-k61-solution.json`. **QED.**

---

## Theorem 5: a(16) = 69

### Lower bound: a(16) > 68 (edge bound)

For k = 68 cells: C(16,2) = 120 edges required.

Minimum perimeter for 68 cells: R + C = 17 gives R * C up to 72 (8x9). Since R + C = 16 gives at most 64 < 68, the minimum sum is R + C = 17, giving p_min = 34.

Maximum internal edges: (4 * 68 - 34) / 2 = (272 - 34) / 2 = 119.

Since **119 < 120**, no polyomino with 68 cells has enough internal edges for 16 colors. **QED** (lower bound).

### Upper bound: a(16) <= 69

A 69-cell polyomino with a valid 16-coloring exists where all 120 color pairs are edge-adjacent. Solution verified independently. See `data/a16-k69-solution.json`. **QED.**

---

## Theorem 6: a(17) = 77

### Lower bound: a(17) > 76 (edge bound)

For k = 76 cells: C(17,2) = 136 edges required.

Minimum perimeter for 76 cells: R + C = 18 gives 9x9 = 81, so p_min = 36. Maximum edges: (304 - 36) / 2 = 134 < 136. Edge bound gives a(17) > 76 directly.



### Upper bound: a(17) <= 77

A 77-cell polyomino with a valid 17-coloring exists where all 136 color pairs are edge-adjacent. Solution verified independently. See `data/a17-k77-solution.json`. **QED.**

---

## Theorem 7: a(18) = 90

### Lower bound: a(18) > 89 (contact bound)

For k = 89 cells with n = 18 colors: by pigeonhole, at least one color is assigned at most floor(89/18) = 4 cells.

A color with 4 cells has degree sum at most 4 * 4 = 16. But it must be adjacent to all 17 other colors, requiring degree sum >= 17.

Since **16 < 17**, no valid 18-coloring exists on 89 cells. **QED** (lower bound).

### Upper bound: a(18) <= 90

With k = 90 = 18 * 5 cells, each color gets exactly 5 cells, and 5 * 4 = 20 >= 17 neighbour slots suffice. A valid 90-cell polyomino with proper 18-coloring exists where all C(18,2) = 153 pairs are edge-adjacent. Solution verified independently. See `data/a18-k90-solution.json`. **QED.**

---

---
