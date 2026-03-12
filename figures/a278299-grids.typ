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
#raw(block: true, lang: none, "+---+---+---+---+---+---+
| 2 | 7 | 3 | 9 | 2 | 3 |
+---+---+---+---+---+---+---+
| 6 | 9 | 4 | 8 | 5 | 6 | 7 |
+---+---+---+---+---+---+---+
| 10| 11| 2 | 12| 10| 8 | 11|
+---+---+---+---+---+---+---+
| 4 | 6 | 1 | 5 | 9 | 1 | 3 |
+---+---+---+---+---+---+---+
| 1 | 12| 11| 4 | 12| 7 | 8 |
+---+---+---+---+---+---+---+
| 10| 3 | 5 | 7 |   | 10| 2 |
+---+---+---+---+   +---+---+")
]
]
#v(0.5em)

#block(breakable: false, width: 100%)[
#align(center)[
  #text(size: 11pt, weight: "bold")[a(13) <= 47]
  #h(0.5em)
  #text(size: 8pt, fill: rgb("#E67E22"), weight: "bold")[\[UPPER BOUND\]]
  #h(0.5em)
  #text(size: 8pt)[9 X 7 bounding box, binomial(13,2) = 78 pairs]
]
#v(0.2em)
#align(center)[
#raw(block: true, lang: none, "            +---+---+
            | 3 | 1 |
        +---+---+---+---+---+
        | 7 | 8 | 2 | 7 | 5 |
    +---+---+---+---+---+---+
    | 12| 11| 13| 4 | 9 | 1 |
    +---+---+---+---+---+---+
    | 1 | 8 | 12| 10| 8 | 4 |
+---+---+---+---+---+---+---+
| 12| 7 | 6 | 3 | 13| 5 | 3 |
+---+---+---+---+---+---+---+
| 9 | 13| 1 | 11| 2 | 10| 7 |
+---+---+---+---+---+---+---+
    | 6 | 10| 9 | 6 | 11| 4 |
    +---+---+---+---+---+---+
        | 3 | 2 | 12| 5 |
        +---+---+---+---+
        | 9 | 5 | 4 | 6 |
        +---+---+---+---+")
]
]
#v(0.5em)

#block(breakable: false, width: 100%)[
#align(center)[
  #text(size: 11pt, weight: "bold")[a(14) <= 56]
  #h(0.5em)
  #text(size: 8pt, fill: rgb("#E67E22"), weight: "bold")[\[UPPER BOUND\]]
  #h(0.5em)
  #text(size: 8pt)[9 X 10 bounding box, binomial(14,2) = 91 pairs]
]
#v(0.2em)
#align(center)[
#raw(block: true, lang: none, "        +---+---+---+---+
        | 7 | 3 | 14| 1 |
    +---+---+---+---+---+
    | 12| 14| 13| 5 | 6 |
+---+---+---+---+---+---+
| 2 | 3 | 11| 9 | 4 | 14|
+---+---+---+---+---+---+---+---+
| 9 | 10| 6 | 8 | 11| 10| 7 | 9 |
+---+---+---+---+---+---+---+---+
| 3 | 8 | 4 | 7 | 1 | 13| 2 | 5 |
+---+---+---+---+---+---+---+---+---+---+
    | 13| 12| 11| 5 | 7 | 12| 10| 4 | 13|
    +---+---+---+---+---+---+---+---+---+
    | 11| 8 | 2 | 12| 6 | 9 | 1 | 3 | 6 |
    +---+---+---+---+---+---+---+---+---+
            | 4 | 1 | 2 | 14| 8 | 5 |
            +---+---+---+---+---+---+
                    | 10|
                    +---+")
]
]
#v(0.5em)

#block(breakable: false, width: 100%)[
#align(center)[
  #text(size: 11pt, weight: "bold")[a(15) <= 61]
  #h(0.5em)
  #text(size: 8pt, fill: rgb("#E67E22"), weight: "bold")[\[UPPER BOUND\]]
  #h(0.5em)
  #text(size: 8pt)[9 X 8 bounding box, binomial(15,2) = 105 pairs]
]
#v(0.2em)
#align(center)[
#raw(block: true, lang: none, "        +---+---+---+---+---+---+
        | 7 | 11| 8 | 10| 14| 3 |
    +---+---+---+---+---+---+---+
    | 6 | 8 | 9 | 3 | 11| 6 | 10|
+---+---+---+---+---+---+---+---+
| 12| 3 | 2 | 6 | 1 | 12| 5 | 1 |
+---+---+---+---+---+---+---+---+
    | 13| 11| 15| 7 | 6 | 4 | 11|
    +---+---+---+---+---+---+---+
    | 8 | 5 | 10| 12| 13| 15| 14|
    +---+---+---+---+---+---+---+
    | 15| 3 | 4 | 9 | 7 | 2 | 12|
    +---+---+---+---+---+---+---+
    | 5 | 7 | 14| 13| 10| 9 | 15|
    +---+---+---+---+---+---+---+
    | 2 | 4 | 8 | 1 | 2 | 14| 1 |
    +---+---+---+---+---+---+---+
            | 12| 4 | 13| 5 | 9 |
            +---+---+---+---+---+")
]
]
#v(0.5em)

#block(breakable: false, width: 100%)[
#align(center)[
  #text(size: 11pt, weight: "bold")[a(16) <= 69]
  #h(0.5em)
  #text(size: 8pt, fill: rgb("#E67E22"), weight: "bold")[\[UPPER BOUND\]]
  #h(0.5em)
  #text(size: 8pt)[10 X 8 bounding box, binomial(16,2) = 120 pairs]
]
#v(0.2em)
#align(center)[
#raw(block: true, lang: none, "        +---+---+---+---+---+
        | 14| 1 | 4 | 6 | 12|
        +---+---+---+---+---+---+
        | 11| 9 | 2 | 1 | 10| 14|
+---+---+---+---+---+---+---+---+
| 5 | 12| 8 | 3 | 12| 16| 4 | 13|
+---+---+---+---+---+---+---+---+
| 10| 7 | 6 | 11| 13| 9 | 15| 3 |
+---+---+---+---+---+---+---+---+
| 9 | 14| 5 | 15| 2 | 6 | 13| 1 |
+---+---+---+---+---+---+---+---+
| 12| 4 | 3 | 14| 16| 3 | 10| 11|
+---+---+---+---+---+---+---+---+
| 1 | 5 | 2 | 8 | 13| 7 | 15| 12|
+---+---+---+---+---+---+---+---+
        | 7 | 9 | 5 | 16| 6 | 14|
        +---+---+---+---+---+---+
        | 11| 4 | 7 | 8 | 10| 2 |
        +---+---+---+---+---+---+
        | 5 | 8 | 1 | 15| 16| 11|
        +---+---+---+---+---+---+")
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
#raw(block: true, lang: none, "            +---+---+---+---+
            | 9 | 8 | 6 | 13|
        +---+---+---+---+---+---+
        | 7 | 1 | 10| 17| 1 | 15|
+---+---+---+---+---+---+---+---+---+---+
| 14| 4 | 17| 14| 9 | 2 | 8 | 7 | 14| 6 |
+---+---+---+---+---+---+---+---+---+---+---+
| 8 | 13| 12| 5 | 7 | 11| 15| 3 | 10| 7 | 13|
+---+---+---+---+---+---+---+---+---+---+---+
| 4 | 3 | 8 | 17| 16| 13| 9 | 17| 13| 2 | 15|
+---+---+---+---+---+---+---+---+---+---+---+
| 16| 9 | 5 | 11| 3 | 14| 12| 15| 5 | 3 | 6 |
+---+---+---+---+---+---+---+---+---+---+---+
| 8 | 11| 10| 4 | 1 | 2 | 6 | 10| 2 | 12| 1 |
+---+---+---+---+---+---+---+---+---+---+---+
    | 1 | 16| 6 | 5 | 16| 11| 12| 4 | 7 |
    +---+---+---+---+---+---+---+---+---+
            | 9 | 4 | 15| 14| 16|
            +---+---+---+---+---+")
]
]
#v(0.5em)
#line(length: 100%, stroke: 0.5pt)
