"""
OEIS A278299 -- Smallest Complete Polyomino Coloring Solver

Computes the smallest connected polyomino colored with n colors such that
every pair of distinct colors shares at least one edge.

Sequence: a(2)=2, a(3)=4, a(4)=6, a(5)=9, a(6)=12, a(7)=15, a(8)=19,
          a(9)=24, a(10)=30, a(11)=34.
Upper bounds: a(12)<=40, a(13)<=47, a(14)<=56, a(15)<=61, a(16)<=69, a(17)<=78.

Method: Numba JIT-compiled simulated annealing with adaptive move selection
and fresh diverse starts. For each n, the solver searches across multiple
grid dimensions and random seeds to find the smallest valid polyomino.

The solver matches prior authors' DATA values for a(2) through a(11).
For n >= 12, the values are constructive upper bounds (not proved optimal).

Requirements: Python 3.8+, numpy, numba
Install:      pip install numpy numba

Usage:
    python solver-a278299.py                  # Run all n=2..17
    python solver-a278299.py --n 12           # Run single n
    python solver-a278299.py --n 5-11         # Run range
    python solver-a278299.py --verbose        # Detailed output
    python solver-a278299.py --log results.txt  # Log output to file
    python solver-a278299.py --json results.json  # Save solutions as JSON

Author: Peter Exley
License: CC-BY-4.0
"""

import sys
import math
import time
import os
import json
import argparse
import numpy as np
from numba import njit, int8, int16, int32, int64, float64
from multiprocessing import Pool

sys.stdout.reconfigure(line_buffering=True)

EMPTY = -1

# Known DATA values (proved optimal by exhaustive SAT search)
KNOWN_VALUES = {
    2: 2, 3: 4, 4: 6, 5: 9, 6: 12, 7: 15,
    8: 19, 9: 24, 10: 30, 11: 34,
}

# Best known upper bounds (found by this solver via simulated annealing)
UPPER_BOUNDS = {
    12: 40, 13: 47, 14: 56, 15: 61, 16: 69, 17: 78,
}


# ---------------------------------------------------------------------------
# Numba JIT-compiled core functions
# ---------------------------------------------------------------------------

@njit(cache=True)
def count_neighbors(grid, r, c, rows, cols):
    """Count how many occupied neighbors a cell has."""
    count = 0
    if r > 0 and grid[r - 1, c] != EMPTY:
        count += 1
    if r < rows - 1 and grid[r + 1, c] != EMPTY:
        count += 1
    if c > 0 and grid[r, c - 1] != EMPTY:
        count += 1
    if c < cols - 1 and grid[r, c + 1] != EMPTY:
        count += 1
    return count


@njit(cache=True)
def is_connected(grid, rows, cols, skip_r=-1, skip_c=-1):
    """Check if occupied cells form a connected component (optionally skipping one cell)."""
    start_r, start_c = -1, -1
    total = 0
    for r in range(rows):
        for c in range(cols):
            if grid[r, c] != EMPTY and not (r == skip_r and c == skip_c):
                total += 1
                if start_r == -1:
                    start_r = r
                    start_c = c

    if total <= 1:
        return True

    # BFS using fixed-size arrays
    stack_r = np.empty(total, dtype=np.int32)
    stack_c = np.empty(total, dtype=np.int32)
    visited = np.zeros((rows, cols), dtype=np.int8)

    stack_r[0] = start_r
    stack_c[0] = start_c
    visited[start_r, start_c] = 1
    sp = 1
    count = 1

    while sp > 0:
        sp -= 1
        cr = stack_r[sp]
        cc = stack_c[sp]
        for dr, dc in ((-1, 0), (1, 0), (0, -1), (0, 1)):
            nr = cr + dr
            nc = cc + dc
            if 0 <= nr < rows and 0 <= nc < cols:
                if grid[nr, nc] != EMPTY and visited[nr, nc] == 0:
                    if nr == skip_r and nc == skip_c:
                        continue
                    visited[nr, nc] = 1
                    stack_r[sp] = nr
                    stack_c[sp] = nc
                    sp += 1
                    count += 1

    return count == total


@njit(cache=True)
def compute_state(grid, rows, cols, n):
    """Compute full state: pair_count, color_count, same_adj, n_pairs."""
    pair_count = np.zeros((n, n), dtype=np.int16)
    color_count = np.zeros(n, dtype=np.int16)
    same_adj = 0

    for r in range(rows):
        for c in range(cols):
            col = grid[r, c]
            if col == EMPTY:
                continue
            color_count[col] += 1
            # Only check right and down to avoid double-counting
            for dr, dc in ((0, 1), (1, 0)):
                nr = r + dr
                nc = c + dc
                if 0 <= nr < rows and 0 <= nc < cols:
                    other = grid[nr, nc]
                    if other == EMPTY:
                        continue
                    if col == other:
                        same_adj += 1
                    else:
                        a = min(col, other)
                        b = max(col, other)
                        pair_count[a, b] += 1

    n_pairs = 0
    for a in range(n):
        for b in range(a + 1, n):
            if pair_count[a, b] > 0:
                n_pairs += 1

    return pair_count, color_count, same_adj, n_pairs


@njit(cache=True)
def count_cells(grid, rows, cols):
    """Count occupied cells."""
    count = 0
    for r in range(rows):
        for c in range(cols):
            if grid[r, c] != EMPTY:
                count += 1
    return count


@njit(cache=True)
def energy(n_missing, n_cells, n, n_colors, same_adj):
    """Compute energy. Lower is better."""
    color_penalty = max(0, n - n_colors) * 50
    return n_missing * 200 + n_cells + color_penalty + same_adj * 5


@njit(cache=True)
def get_boundary_cells(grid, rows, cols):
    """Get cells with fewer than 4 occupied neighbors."""
    result_r = np.empty(rows * cols, dtype=np.int32)
    result_c = np.empty(rows * cols, dtype=np.int32)
    count = 0
    for r in range(rows):
        for c in range(cols):
            if grid[r, c] != EMPTY:
                n_occ = count_neighbors(grid, r, c, rows, cols)
                if n_occ < 4:
                    result_r[count] = r
                    result_c[count] = c
                    count += 1
    return result_r[:count], result_c[:count]


@njit(cache=True)
def get_frontier_cells(grid, rows, cols):
    """Get empty cells adjacent to at least one occupied cell."""
    result_r = np.empty(rows * cols, dtype=np.int32)
    result_c = np.empty(rows * cols, dtype=np.int32)
    count = 0
    for r in range(rows):
        for c in range(cols):
            if grid[r, c] == EMPTY:
                has_occ = False
                for dr, dc in ((-1, 0), (1, 0), (0, -1), (0, 1)):
                    nr = r + dr
                    nc = c + dc
                    if 0 <= nr < rows and 0 <= nc < cols and grid[nr, nc] != EMPTY:
                        has_occ = True
                        break
                if has_occ:
                    result_r[count] = r
                    result_c[count] = c
                    count += 1
    return result_r[:count], result_c[:count]


@njit(cache=True)
def remove_cell_update(grid, pair_count, color_count, r, c, rows, cols, n):
    """Remove a cell and update state incrementally."""
    col = grid[r, c]
    delta_same = 0
    delta_pairs = 0

    for dr, dc in ((-1, 0), (1, 0), (0, -1), (0, 1)):
        nr = r + dr
        nc = c + dc
        if 0 <= nr < rows and 0 <= nc < cols:
            other = grid[nr, nc]
            if other == EMPTY:
                continue
            if col == other:
                delta_same -= 1
            else:
                a = min(col, other)
                b = max(col, other)
                old_val = pair_count[a, b]
                pair_count[a, b] = old_val - 1
                if old_val == 1:
                    delta_pairs -= 1

    color_count[col] -= 1
    grid[r, c] = EMPTY
    return col, delta_same, delta_pairs


@njit(cache=True)
def add_cell_update(grid, pair_count, color_count, r, c, col, rows, cols, n):
    """Add a cell and update state incrementally."""
    grid[r, c] = col
    color_count[col] += 1
    delta_same = 0
    delta_pairs = 0

    for dr, dc in ((-1, 0), (1, 0), (0, -1), (0, 1)):
        nr = r + dr
        nc = c + dc
        if 0 <= nr < rows and 0 <= nc < cols:
            other = grid[nr, nc]
            if other == EMPTY:
                continue
            if col == other:
                delta_same += 1
            else:
                a = min(col, other)
                b = max(col, other)
                old_val = pair_count[a, b]
                pair_count[a, b] = old_val + 1
                if old_val == 0:
                    delta_pairs += 1

    return delta_same, delta_pairs


@njit(cache=True)
def recolor_cell_update(grid, pair_count, color_count, r, c, new_col, rows, cols, n):
    """Recolor a cell and update state."""
    old_col = grid[r, c]
    if old_col == new_col:
        return old_col, 0, 0

    delta_same = 0
    delta_pairs = 0

    for dr, dc in ((-1, 0), (1, 0), (0, -1), (0, 1)):
        nr = r + dr
        nc = c + dc
        if 0 <= nr < rows and 0 <= nc < cols:
            nb_col = grid[nr, nc]
            if nb_col == EMPTY:
                continue
            # Remove old edge
            if old_col == nb_col:
                delta_same -= 1
            else:
                a = min(old_col, nb_col)
                b = max(old_col, nb_col)
                old_val = pair_count[a, b]
                pair_count[a, b] = old_val - 1
                if old_val == 1:
                    delta_pairs -= 1
            # Add new edge
            if new_col == nb_col:
                delta_same += 1
            else:
                a = min(new_col, nb_col)
                b = max(new_col, nb_col)
                old_val = pair_count[a, b]
                pair_count[a, b] = old_val + 1
                if old_val == 0:
                    delta_pairs += 1

    color_count[old_col] -= 1
    color_count[new_col] += 1
    grid[r, c] = new_col
    return old_col, delta_same, delta_pairs


@njit(cache=True)
def count_colors_used(color_count, n):
    """Count how many colors have at least one cell."""
    count = 0
    for i in range(n):
        if color_count[i] > 0:
            count += 1
    return count


@njit(cache=True)
def anneal_core(grid, rows, cols, n, target, steps, T_start, T_end,
                growth_headroom, seed_val):
    """Core annealing loop -- fully JIT-compiled.

    Six move types with adaptive weights (self-learning):
      0: remove -- remove a boundary cell to shrink the polyomino
      1: coordinated -- recolor a neighbor then remove a boundary cell
      2: recolor -- change a random cell's color
      3: swap -- swap two cells' colors
      4: relocate -- remove one boundary cell, add one frontier cell
      5: add -- add a frontier cell to grow the polyomino

    Returns (best_size, best_grid, steps_to_best).
    """
    np.random.seed(seed_val)
    total_target = n * (n - 1) // 2

    pair_count, color_count, same_adj, n_pairs = compute_state(grid, rows, cols, n)
    n_cells = count_cells(grid, rows, cols)
    n_colors = count_colors_used(color_count, n)
    n_missing = total_target - n_pairs

    best_size = 9999
    best_grid = grid.copy()
    steps_to_best = 0

    if n_missing == 0 and n_colors == n and is_connected(grid, rows, cols):
        best_size = n_cells
        best_grid = grid.copy()

    # Adaptive move weights -- self-learning
    move_weights = np.array([25.0, 20.0, 20.0, 15.0, 12.0, 8.0])
    move_successes = np.zeros(6, dtype=np.float64)
    move_attempts = np.zeros(6, dtype=np.float64)
    adapt_window = 50000

    for step in range(steps):
        T = T_start * (T_end / T_start) ** (step / steps)

        # Adaptive weight update every adapt_window steps
        if step > 0 and step % adapt_window == 0:
            for i in range(6):
                if move_attempts[i] > 10:
                    rate = move_successes[i] / move_attempts[i]
                    move_weights[i] = 0.7 * move_weights[i] + 0.3 * (rate * 600 + 1.0)
            total_w = 0.0
            for i in range(6):
                total_w += move_weights[i]
            for i in range(6):
                move_weights[i] = move_weights[i] / total_w * 100.0
            move_successes[:] = 0.0
            move_attempts[:] = 0.0

        # Select move type based on adaptive weights
        r_val = np.random.random() * 100.0
        cumulative = 0.0
        move_type = 5
        for i in range(6):
            cumulative += move_weights[i]
            if r_val < cumulative:
                move_type = i
                break

        old_energy = energy(n_missing, n_cells, n, n_colors, same_adj)
        did_move = False

        if move_type == 0 and n_cells > target:
            # REMOVE a boundary cell
            move_attempts[0] += 1
            bd_r, bd_c = get_boundary_cells(grid, rows, cols)
            if len(bd_r) == 0:
                continue
            idx = np.random.randint(0, len(bd_r))
            cr, cc = bd_r[idx], bd_c[idx]
            if not is_connected(grid, rows, cols, cr, cc):
                continue
            old_col, ds, dp = remove_cell_update(grid, pair_count, color_count,
                                                  cr, cc, rows, cols, n)
            same_adj += ds
            n_pairs += dp
            n_missing = total_target - n_pairs
            n_cells -= 1
            n_colors = count_colors_used(color_count, n)

            new_energy = energy(n_missing, n_cells, n, n_colors, same_adj)
            delta = new_energy - old_energy

            if delta <= 0 or np.random.random() < math.exp(-delta / max(T, 0.001)):
                did_move = True
            else:
                ds2, dp2 = add_cell_update(grid, pair_count, color_count,
                                            cr, cc, old_col, rows, cols, n)
                same_adj += ds2
                n_pairs += dp2
                n_missing = total_target - n_pairs
                n_cells += 1
                n_colors = count_colors_used(color_count, n)

        elif move_type == 1 and n_cells > target:
            # COORDINATED: recolor a neighbor, then remove
            move_attempts[1] += 1
            bd_r, bd_c = get_boundary_cells(grid, rows, cols)
            if len(bd_r) == 0:
                continue
            idx = np.random.randint(0, len(bd_r))
            cr, cc = bd_r[idx], bd_c[idx]
            if not is_connected(grid, rows, cols, cr, cc):
                continue

            nb_recolored = False
            nb_r, nb_c, nb_old_col = -1, -1, int8(-1)
            nb_ds, nb_dp = 0, 0
            for dr, dc in ((-1, 0), (1, 0), (0, -1), (0, 1)):
                nr2 = cr + dr
                nc2 = cc + dc
                if 0 <= nr2 < rows and 0 <= nc2 < cols and grid[nr2, nc2] != EMPTY:
                    if np.random.random() < 0.5:
                        new_col = np.random.randint(0, n)
                        nb_old_col_val, nb_ds, nb_dp = recolor_cell_update(
                            grid, pair_count, color_count, nr2, nc2, new_col, rows, cols, n)
                        nb_old_col = int8(nb_old_col_val)
                        nb_r, nb_c = nr2, nc2
                        same_adj += nb_ds
                        n_pairs += nb_dp
                        n_missing = total_target - n_pairs
                        n_colors = count_colors_used(color_count, n)
                        nb_recolored = True
                        break

            old_col, ds, dp = remove_cell_update(grid, pair_count, color_count,
                                                  cr, cc, rows, cols, n)
            same_adj += ds
            n_pairs += dp
            n_missing = total_target - n_pairs
            n_cells -= 1
            n_colors = count_colors_used(color_count, n)

            new_energy = energy(n_missing, n_cells, n, n_colors, same_adj)
            delta = new_energy - old_energy

            if delta <= 0 or np.random.random() < math.exp(-delta / max(T, 0.001)):
                did_move = True
            else:
                ds2, dp2 = add_cell_update(grid, pair_count, color_count,
                                            cr, cc, old_col, rows, cols, n)
                same_adj += ds2
                n_pairs += dp2
                n_cells += 1
                if nb_recolored:
                    _, ds3, dp3 = recolor_cell_update(
                        grid, pair_count, color_count, nb_r, nb_c, nb_old_col, rows, cols, n)
                    same_adj += ds3
                    n_pairs += dp3
                n_missing = total_target - n_pairs
                n_colors = count_colors_used(color_count, n)

        elif move_type == 2:
            # RECOLOR a random cell
            move_attempts[2] += 1
            cr, cc = -1, -1
            tries = 0
            while tries < 20:
                rr = np.random.randint(0, rows)
                rc = np.random.randint(0, cols)
                if grid[rr, rc] != EMPTY:
                    cr, cc = rr, rc
                    break
                tries += 1
            if cr == -1:
                continue

            new_col = np.random.randint(0, n)
            old_col, ds, dp = recolor_cell_update(grid, pair_count, color_count,
                                                    cr, cc, new_col, rows, cols, n)
            if old_col == new_col:
                continue
            same_adj += ds
            n_pairs += dp
            n_missing = total_target - n_pairs
            n_colors = count_colors_used(color_count, n)

            new_energy = energy(n_missing, n_cells, n, n_colors, same_adj)
            delta = new_energy - old_energy

            if delta <= 0 or np.random.random() < math.exp(-delta / max(T, 0.001)):
                did_move = True
            else:
                _, ds2, dp2 = recolor_cell_update(grid, pair_count, color_count,
                                                    cr, cc, old_col, rows, cols, n)
                same_adj += ds2
                n_pairs += dp2
                n_missing = total_target - n_pairs
                n_colors = count_colors_used(color_count, n)

        elif move_type == 3:
            # SWAP two cells' colors
            move_attempts[3] += 1
            cr1, cc1, cr2, cc2 = -1, -1, -1, -1
            tries = 0
            while tries < 30:
                rr = np.random.randint(0, rows)
                rc = np.random.randint(0, cols)
                if grid[rr, rc] != EMPTY:
                    if cr1 == -1:
                        cr1, cc1 = rr, rc
                    elif (rr != cr1 or rc != cc1):
                        cr2, cc2 = rr, rc
                        break
                tries += 1
            if cr2 == -1:
                continue

            col1 = grid[cr1, cc1]
            col2 = grid[cr2, cc2]
            if col1 == col2:
                continue

            _, ds1, dp1 = recolor_cell_update(grid, pair_count, color_count,
                                                cr1, cc1, col2, rows, cols, n)
            same_adj += ds1
            n_pairs += dp1
            _, ds2, dp2 = recolor_cell_update(grid, pair_count, color_count,
                                                cr2, cc2, col1, rows, cols, n)
            same_adj += ds2
            n_pairs += dp2
            n_missing = total_target - n_pairs
            n_colors = count_colors_used(color_count, n)

            new_energy = energy(n_missing, n_cells, n, n_colors, same_adj)
            delta = new_energy - old_energy

            if delta <= 0 or np.random.random() < math.exp(-delta / max(T, 0.001)):
                did_move = True
            else:
                _, ds3, dp3 = recolor_cell_update(grid, pair_count, color_count,
                                                    cr2, cc2, col2, rows, cols, n)
                same_adj += ds3
                n_pairs += dp3
                _, ds4, dp4 = recolor_cell_update(grid, pair_count, color_count,
                                                    cr1, cc1, col1, rows, cols, n)
                same_adj += ds4
                n_pairs += dp4
                n_missing = total_target - n_pairs
                n_colors = count_colors_used(color_count, n)

        elif move_type == 4:
            # RELOCATE: remove one boundary cell, add one frontier cell
            move_attempts[4] += 1
            bd_r, bd_c = get_boundary_cells(grid, rows, cols)
            if len(bd_r) == 0:
                continue
            idx = np.random.randint(0, len(bd_r))
            rm_r, rm_c = bd_r[idx], bd_c[idx]
            if not is_connected(grid, rows, cols, rm_r, rm_c):
                continue

            rm_col, ds1, dp1 = remove_cell_update(grid, pair_count, color_count,
                                                    rm_r, rm_c, rows, cols, n)
            same_adj += ds1
            n_pairs += dp1
            n_cells -= 1

            fr_r, fr_c = get_frontier_cells(grid, rows, cols)
            if len(fr_r) == 0:
                ds2, dp2 = add_cell_update(grid, pair_count, color_count,
                                            rm_r, rm_c, rm_col, rows, cols, n)
                same_adj += ds2
                n_pairs += dp2
                n_cells += 1
                n_missing = total_target - n_pairs
                n_colors = count_colors_used(color_count, n)
                continue

            fidx = np.random.randint(0, len(fr_r))
            add_r, add_c = fr_r[fidx], fr_c[fidx]

            # Pick best color for new cell
            best_col = 0
            best_score = -999
            for col in range(n):
                score = 0
                for dr, dc in ((-1, 0), (1, 0), (0, -1), (0, 1)):
                    nr2 = add_r + dr
                    nc2 = add_c + dc
                    if 0 <= nr2 < rows and 0 <= nc2 < cols:
                        nb_col = grid[nr2, nc2]
                        if nb_col == EMPTY:
                            continue
                        if nb_col == col:
                            score -= 3
                        else:
                            a = min(col, nb_col)
                            b = max(col, nb_col)
                            if pair_count[a, b] == 0:
                                score += 10
                if score > best_score:
                    best_score = score
                    best_col = col

            ds3, dp3 = add_cell_update(grid, pair_count, color_count,
                                        add_r, add_c, int8(best_col), rows, cols, n)
            same_adj += ds3
            n_pairs += dp3
            n_cells += 1
            n_missing = total_target - n_pairs
            n_colors = count_colors_used(color_count, n)

            new_energy = energy(n_missing, n_cells, n, n_colors, same_adj)
            delta = new_energy - old_energy

            if delta <= 0 or np.random.random() < math.exp(-delta / max(T, 0.001)):
                did_move = True
            else:
                _, ds4, dp4 = remove_cell_update(grid, pair_count, color_count,
                                                  add_r, add_c, rows, cols, n)
                same_adj += ds4
                n_pairs += dp4
                n_cells -= 1
                ds5, dp5 = add_cell_update(grid, pair_count, color_count,
                                            rm_r, rm_c, rm_col, rows, cols, n)
                same_adj += ds5
                n_pairs += dp5
                n_cells += 1
                n_missing = total_target - n_pairs
                n_colors = count_colors_used(color_count, n)

        else:
            # ADD a frontier cell
            move_attempts[5] += 1
            if n_cells >= target + growth_headroom:
                continue
            fr_r, fr_c = get_frontier_cells(grid, rows, cols)
            if len(fr_r) == 0:
                continue
            fidx = np.random.randint(0, len(fr_r))
            add_r, add_c = fr_r[fidx], fr_c[fidx]
            add_col = int8(np.random.randint(0, n))
            ds, dp = add_cell_update(grid, pair_count, color_count,
                                      add_r, add_c, add_col, rows, cols, n)
            same_adj += ds
            n_pairs += dp
            n_missing = total_target - n_pairs
            n_cells += 1
            n_colors = count_colors_used(color_count, n)

            new_energy = energy(n_missing, n_cells, n, n_colors, same_adj)
            delta = new_energy - old_energy

            if delta <= 0 or np.random.random() < math.exp(-delta / max(T, 0.001)):
                did_move = True
            else:
                _, ds2, dp2 = remove_cell_update(grid, pair_count, color_count,
                                                  add_r, add_c, rows, cols, n)
                same_adj += ds2
                n_pairs += dp2
                n_missing = total_target - n_pairs
                n_cells -= 1
                n_colors = count_colors_used(color_count, n)

        # Check for new best
        if did_move and n_missing == 0 and n_colors == n and n_cells < best_size:
            if is_connected(grid, rows, cols):
                best_size = n_cells
                best_grid = grid.copy()
                steps_to_best = step
                if best_size <= target:
                    return best_size, best_grid, steps_to_best

        # Track success for adaptive weights
        if did_move:
            new_e = energy(n_missing, n_cells, n, n_colors, same_adj)
            if new_e < old_energy:
                move_successes[move_type] += 1

    return best_size, best_grid, steps_to_best


@njit(cache=True)
def greedy_seed_numba(rows, cols, n, seed_val):
    """Create a greedy coloring of an R X C grid (JIT-compiled).

    Fills every cell with a color chosen to maximize new pair creation
    and minimize same-color adjacency. Provides a good starting point
    for the annealing phase.
    """
    np.random.seed(seed_val)
    grid = np.full((rows, cols), EMPTY, dtype=np.int8)

    n_cells = rows * cols
    order = np.arange(n_cells)
    # Fisher-Yates shuffle
    for i in range(n_cells - 1, 0, -1):
        j = np.random.randint(0, i + 1)
        order[i], order[j] = order[j], order[i]

    found_pairs = np.zeros((n, n), dtype=np.int8)

    for idx in range(n_cells):
        cell_idx = order[idx]
        r = cell_idx // cols
        c = cell_idx % cols

        best_color = 0
        best_score = -9999

        color_order = np.arange(n)
        for i in range(n - 1, 0, -1):
            j = np.random.randint(0, i + 1)
            color_order[i], color_order[j] = color_order[j], color_order[i]

        for ci in range(n):
            col = color_order[ci]
            new_pairs = 0
            same_adj = 0
            for dr, dc in ((-1, 0), (1, 0), (0, -1), (0, 1)):
                nr = r + dr
                nc = c + dc
                if 0 <= nr < rows and 0 <= nc < cols:
                    other = grid[nr, nc]
                    if other == EMPTY:
                        continue
                    if other == col:
                        same_adj += 1
                    else:
                        a = min(col, other)
                        b = max(col, other)
                        if found_pairs[a, b] == 0:
                            new_pairs += 1
            score = new_pairs * 10 - same_adj * 3
            if score > best_score:
                best_score = score
                best_color = col

        grid[r, c] = int8(best_color)
        for dr, dc in ((-1, 0), (1, 0), (0, -1), (0, 1)):
            nr = r + dr
            nc = c + dc
            if 0 <= nr < rows and 0 <= nc < cols:
                other = grid[nr, nc]
                if other != EMPTY and other != best_color:
                    a = min(best_color, other)
                    b = max(best_color, other)
                    found_pairs[a, b] = 1

    return grid


# ---------------------------------------------------------------------------
# Worker functions for multiprocessing
# ---------------------------------------------------------------------------

def worker_greedy_anneal(args):
    """Worker: fresh greedy seed on grid, then anneal (Numba-accelerated)."""
    seed, rows, cols, n, target, steps, T_start, T_end = args

    grid = greedy_seed_numba(rows, cols, n, seed)

    best_size, best_grid, steps_to_best = anneal_core(
        grid, rows, cols, n, target, steps, T_start, T_end,
        growth_headroom=12, seed_val=seed + 999)

    result = None
    if best_size < 9999:
        result = {}
        for r in range(rows):
            for c in range(cols):
                if best_grid[r, c] != EMPTY:
                    result[(r, c)] = int(best_grid[r, c])

    return seed, rows, cols, best_size, result, steps_to_best


# ---------------------------------------------------------------------------
# Solution verification
# ---------------------------------------------------------------------------

def verify_solution(coloring, n):
    """Verify a solution is valid: connected, all n colors, all pairs adjacent.

    Returns (is_valid, message).
    """
    if not coloring:
        return False, "No solution"

    colors_used = set(coloring.values())
    if len(colors_used) != n:
        return False, f"Only {len(colors_used)} colors (need {n})"

    # Connectivity check
    cells_set = set(coloring.keys())
    if len(cells_set) <= 1:
        conn = True
    else:
        start = next(iter(cells_set))
        visited = {start}
        queue = [start]
        while queue:
            cr, cc = queue.pop()
            for dr, dc in ((-1, 0), (1, 0), (0, -1), (0, 1)):
                nb = (cr + dr, cc + dc)
                if nb in cells_set and nb not in visited:
                    visited.add(nb)
                    queue.append(nb)
        conn = len(visited) == len(cells_set)
    if not conn:
        return False, "Not connected"

    # Pair completeness check
    pairs = set()
    for (r, c), col in coloring.items():
        for dr, dc in ((-1, 0), (1, 0), (0, -1), (0, 1)):
            nb = (r + dr, c + dc)
            if nb in coloring:
                other = coloring[nb]
                if col != other:
                    pairs.add((min(col, other), max(col, other)))
    total = n * (n - 1) // 2
    if len(pairs) < total:
        return False, f"Missing {total - len(pairs)} of {total} pairs"

    return True, "VALID"


# ---------------------------------------------------------------------------
# Grid selection and solver parameters per n
# ---------------------------------------------------------------------------

def get_solver_params(n):
    """Return (grids, seeds_per_grid, steps, T_start, T_end) for a given n.

    Grid selection uses deduplicated dimensions (R X C where R <= C,
    since R X C == C X R by rotation).
    """
    target = KNOWN_VALUES.get(n, UPPER_BOUNDS.get(n, None))
    if target is None:
        # No known target -- estimate from mod-4 pattern
        target = estimate_target(n)

    if n <= 4:
        # Trivial: small grids, few steps
        grids = [(2, max(2, target)), (max(2, target), 2),
                 (3, 3), (2, 4), (3, 4)]
        return target, grids, 5, 100000, 3.0, 0.01

    if n <= 6:
        # Small: moderate grids
        side = int(math.ceil(math.sqrt(target))) + 1
        grids = []
        for r in range(max(2, side - 2), side + 3):
            for c in range(r, side + 3):
                if r * c >= target and r * c <= target * 2:
                    grids.append((r, c))
        return target, grids, 10, 500000, 4.0, 0.005

    if n <= 9:
        # Medium: more grids and seeds
        side = int(math.ceil(math.sqrt(target))) + 1
        grids = []
        for r in range(max(3, side - 3), side + 4):
            for c in range(r, side + 4):
                if r * c >= target and r * c <= target * 2:
                    grids.append((r, c))
        return target, grids, 15, 2000000, 5.0, 0.003

    if n <= 11:
        # SAT-proved range: need reliable hits
        side = int(math.ceil(math.sqrt(target))) + 1
        grids = []
        for r in range(max(3, side - 3), side + 5):
            for c in range(r, side + 5):
                if r * c >= target and r * c <= target * 2.5:
                    grids.append((r, c))
        return target, grids, 20, 3000000, 5.0, 0.003

    # n >= 12: large search, many seeds
    side = int(math.ceil(math.sqrt(target))) + 1
    grids = []
    for r in range(max(5, side - 4), side + 6):
        for c in range(r, side + 6):
            if r * c >= target and r * c <= target * 1.8:
                grids.append((r, c))
    # Sort by total cells (tightest grids first)
    grids.sort(key=lambda rc: rc[0] * rc[1])
    seeds = 40
    steps = 10000000  # 10M
    return target, grids, seeds, steps, 5.0, 0.002


def estimate_target(n):
    """Estimate target for n > 17 using the mod-4 second-difference conjecture.

    The conjecture says: for each r in {2,3,4,5}, the subsequence
    a(r), a(r+4), a(r+8), ... has constant second difference = 8.
    """
    # Build from known values using the pattern
    all_values = dict(KNOWN_VALUES)
    all_values.update(UPPER_BOUNDS)
    max_known = max(all_values.keys())

    if n <= max_known:
        return all_values[n]

    # Extend using mod-4 pattern
    for nn in range(max_known + 1, n + 1):
        r = ((nn - 2) % 4) + 2  # residue class
        # Find last 3 values in this residue class
        prev = [all_values[k] for k in sorted(all_values.keys()) if (k - 2) % 4 == (nn - 2) % 4]
        if len(prev) >= 2:
            last_diff = prev[-1] - prev[-2]
            predicted = prev[-1] + last_diff + 8
            all_values[nn] = predicted

    return all_values.get(n, n * (n - 1) // 4)


# ---------------------------------------------------------------------------
# Display functions
# ---------------------------------------------------------------------------

def format_grid_art(coloring):
    """Format a solution as a simple letter grid."""
    if not coloring:
        return ""
    chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    min_r = min(r for r, _ in coloring)
    max_r = max(r for r, _ in coloring)
    min_c = min(c for _, c in coloring)
    max_c = max(c for _, c in coloring)
    lines = []
    for r in range(min_r, max_r + 1):
        row = ""
        for c in range(min_c, max_c + 1):
            if (r, c) in coloring:
                row += f" {chars[coloring[(r, c)]]}"
            else:
                row += " ."
        lines.append(f"    {row}")
    return "\n".join(lines)


def get_bounding_box(coloring):
    """Return (rows, cols) of the bounding box."""
    if not coloring:
        return 0, 0
    min_r = min(r for r, _ in coloring)
    max_r = max(r for r, _ in coloring)
    min_c = min(c for _, c in coloring)
    max_c = max(c for _, c in coloring)
    return max_r - min_r + 1, max_c - min_c + 1


# ---------------------------------------------------------------------------
# Main solver
# ---------------------------------------------------------------------------

def solve_n(n, verbose=False):
    """Solve for a single n. Returns (best_size, best_coloring, elapsed, seeds_info)."""
    total_pairs = n * (n - 1) // 2
    target, grids, seeds_per_grid, steps, T_start, T_end = get_solver_params(n)
    n_cores = min(os.cpu_count() or 4, 10)

    known = KNOWN_VALUES.get(n)
    upper = UPPER_BOUNDS.get(n)
    if known:
        expect_str = f"known value = {known}"
    elif upper:
        expect_str = f"best known upper bound <= {upper}"
    else:
        expect_str = f"estimated target = {target}"

    total_seeds = len(grids) * seeds_per_grid
    print(f"    {total_pairs} pairs needed, {expect_str}")
    print(f"    Grid sweep: {len(grids)} sizes x {seeds_per_grid} seeds, "
          f"{steps/1e6:.0f}M steps each ({n_cores} parallel workers)")

    global_best_size = 9999
    global_best = None
    t0 = time.time()

    for gi, (rows, cols_g) in enumerate(grids):
        grid_t0 = time.time()
        grid_best = 9999
        grid_valid = 0

        greedy_args = [
            (seed * 31337 + rows * 997 + cols_g * 127 + n * 7,
             rows, cols_g, n, target, steps, T_start, T_end)
            for seed in range(seeds_per_grid)
        ]

        with Pool(n_cores) as pool:
            for seed, r, c, size, result, stp in pool.imap_unordered(
                    worker_greedy_anneal, greedy_args):
                if result and size < 9999:
                    grid_valid += 1
                    if size < grid_best:
                        grid_best = size
                    if size < global_best_size:
                        global_best_size = size
                        global_best = dict(result)
                        if verbose:
                            from collections import Counter
                            dist = sorted(Counter(result.values()).values())
                            print(f"        [{r} X {c} s{seed}] NEW BEST: "
                                  f"{size} cells @ step {stp}, "
                                  f"dist={dist}")

        grid_elapsed = time.time() - grid_t0
        if grid_valid > 0:
            marker = ""
            if grid_best <= target:
                marker = "  <-- target matched"
            print(f"      {rows} X {cols_g}: "
                  f"{grid_valid}/{seeds_per_grid} seeds, "
                  f"best = {grid_best}{marker}  [{grid_elapsed:.1f}s]")
        else:
            print(f"      {rows} X {cols_g}: "
                  f"no valid coloring  [{grid_elapsed:.1f}s]")

    elapsed = time.time() - t0

    if global_best_size < 9999:
        print(f"      Minimum across all grids: k = {global_best_size}")
        print(f"      No grid found valid coloring with fewer than "
              f"{global_best_size} cells")

    seeds_info = (f"{len(grids)}/{len(grids)} grids, "
                  f"{total_seeds} seeds completed")
    return global_best_size, global_best, elapsed, seeds_info


def main():
    parser = argparse.ArgumentParser(
        description="OEIS A278299: Smallest complete polyomino coloring solver")
    parser.add_argument("--n", type=str, default="2-17",
                        help="Value(s) of n to solve: single (e.g. 12), "
                             "range (e.g. 5-11), or comma-separated (e.g. 5,10,15). "
                             "Default: 2-17")
    parser.add_argument("--verbose", action="store_true",
                        help="Show detailed progress for each grid and seed")
    parser.add_argument("--log", type=str, default=None,
                        help="Log all output to a file")
    parser.add_argument("--json", type=str, default=None,
                        help="Save solutions as JSON")
    args = parser.parse_args()

    # Parse n values
    n_values = parse_n_arg(args.n)

    # Set up logging
    if args.log:
        import io
        log_file = open(args.log, "w", encoding="utf-8")

        class Tee(io.TextIOBase):
            def __init__(self, *streams):
                self.streams = streams
            def write(self, data):
                for s in self.streams:
                    s.write(data)
                    s.flush()
                return len(data)
            def flush(self):
                for s in self.streams:
                    s.flush()

        sys.stdout = Tee(sys.__stdout__, log_file)

    n_cores = min(os.cpu_count() or 4, 10)

    import platform
    import datetime

    print("=" * 70)
    print("OEIS A278299 -- Smallest Complete Polyomino Coloring")
    print("Simulated annealing solver (Numba JIT)")
    print("=" * 70)
    print(f"  Software: Numba JIT, NumPy, Python {platform.python_version()}")
    print(f"  Hardware: {platform.processor() or platform.machine()}, "
          f"{platform.system()} {platform.release()}")
    print(f"  Date: {datetime.date.today().isoformat()}")
    print(f"  n values to solve: {n_values}")
    print(f"  CPU cores: {n_cores}")

    # JIT warmup
    print("\n  Compiling Numba JIT functions...")
    t_jit = time.time()
    _warmup_grid = greedy_seed_numba(5, 5, 5, 42)
    _ws, _wg, _wst = anneal_core(_warmup_grid, 5, 5, 5, 9, 1000, 5.0, 0.003, 5, 42)
    print(f"  JIT compiled in {time.time() - t_jit:.1f}s")

    # Reference table
    print("\n  Prior authors' DATA values (from OEIS):")
    print("    n:    ", "  ".join(f"{n:4d}" for n in range(2, 12)))
    print("    a(n): ", "  ".join(f"{KNOWN_VALUES[n]:4d}" for n in range(2, 12)))

    if any(n >= 12 for n in n_values):
        print("\n  Best known upper bounds (found by this solver):")
        ub_keys = sorted(UPPER_BOUNDS.keys())
        print("    n:    ", "  ".join(f"{n:4d}" for n in ub_keys))
        print("    a(n)<=", "  ".join(f"{UPPER_BOUNDS[n]:4d}" for n in ub_keys))

    # Solve each n
    results = {}
    t_total = time.time()

    for n in n_values:
        print(f"\n  n = {n}")
        print(f"  {'-' * 40}")
        best_size, best_coloring, elapsed, seeds_info = solve_n(n, verbose=args.verbose)

        # Verify
        valid, msg = verify_solution(best_coloring, n)

        # Determine status
        known = KNOWN_VALUES.get(n)
        if known:
            if best_size == known:
                status = "MATCHED (prior authors)"
            elif best_size < known:
                status = "BUG -- below known value!"
            else:
                status = "ABOVE known value"
        else:
            status = "FOUND (upper bound)"

        # Get bounding box
        bb_rows, bb_cols = get_bounding_box(best_coloring)

        print(f"    Result: a({n}) = {best_size}  [{elapsed:.1f}s]  {status}")
        print(f"    Verified: {msg}")
        print(f"    Bounding box: {bb_rows} X {bb_cols}")

        if best_coloring:
            from collections import Counter
            dist = sorted(Counter(best_coloring.values()).values())
            print(f"    Color distribution: {dist}")
            print(format_grid_art(best_coloring))

        results[n] = {
            "n": n,
            "size": best_size,
            "bounding_box": [bb_rows, bb_cols],
            "valid": valid,
            "status": status,
            "elapsed": round(elapsed, 1),
            "coloring": {f"{r},{c}": v for (r, c), v in best_coloring.items()}
                        if best_coloring else None,
        }

    # Summary table
    total_elapsed = time.time() - t_total
    print(f"\n{'=' * 70}")
    print("RESULTS SUMMARY")
    print(f"{'=' * 70}")
    print(f"  {'n':>3}  {'a(n)':>5}  {'Box':>9}  {'Pairs':>6}  {'Time':>8}  {'Status'}")
    print(f"  {'---':>3}  {'-----':>5}  {'---------':>9}  {'------':>6}  {'--------':>8}  {'------'}")

    for n in n_values:
        r = results[n]
        pairs = n * (n - 1) // 2
        box_str = f"{r['bounding_box'][0]} X {r['bounding_box'][1]}"
        time_str = f"{r['elapsed']:.1f}s"

        print(f"  {n:>3}  {r['size']:>5}  {box_str:>9}  {pairs:>6}  {time_str:>8}  {r['status']}")

    print(f"\n  Total time: {total_elapsed:.1f}s")

    # Prior authors' value match summary
    matched = [n for n in n_values if n in KNOWN_VALUES
               and results[n]["size"] == KNOWN_VALUES[n]]
    if matched:
        print(f"\n  Solver matches prior authors' DATA values for "
              f"a({min(matched)}) through a({max(matched)})")

    # Our upper bounds
    found = [n for n in n_values if n not in KNOWN_VALUES
             and results[n]["status"] == "FOUND (upper bound)"]
    if found:
        print(f"  Upper bounds a({min(found)}) through a({max(found)}) "
              f"found by this solver")

    unmatched = [n for n in n_values if n in KNOWN_VALUES
                 and results[n]["size"] != KNOWN_VALUES[n]]
    if unmatched:
        print(f"\n  WARNING: Solver did NOT match known values for: "
              f"{', '.join(f'a({n})' for n in unmatched)}")

    # JSON output
    if args.json:
        with open(args.json, "w", encoding="utf-8") as f:
            json.dump(results, f, indent=2)
        print(f"\n  Solutions saved to {args.json}")

    print()


def parse_n_arg(s):
    """Parse --n argument: '12', '5-11', '2,5,10', '2-5,12-17'."""
    values = []
    for part in s.split(","):
        part = part.strip()
        if "-" in part:
            lo, hi = part.split("-", 1)
            values.extend(range(int(lo), int(hi) + 1))
        else:
            values.append(int(part))
    return sorted(set(values))


if __name__ == "__main__":
    main()
