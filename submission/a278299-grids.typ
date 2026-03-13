#set page(
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

#align(center)[
  #text(size: 16pt, weight: "bold")[A278299: Complete Polyomino Coloring]
  #v(0.3em)
  #text(size: 10pt)[Smallest connected polyomino colored with _n_ colors \
  where every pair of colors shares at least one edge]
  #v(0.3em)
  #text(size: 10pt)[Upper Bounds: a(12) through a(17)]
  #v(0.2em)
  #text(size: 8pt, style: "italic")[Computed by Peter Exley, March 2026]
]
#v(0.5em)
#line(length: 100%, stroke: 0.5pt)
#v(0.5em)

#block(breakable: false, width: 100%)[
#align(center)[
  #text(size: 11pt, weight: "bold")[a(12) <= 40]
  #h(0.5em)
  #text(size: 8pt, fill: rgb("#E67E22"), weight: "bold")[\[UPPER BOUND\]]
  #h(0.5em)
  #text(size: 8pt)[6 X 7 bounding box, binomial(12,2) = 66 pairs]
]
#v(0.2em)
#align(center)[
  #table(
    columns: (7mm,) * 7,
    rows: (7mm,) * 6,
    inset: 0pt,
    stroke: 0.5pt + white,
      table.cell(fill: white)[],
      table.cell(fill: rgb("#E91E63"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[H]]],
      table.cell(fill: rgb("#2980B9"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[B]]],
      table.cell(fill: rgb("#607D8B"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[J]]],
      table.cell(fill: rgb("#689F38"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[K]]],
      table.cell(fill: rgb("#E91E63"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[H]]],
      table.cell(fill: white)[],
      table.cell(fill: rgb("#8E44AD"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[E]]],
      table.cell(fill: rgb("#795548"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[I]]],
      table.cell(fill: rgb("#16A085"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[G]]],
      table.cell(fill: rgb("#27AE60"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[C]]],
      table.cell(fill: rgb("#2980B9"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[B]]],
      table.cell(fill: rgb("#1A237E"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[L]]],
      table.cell(fill: rgb("#F1C40F"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[D]]],
      table.cell(fill: rgb("#27AE60"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[C]]],
      table.cell(fill: rgb("#E74C3C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[A]]],
      table.cell(fill: rgb("#8E44AD"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[E]]],
      table.cell(fill: rgb("#689F38"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[K]]],
      table.cell(fill: rgb("#E74C3C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[A]]],
      table.cell(fill: rgb("#607D8B"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[J]]],
      table.cell(fill: rgb("#16A085"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[G]]],
      table.cell(fill: rgb("#E91E63"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[H]]],
      table.cell(fill: rgb("#F1C40F"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[D]]],
      table.cell(fill: rgb("#607D8B"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[J]]],
      table.cell(fill: rgb("#795548"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[I]]],
      table.cell(fill: rgb("#E67E22"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[F]]],
      table.cell(fill: rgb("#E91E63"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[H]]],
      table.cell(fill: rgb("#E74C3C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[A]]],
      table.cell(fill: rgb("#8E44AD"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[E]]],
      table.cell(fill: rgb("#2980B9"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[B]]],
      table.cell(fill: rgb("#E67E22"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[F]]],
      table.cell(fill: rgb("#1A237E"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[L]]],
      table.cell(fill: rgb("#689F38"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[K]]],
      table.cell(fill: rgb("#16A085"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[G]]],
      table.cell(fill: rgb("#1A237E"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[L]]],
      table.cell(fill: rgb("#F1C40F"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[D]]],
      table.cell(fill: rgb("#795548"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[I]]],
      table.cell(fill: rgb("#27AE60"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[C]]],
      table.cell(fill: rgb("#27AE60"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[C]]],
      table.cell(fill: rgb("#F1C40F"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[D]]],
      table.cell(fill: rgb("#E67E22"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[F]]],
      table.cell(fill: rgb("#8E44AD"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[E]]],
  )
]
]
#v(0.5em)

#block(breakable: false, width: 100%)[
#align(center)[
  #text(size: 11pt, weight: "bold")[a(13) <= 47]
  #h(0.5em)
  #text(size: 8pt, fill: rgb("#E67E22"), weight: "bold")[\[UPPER BOUND\]]
  #h(0.5em)
  #text(size: 8pt)[7 X 7 bounding box, binomial(13,2) = 78 pairs]
]
#v(0.2em)
#align(center)[
  #table(
    columns: (7mm,) * 7,
    rows: (7mm,) * 7,
    inset: 0pt,
    stroke: 0.5pt + white,
      table.cell(fill: rgb("#607D8B"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[J]]],
      table.cell(fill: rgb("#27AE60"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[C]]],
      table.cell(fill: rgb("#E74C3C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[A]]],
      table.cell(fill: rgb("#607D8B"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[J]]],
      table.cell(fill: rgb("#8E44AD"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[E]]],
      table.cell(fill: white)[],
      table.cell(fill: rgb("#E91E63"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[H]]],
      table.cell(fill: rgb("#1A237E"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[L]]],
      table.cell(fill: rgb("#00BCD4"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[M]]],
      table.cell(fill: rgb("#F1C40F"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[D]]],
      table.cell(fill: rgb("#689F38"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[K]]],
      table.cell(fill: rgb("#E91E63"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[H]]],
      table.cell(fill: rgb("#27AE60"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[C]]],
      table.cell(fill: rgb("#E67E22"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[F]]],
      table.cell(fill: rgb("#8E44AD"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[E]]],
      table.cell(fill: rgb("#16A085"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[G]]],
      table.cell(fill: rgb("#27AE60"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[C]]],
      table.cell(fill: rgb("#8E44AD"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[E]]],
      table.cell(fill: rgb("#00BCD4"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[M]]],
      table.cell(fill: rgb("#689F38"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[K]]],
      table.cell(fill: rgb("#E74C3C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[A]]],
      table.cell(fill: rgb("#2980B9"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[B]]],
      table.cell(fill: rgb("#E74C3C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[A]]],
      table.cell(fill: rgb("#795548"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[I]]],
      table.cell(fill: rgb("#F1C40F"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[D]]],
      table.cell(fill: rgb("#607D8B"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[J]]],
      table.cell(fill: rgb("#16A085"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[G]]],
      table.cell(fill: rgb("#E91E63"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[H]]],
      table.cell(fill: rgb("#E67E22"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[F]]],
      table.cell(fill: rgb("#00BCD4"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[M]]],
      table.cell(fill: rgb("#2980B9"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[B]]],
      table.cell(fill: rgb("#16A085"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[G]]],
      table.cell(fill: rgb("#E67E22"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[F]]],
      table.cell(fill: rgb("#795548"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[I]]],
      table.cell(fill: rgb("#607D8B"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[J]]],
      table.cell(fill: rgb("#8E44AD"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[E]]],
      table.cell(fill: rgb("#795548"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[I]]],
      table.cell(fill: rgb("#689F38"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[K]]],
      table.cell(fill: rgb("#1A237E"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[L]]],
      table.cell(fill: rgb("#F1C40F"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[D]]],
      table.cell(fill: rgb("#E91E63"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[H]]],
      table.cell(fill: rgb("#2980B9"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[B]]],
      table.cell(fill: rgb("#E74C3C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[A]]],
      table.cell(fill: rgb("#1A237E"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[L]]],
      table.cell(fill: rgb("#E67E22"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[F]]],
      table.cell(fill: white)[],
      table.cell(fill: rgb("#2980B9"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[B]]],
      table.cell(fill: rgb("#1A237E"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[L]]],
      table.cell(fill: rgb("#27AE60"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[C]]],
  )
]
]
#v(0.5em)

#block(breakable: false, width: 100%)[
#align(center)[
  #text(size: 11pt, weight: "bold")[a(14) <= 56]
  #h(0.5em)
  #text(size: 8pt, fill: rgb("#E67E22"), weight: "bold")[\[UPPER BOUND\]]
  #h(0.5em)
  #text(size: 8pt)[7 X 8 bounding box, binomial(14,2) = 91 pairs]
]
#v(0.2em)
#align(center)[
  #table(
    columns: (7mm,) * 8,
    rows: (7mm,) * 7,
    inset: 0pt,
    stroke: 0.5pt + white,
      table.cell(fill: rgb("#607D8B"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[J]]],
      table.cell(fill: rgb("#E74C3C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[A]]],
      table.cell(fill: rgb("#8E44AD"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[E]]],
      table.cell(fill: rgb("#27AE60"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[C]]],
      table.cell(fill: rgb("#16A085"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[G]]],
      table.cell(fill: rgb("#795548"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[I]]],
      table.cell(fill: rgb("#E67E22"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[F]]],
      table.cell(fill: rgb("#00BCD4"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[M]]],
      table.cell(fill: rgb("#E91E63"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[H]]],
      table.cell(fill: rgb("#795548"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[I]]],
      table.cell(fill: rgb("#B71C1C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[N]]],
      table.cell(fill: rgb("#607D8B"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[J]]],
      table.cell(fill: rgb("#F1C40F"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[D]]],
      table.cell(fill: rgb("#27AE60"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[C]]],
      table.cell(fill: rgb("#16A085"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[G]]],
      table.cell(fill: rgb("#E74C3C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[A]]],
      table.cell(fill: rgb("#B71C1C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[N]]],
      table.cell(fill: rgb("#8E44AD"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[E]]],
      table.cell(fill: rgb("#16A085"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[G]]],
      table.cell(fill: rgb("#2980B9"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[B]]],
      table.cell(fill: rgb("#689F38"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[K]]],
      table.cell(fill: rgb("#00BCD4"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[M]]],
      table.cell(fill: rgb("#607D8B"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[J]]],
      table.cell(fill: rgb("#E67E22"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[F]]],
      table.cell(fill: rgb("#689F38"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[K]]],
      table.cell(fill: rgb("#F1C40F"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[D]]],
      table.cell(fill: rgb("#00BCD4"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[M]]],
      table.cell(fill: rgb("#B71C1C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[N]]],
      table.cell(fill: rgb("#E67E22"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[F]]],
      table.cell(fill: rgb("#27AE60"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[C]]],
      table.cell(fill: rgb("#689F38"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[K]]],
      table.cell(fill: rgb("#1A237E"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[L]]],
      table.cell(fill: rgb("#E91E63"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[H]]],
      table.cell(fill: rgb("#16A085"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[G]]],
      table.cell(fill: rgb("#1A237E"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[L]]],
      table.cell(fill: rgb("#E74C3C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[A]]],
      table.cell(fill: rgb("#F1C40F"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[D]]],
      table.cell(fill: rgb("#2980B9"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[B]]],
      table.cell(fill: rgb("#8E44AD"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[E]]],
      table.cell(fill: rgb("#607D8B"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[J]]],
      table.cell(fill: rgb("#E74C3C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[A]]],
      table.cell(fill: rgb("#689F38"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[K]]],
      table.cell(fill: rgb("#B71C1C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[N]]],
      table.cell(fill: rgb("#27AE60"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[C]]],
      table.cell(fill: rgb("#1A237E"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[L]]],
      table.cell(fill: rgb("#E91E63"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[H]]],
      table.cell(fill: rgb("#00BCD4"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[M]]],
      table.cell(fill: rgb("#795548"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[I]]],
      table.cell(fill: rgb("#2980B9"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[B]]],
      table.cell(fill: rgb("#795548"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[I]]],
      table.cell(fill: rgb("#F1C40F"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[D]]],
      table.cell(fill: rgb("#E91E63"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[H]]],
      table.cell(fill: rgb("#8E44AD"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[E]]],
      table.cell(fill: rgb("#E67E22"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[F]]],
      table.cell(fill: rgb("#2980B9"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[B]]],
      table.cell(fill: rgb("#1A237E"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[L]]],
  )
]
]
#v(0.5em)

#block(breakable: false, width: 100%)[
#align(center)[
  #text(size: 11pt, weight: "bold")[a(15) <= 61]
  #h(0.5em)
  #text(size: 8pt, fill: rgb("#E67E22"), weight: "bold")[\[UPPER BOUND\]]
  #h(0.5em)
  #text(size: 8pt)[7 X 9 bounding box, binomial(15,2) = 105 pairs]
]
#v(0.2em)
#align(center)[
  #table(
    columns: (7mm,) * 9,
    rows: (7mm,) * 7,
    inset: 0pt,
    stroke: 0.5pt + white,
      table.cell(fill: rgb("#2980B9"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[B]]],
      table.cell(fill: rgb("#689F38"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[K]]],
      table.cell(fill: rgb("#E91E63"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[H]]],
      table.cell(fill: rgb("#607D8B"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[J]]],
      table.cell(fill: rgb("#F1C40F"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[D]]],
      table.cell(fill: rgb("#E74C3C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[A]]],
      table.cell(fill: rgb("#27AE60"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[C]]],
      table.cell(fill: rgb("#2980B9"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[B]]],
      table.cell(fill: rgb("#00BCD4"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[M]]],
      table.cell(fill: rgb("#F1C40F"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[D]]],
      table.cell(fill: rgb("#1A237E"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[L]]],
      table.cell(fill: rgb("#B71C1C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[N]]],
      table.cell(fill: rgb("#E74C3C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[A]]],
      table.cell(fill: rgb("#E91E63"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[H]]],
      table.cell(fill: rgb("#8E44AD"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[E]]],
      table.cell(fill: rgb("#F1C40F"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[D]]],
      table.cell(fill: rgb("#E67E22"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[F]]],
      table.cell(fill: rgb("#8E44AD"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[E]]],
      table.cell(fill: rgb("#689F38"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[K]]],
      table.cell(fill: rgb("#FF8A65"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[O]]],
      table.cell(fill: rgb("#27AE60"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[C]]],
      table.cell(fill: rgb("#16A085"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[G]]],
      table.cell(fill: rgb("#795548"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[I]]],
      table.cell(fill: rgb("#27AE60"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[C]]],
      table.cell(fill: rgb("#00BCD4"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[M]]],
      table.cell(fill: rgb("#16A085"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[G]]],
      table.cell(fill: rgb("#2980B9"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[B]]],
      table.cell(fill: rgb("#B71C1C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[N]]],
      table.cell(fill: rgb("#00BCD4"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[M]]],
      table.cell(fill: rgb("#E91E63"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[H]]],
      table.cell(fill: rgb("#FF8A65"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[O]]],
      table.cell(fill: rgb("#8E44AD"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[E]]],
      table.cell(fill: rgb("#1A237E"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[L]]],
      table.cell(fill: rgb("#795548"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[I]]],
      table.cell(fill: rgb("#F1C40F"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[D]]],
      table.cell(fill: rgb("#FF8A65"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[O]]],
      table.cell(fill: rgb("#2980B9"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[B]]],
      table.cell(fill: rgb("#1A237E"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[L]]],
      table.cell(fill: rgb("#E67E22"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[F]]],
      table.cell(fill: rgb("#27AE60"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[C]]],
      table.cell(fill: rgb("#689F38"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[K]]],
      table.cell(fill: rgb("#E74C3C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[A]]],
      table.cell(fill: rgb("#FF8A65"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[O]]],
      table.cell(fill: rgb("#B71C1C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[N]]],
      table.cell(fill: rgb("#E67E22"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[F]]],
      table.cell(fill: rgb("#E91E63"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[H]]],
      table.cell(fill: rgb("#16A085"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[G]]],
      table.cell(fill: rgb("#689F38"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[K]]],
      table.cell(fill: rgb("#607D8B"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[J]]],
      table.cell(fill: rgb("#00BCD4"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[M]]],
      table.cell(fill: rgb("#E67E22"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[F]]],
      table.cell(fill: rgb("#607D8B"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[J]]],
      table.cell(fill: rgb("#8E44AD"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[E]]],
      table.cell(fill: white)[],
      table.cell(fill: rgb("#1A237E"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[L]]],
      table.cell(fill: rgb("#607D8B"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[J]]],
      table.cell(fill: rgb("#795548"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[I]]],
      table.cell(fill: rgb("#2980B9"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[B]]],
      table.cell(fill: rgb("#E74C3C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[A]]],
      table.cell(fill: rgb("#795548"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[I]]],
      table.cell(fill: rgb("#B71C1C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[N]]],
      table.cell(fill: rgb("#16A085"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[G]]],
      table.cell(fill: white)[],
  )
]
]
#v(0.5em)

#block(breakable: false, width: 100%)[
#align(center)[
  #text(size: 11pt, weight: "bold")[a(16) <= 69]
  #h(0.5em)
  #text(size: 8pt, fill: rgb("#E67E22"), weight: "bold")[\[UPPER BOUND\]]
  #h(0.5em)
  #text(size: 8pt)[9 X 9 bounding box, binomial(16,2) = 120 pairs]
]
#v(0.2em)
#align(center)[
  #table(
    columns: (7mm,) * 9,
    rows: (7mm,) * 9,
    inset: 0pt,
    stroke: 0.5pt + white,
      table.cell(fill: white)[],
      table.cell(fill: rgb("#00BCD4"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[M]]],
      table.cell(fill: rgb("#AD1457"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[P]]],
      table.cell(fill: rgb("#B71C1C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[N]]],
      table.cell(fill: rgb("#607D8B"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[J]]],
      table.cell(fill: rgb("#27AE60"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[C]]],
      table.cell(fill: white)[],
      table.cell(fill: white)[],
      table.cell(fill: white)[],
      table.cell(fill: white)[],
      table.cell(fill: rgb("#E74C3C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[A]]],
      table.cell(fill: rgb("#FF8A65"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[O]]],
      table.cell(fill: rgb("#8E44AD"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[E]]],
      table.cell(fill: rgb("#2980B9"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[B]]],
      table.cell(fill: rgb("#795548"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[I]]],
      table.cell(fill: rgb("#00BCD4"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[M]]],
      table.cell(fill: rgb("#B71C1C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[N]]],
      table.cell(fill: white)[],
      table.cell(fill: rgb("#B71C1C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[N]]],
      table.cell(fill: rgb("#F1C40F"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[D]]],
      table.cell(fill: rgb("#1A237E"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[L]]],
      table.cell(fill: rgb("#795548"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[I]]],
      table.cell(fill: rgb("#FF8A65"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[O]]],
      table.cell(fill: rgb("#E91E63"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[H]]],
      table.cell(fill: rgb("#2980B9"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[B]]],
      table.cell(fill: rgb("#689F38"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[K]]],
      table.cell(fill: white)[],
      table.cell(fill: rgb("#E67E22"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[F]]],
      table.cell(fill: rgb("#16A085"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[G]]],
      table.cell(fill: rgb("#2980B9"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[B]]],
      table.cell(fill: rgb("#B71C1C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[N]]],
      table.cell(fill: rgb("#16A085"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[G]]],
      table.cell(fill: rgb("#AD1457"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[P]]],
      table.cell(fill: rgb("#F1C40F"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[D]]],
      table.cell(fill: rgb("#795548"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[I]]],
      table.cell(fill: white)[],
      table.cell(fill: rgb("#E74C3C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[A]]],
      table.cell(fill: rgb("#795548"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[I]]],
      table.cell(fill: rgb("#E67E22"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[F]]],
      table.cell(fill: rgb("#E91E63"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[H]]],
      table.cell(fill: rgb("#27AE60"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[C]]],
      table.cell(fill: rgb("#8E44AD"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[E]]],
      table.cell(fill: rgb("#689F38"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[K]]],
      table.cell(fill: rgb("#607D8B"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[J]]],
      table.cell(fill: rgb("#00BCD4"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[M]]],
      table.cell(fill: rgb("#2980B9"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[B]]],
      table.cell(fill: rgb("#AD1457"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[P]]],
      table.cell(fill: rgb("#27AE60"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[C]]],
      table.cell(fill: rgb("#689F38"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[K]]],
      table.cell(fill: rgb("#00BCD4"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[M]]],
      table.cell(fill: rgb("#F1C40F"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[D]]],
      table.cell(fill: rgb("#E67E22"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[F]]],
      table.cell(fill: rgb("#1A237E"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[L]]],
      table.cell(fill: rgb("#8E44AD"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[E]]],
      table.cell(fill: rgb("#27AE60"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[C]]],
      table.cell(fill: rgb("#E74C3C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[A]]],
      table.cell(fill: rgb("#1A237E"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[L]]],
      table.cell(fill: rgb("#AD1457"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[P]]],
      table.cell(fill: rgb("#E67E22"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[F]]],
      table.cell(fill: rgb("#607D8B"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[J]]],
      table.cell(fill: rgb("#FF8A65"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[O]]],
      table.cell(fill: rgb("#B71C1C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[N]]],
      table.cell(fill: rgb("#E74C3C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[A]]],
      table.cell(fill: rgb("#FF8A65"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[O]]],
      table.cell(fill: rgb("#689F38"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[K]]],
      table.cell(fill: rgb("#16A085"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[G]]],
      table.cell(fill: rgb("#607D8B"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[J]]],
      table.cell(fill: rgb("#8E44AD"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[E]]],
      table.cell(fill: rgb("#E91E63"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[H]]],
      table.cell(fill: rgb("#F1C40F"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[D]]],
      table.cell(fill: rgb("#27AE60"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[C]]],
      table.cell(fill: white)[],
      table.cell(fill: rgb("#00BCD4"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[M]]],
      table.cell(fill: rgb("#1A237E"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[L]]],
      table.cell(fill: rgb("#E91E63"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[H]]],
      table.cell(fill: rgb("#E74C3C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[A]]],
      table.cell(fill: rgb("#16A085"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[G]]],
      table.cell(fill: rgb("#00BCD4"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[M]]],
      table.cell(fill: white)[],
      table.cell(fill: white)[],
      table.cell(fill: white)[],
  )
]
]
#v(0.5em)

#block(breakable: false, width: 100%)[
#align(center)[
  #text(size: 11pt, weight: "bold")[a(17) <= 78]
  #h(0.5em)
  #text(size: 8pt, fill: rgb("#E67E22"), weight: "bold")[\[UPPER BOUND\]]
  #h(0.5em)
  #text(size: 8pt)[9 X 11 bounding box, binomial(17,2) = 136 pairs]
]
#v(0.2em)
#align(center)[
  #table(
    columns: (7mm,) * 11,
    rows: (7mm,) * 9,
    inset: 0pt,
    stroke: 0.5pt + white,
      table.cell(fill: white)[],
      table.cell(fill: white)[],
      table.cell(fill: white)[],
      table.cell(fill: white)[],
      table.cell(fill: rgb("#B71C1C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[N]]],
      table.cell(fill: rgb("#16A085"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[G]]],
      table.cell(fill: rgb("#E67E22"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[F]]],
      table.cell(fill: rgb("#795548"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[I]]],
      table.cell(fill: rgb("#E91E63"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[H]]],
      table.cell(fill: rgb("#B71C1C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[N]]],
      table.cell(fill: white)[],
      table.cell(fill: white)[],
      table.cell(fill: rgb("#FF8A65"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[O]]],
      table.cell(fill: rgb("#F1C40F"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[D]]],
      table.cell(fill: rgb("#16A085"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[G]]],
      table.cell(fill: rgb("#689F38"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[K]]],
      table.cell(fill: rgb("#E91E63"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[H]]],
      table.cell(fill: rgb("#E74C3C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[A]]],
      table.cell(fill: rgb("#B71C1C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[N]]],
      table.cell(fill: rgb("#1A237E"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[L]]],
      table.cell(fill: rgb("#E67E22"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[F]]],
      table.cell(fill: white)[],
      table.cell(fill: rgb("#AD1457"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[P]]],
      table.cell(fill: rgb("#B71C1C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[N]]],
      table.cell(fill: rgb("#00BCD4"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[M]]],
      table.cell(fill: rgb("#FF8A65"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[O]]],
      table.cell(fill: rgb("#E74C3C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[A]]],
      table.cell(fill: rgb("#2980B9"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[B]]],
      table.cell(fill: rgb("#8E44AD"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[E]]],
      table.cell(fill: rgb("#F1C40F"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[D]]],
      table.cell(fill: rgb("#E74C3C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[A]]],
      table.cell(fill: rgb("#27AE60"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[C]]],
      table.cell(fill: rgb("#8E44AD"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[E]]],
      table.cell(fill: rgb("#795548"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[I]]],
      table.cell(fill: rgb("#607D8B"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[J]]],
      table.cell(fill: rgb("#689F38"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[K]]],
      table.cell(fill: rgb("#BF8C00"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[Q]]],
      table.cell(fill: rgb("#795548"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[I]]],
      table.cell(fill: rgb("#1A237E"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[L]]],
      table.cell(fill: rgb("#689F38"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[K]]],
      table.cell(fill: rgb("#27AE60"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[C]]],
      table.cell(fill: rgb("#16A085"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[G]]],
      table.cell(fill: rgb("#2980B9"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[B]]],
      table.cell(fill: rgb("#E67E22"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[F]]],
      table.cell(fill: rgb("#FF8A65"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[O]]],
      table.cell(fill: rgb("#AD1457"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[P]]],
      table.cell(fill: rgb("#2980B9"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[B]]],
      table.cell(fill: rgb("#B71C1C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[N]]],
      table.cell(fill: rgb("#27AE60"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[C]]],
      table.cell(fill: rgb("#00BCD4"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[M]]],
      table.cell(fill: rgb("#AD1457"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[P]]],
      table.cell(fill: rgb("#E91E63"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[H]]],
      table.cell(fill: rgb("#00BCD4"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[M]]],
      table.cell(fill: rgb("#795548"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[I]]],
      table.cell(fill: rgb("#689F38"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[K]]],
      table.cell(fill: rgb("#E91E63"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[H]]],
      table.cell(fill: rgb("#E67E22"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[F]]],
      table.cell(fill: rgb("#FF8A65"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[O]]],
      table.cell(fill: rgb("#8E44AD"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[E]]],
      table.cell(fill: rgb("#607D8B"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[J]]],
      table.cell(fill: rgb("#2980B9"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[B]]],
      table.cell(fill: rgb("#F1C40F"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[D]]],
      table.cell(fill: rgb("#BF8C00"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[Q]]],
      table.cell(fill: rgb("#E67E22"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[F]]],
      table.cell(fill: rgb("#F1C40F"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[D]]],
      table.cell(fill: white)[],
      table.cell(fill: rgb("#F1C40F"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[D]]],
      table.cell(fill: rgb("#607D8B"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[J]]],
      table.cell(fill: rgb("#1A237E"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[L]]],
      table.cell(fill: rgb("#AD1457"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[P]]],
      table.cell(fill: rgb("#E74C3C"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[A]]],
      table.cell(fill: rgb("#BF8C00"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[Q]]],
      table.cell(fill: rgb("#1A237E"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[L]]],
      table.cell(fill: rgb("#8E44AD"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[E]]],
      table.cell(fill: white)[],
      table.cell(fill: white)[],
      table.cell(fill: white)[],
      table.cell(fill: rgb("#689F38"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[K]]],
      table.cell(fill: rgb("#FF8A65"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[O]]],
      table.cell(fill: rgb("#27AE60"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[C]]],
      table.cell(fill: rgb("#BF8C00"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[Q]]],
      table.cell(fill: rgb("#00BCD4"))[#align(center + horizon)[#text(size: 5pt, fill: black, weight: "bold")[M]]],
      table.cell(fill: rgb("#607D8B"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[J]]],
      table.cell(fill: rgb("#16A085"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[G]]],
      table.cell(fill: rgb("#795548"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[I]]],
      table.cell(fill: white)[],
      table.cell(fill: white)[],
      table.cell(fill: white)[],
      table.cell(fill: white)[],
      table.cell(fill: white)[],
      table.cell(fill: rgb("#AD1457"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[P]]],
      table.cell(fill: rgb("#16A085"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[G]]],
      table.cell(fill: rgb("#8E44AD"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[E]]],
      table.cell(fill: rgb("#E91E63"))[#align(center + horizon)[#text(size: 5pt, fill: white, weight: "bold")[H]]],
      table.cell(fill: white)[],
      table.cell(fill: white)[],
      table.cell(fill: white)[],
      table.cell(fill: white)[],
      table.cell(fill: white)[],
  )
]
]
#v(0.5em)

#v(0.5em)
#line(length: 100%, stroke: 0.5pt)
#v(0.3em)
#align(center)[
#text(size: 9pt, weight: "bold")[Color Legend]
#v(0.2em)
#grid(columns: 9, column-gutter: 8pt, row-gutter: 4pt,
  box(inset: 1pt)[#rect(width: 10pt, height: 10pt, fill: rgb("#E74C3C"), stroke: 0.3pt + black)[#align(center + horizon)[#text(size: 6pt, fill: white, weight: "bold")[A]]] #text(size: 7pt)[1]],
  box(inset: 1pt)[#rect(width: 10pt, height: 10pt, fill: rgb("#2980B9"), stroke: 0.3pt + black)[#align(center + horizon)[#text(size: 6pt, fill: white, weight: "bold")[B]]] #text(size: 7pt)[2]],
  box(inset: 1pt)[#rect(width: 10pt, height: 10pt, fill: rgb("#27AE60"), stroke: 0.3pt + black)[#align(center + horizon)[#text(size: 6pt, fill: white, weight: "bold")[C]]] #text(size: 7pt)[3]],
  box(inset: 1pt)[#rect(width: 10pt, height: 10pt, fill: rgb("#F1C40F"), stroke: 0.3pt + black)[#align(center + horizon)[#text(size: 6pt, fill: black, weight: "bold")[D]]] #text(size: 7pt)[4]],
  box(inset: 1pt)[#rect(width: 10pt, height: 10pt, fill: rgb("#8E44AD"), stroke: 0.3pt + black)[#align(center + horizon)[#text(size: 6pt, fill: white, weight: "bold")[E]]] #text(size: 7pt)[5]],
  box(inset: 1pt)[#rect(width: 10pt, height: 10pt, fill: rgb("#E67E22"), stroke: 0.3pt + black)[#align(center + horizon)[#text(size: 6pt, fill: white, weight: "bold")[F]]] #text(size: 7pt)[6]],
  box(inset: 1pt)[#rect(width: 10pt, height: 10pt, fill: rgb("#16A085"), stroke: 0.3pt + black)[#align(center + horizon)[#text(size: 6pt, fill: white, weight: "bold")[G]]] #text(size: 7pt)[7]],
  box(inset: 1pt)[#rect(width: 10pt, height: 10pt, fill: rgb("#E91E63"), stroke: 0.3pt + black)[#align(center + horizon)[#text(size: 6pt, fill: white, weight: "bold")[H]]] #text(size: 7pt)[8]],
  box(inset: 1pt)[#rect(width: 10pt, height: 10pt, fill: rgb("#795548"), stroke: 0.3pt + black)[#align(center + horizon)[#text(size: 6pt, fill: white, weight: "bold")[I]]] #text(size: 7pt)[9]],
  box(inset: 1pt)[#rect(width: 10pt, height: 10pt, fill: rgb("#607D8B"), stroke: 0.3pt + black)[#align(center + horizon)[#text(size: 6pt, fill: white, weight: "bold")[J]]] #text(size: 7pt)[10]],
  box(inset: 1pt)[#rect(width: 10pt, height: 10pt, fill: rgb("#689F38"), stroke: 0.3pt + black)[#align(center + horizon)[#text(size: 6pt, fill: white, weight: "bold")[K]]] #text(size: 7pt)[11]],
  box(inset: 1pt)[#rect(width: 10pt, height: 10pt, fill: rgb("#1A237E"), stroke: 0.3pt + black)[#align(center + horizon)[#text(size: 6pt, fill: white, weight: "bold")[L]]] #text(size: 7pt)[12]],
  box(inset: 1pt)[#rect(width: 10pt, height: 10pt, fill: rgb("#00BCD4"), stroke: 0.3pt + black)[#align(center + horizon)[#text(size: 6pt, fill: black, weight: "bold")[M]]] #text(size: 7pt)[13]],
  box(inset: 1pt)[#rect(width: 10pt, height: 10pt, fill: rgb("#B71C1C"), stroke: 0.3pt + black)[#align(center + horizon)[#text(size: 6pt, fill: white, weight: "bold")[N]]] #text(size: 7pt)[14]],
  box(inset: 1pt)[#rect(width: 10pt, height: 10pt, fill: rgb("#FF8A65"), stroke: 0.3pt + black)[#align(center + horizon)[#text(size: 6pt, fill: black, weight: "bold")[O]]] #text(size: 7pt)[15]],
  box(inset: 1pt)[#rect(width: 10pt, height: 10pt, fill: rgb("#AD1457"), stroke: 0.3pt + black)[#align(center + horizon)[#text(size: 6pt, fill: white, weight: "bold")[P]]] #text(size: 7pt)[16]],
  box(inset: 1pt)[#rect(width: 10pt, height: 10pt, fill: rgb("#BF8C00"), stroke: 0.3pt + black)[#align(center + horizon)[#text(size: 6pt, fill: white, weight: "bold")[Q]]] #text(size: 7pt)[17]],
)
]
