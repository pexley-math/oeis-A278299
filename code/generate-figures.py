"""
Generate Typst visual figures for A278299 complete polyomino colorings.
Each color index gets a distinct hue with letter label.
Uses standard 16-color palette (shared across all coloring projects)
plus one extra for n=17.
Reads solver-results.json, outputs a278299-figures.typ.
Shows a(12)-a(17): our upper bounds only.
"""

import json
import os

CELL_MM = 7

# Standard palette shared across ALL coloring projects (polyhex, polyiamond, etc.)
# Use first N colors for N-color solutions.
# (fill_hex, text_color_for_contrast)
PALETTE = [
    ("#E74C3C", "white"),   # A - Red
    ("#2980B9", "white"),   # B - Blue
    ("#27AE60", "white"),   # C - Green
    ("#F1C40F", "black"),   # D - Gold
    ("#8E44AD", "white"),   # E - Purple
    ("#E67E22", "white"),   # F - Orange
    ("#16A085", "white"),   # G - Teal
    ("#E91E63", "white"),   # H - Pink
    ("#795548", "white"),   # I - Brown
    ("#607D8B", "white"),   # J - Blue-Gray
    ("#689F38", "white"),   # K - Lime
    ("#1A237E", "white"),   # L - Navy
    ("#00BCD4", "black"),   # M - Cyan
    ("#B71C1C", "white"),   # N - Crimson
    ("#FF8A65", "black"),   # O - Peach
    ("#AD1457", "white"),   # P - Magenta
    ("#BF8C00", "white"),   # Q - Dark Gold (17th color for n=17)
]

LABELS = "ABCDEFGHIJKLMNOPQ"


def color_legend_typst(num_colors):
    """Generate Typst color legend block for num_colors colors."""
    lines = []
    lines.append('#v(0.3em)')
    lines.append('#align(center)[')
    lines.append('#text(size: 9pt, weight: "bold")[Color Legend]')
    lines.append('#v(0.2em)')
    cols = min(num_colors, 9)
    lines.append(f'#grid(columns: {cols}, column-gutter: 8pt, row-gutter: 4pt,')
    for i in range(num_colors):
        fill, tc = PALETTE[i]
        label = LABELS[i]
        lines.append(
            f'  box(inset: 1pt)[#rect(width: 10pt, height: 10pt, '
            f'fill: rgb("{fill}"), stroke: 0.3pt + black)'
            f'[#align(center + horizon)[#text(size: 6pt, '
            f'fill: {tc}, weight: "bold")[{label}]]] '
            f'#text(size: 7pt)[{i + 1}]],'
        )
    lines.append(')')
    lines.append(']')
    return '\n'.join(lines)


def main():
    base = os.path.dirname(os.path.abspath(__file__))
    json_path = os.path.join(base, "..", "research", "solver-results.json")
    out_path = os.path.join(base, "..", "submission", "a278299-figures.typ")

    with open(json_path) as f:
        data = json.load(f)

    parts = []

    parts.append("""#set page(
  paper: "a4",
  margin: (top: 2cm, bottom: 2cm, left: 1.5cm, right: 1.5cm),
  header: context {
    if counter(page).get().first() > 1 [
      #align(center)[#text(size: 8pt, fill: luma(120))[A278299: Complete Polyomino Coloring -- Solution Grids]]
    ]
  },
  footer: context {
    let current = counter(page).get().first()
    let total = counter(page).final().first()
    align(center)[#text(size: 8pt, fill: luma(120))[Page #current of #total]]
  },
)
#set text(font: "New Computer Modern", size: 9pt)
""")

    parts.append("""#align(center)[
  #text(size: 16pt, weight: "bold")[A278299: Complete Polyomino Coloring]
  #v(0.3em)
  #text(size: 10pt)[Smallest connected polyomino colored with _n_ colors \\
  where every pair of colors shares at least one edge]
  #v(0.3em)
  #text(size: 10pt)[Upper Bounds: a(12) through a(17)]
  #v(0.2em)
  #text(size: 8pt, style: "italic")[Computed by Peter Exley, March 2026]
]
#v(0.5em)
#line(length: 100%, stroke: 0.5pt)
#v(0.5em)
""")

    max_colors = 0

    for n in range(12, 18):
        key = str(n)
        if key not in data:
            continue
        rec = data[key]
        coloring = rec.get("coloring")
        size = rec["size"]
        bb = rec["bounding_box"]
        pairs = n * (n - 1) // 2

        if not coloring:
            continue

        max_colors = max(max_colors, n)

        # Parse coloring to grid
        grid = {}
        for coord_str, color_idx in coloring.items():
            r, c = coord_str.split(",")
            grid[(int(r), int(c))] = color_idx

        min_r = min(r for r, c in grid)
        max_r = max(r for r, c in grid)
        min_c = min(c for r, c in grid)
        max_c = max(c for r, c in grid)
        rows = max_r - min_r + 1
        cols = max_c - min_c + 1

        # Normalize to 0-based
        grid_norm = {}
        for (r, c), v in grid.items():
            grid_norm[(r - min_r, c - min_c)] = v

        cell_lines = []
        for r in range(rows):
            for c in range(cols):
                if (r, c) in grid_norm:
                    color_idx = grid_norm[(r, c)]
                    fill, tc = PALETTE[color_idx % len(PALETTE)]
                    label = LABELS[color_idx % len(LABELS)]
                    cell_lines.append(
                        f'      table.cell(fill: rgb("{fill}"))'
                        f'[#align(center + horizon)'
                        f'[#text(size: 5pt, fill: {tc}, weight: "bold")[{label}]]]'
                    )
                else:
                    cell_lines.append(
                        '      table.cell(fill: white)[]'
                    )
        cells_str = ",\n".join(cell_lines)

        parts.append(f"""#block(breakable: false, width: 100%)[
#align(center)[
  #text(size: 11pt, weight: "bold")[a({n}) <= {size}]
  #h(0.5em)
  #text(size: 8pt, fill: rgb("#E67E22"), weight: "bold")[\\[UPPER BOUND\\]]
  #h(0.5em)
  #text(size: 8pt)[{bb[0]} X {bb[1]} bounding box, binomial({n},2) = {pairs} pairs]
]
#v(0.2em)
#align(center)[
  #table(
    columns: ({CELL_MM}mm,) * {cols},
    rows: ({CELL_MM}mm,) * {rows},
    inset: 0pt,
    stroke: 0.5pt + white,
{cells_str},
  )
]
]
#v(0.5em)
""")

    # Color legend at the end
    parts.append('#v(0.5em)')
    parts.append('#line(length: 100%, stroke: 0.5pt)')
    parts.append(color_legend_typst(max_colors))
    parts.append("")

    os.makedirs(os.path.dirname(out_path), exist_ok=True)
    with open(out_path, "w", encoding="utf-8") as f:
        f.write("\n".join(parts))

    print(f"Generated: {out_path}")
    print(f"Compile with: typst compile {out_path}")


if __name__ == "__main__":
    main()
