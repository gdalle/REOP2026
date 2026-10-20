#set document(
  title: "Bin packing & Facility location",
  author: "Guillaume Dalle",
)

#set text(
  font: "New Computer Modern",
  size: 12pt,
)

#set par(
  justify: true,
)

#set page(numbering: "1")

#set math.equation(numbering: "(1)")

#show title: set align(center)
#show title: set block(below: 1em)

#set heading(numbering: "1.a")

#show heading: set block(below: 1em)
#show link: set text(fill: blue)
#show link: underline

#title(context document.title)

#outline()

= Bin packing

== One container: the knapsack problem

- We already saw a dynamic programming approach last week
- There is also an ILP formulation
- The continuous relaxation can be solved analytically: just sort the objects by decreasing price per kilogram
- Using this relaxation, we can deduce a simple 2-approximation algorithm

== Several containers

- The objective is to minimize the number of containers used
- Easy lower bound
- Online heuristics: NEXT-FIT (2-approx) & FIRST-FIT (17/10-approx)
- Offline heuristic: FIRST-FIT-DECREASING (3/2-approx, cannot do better)
- ILP formulation: need to assume we have $K$ boxes available
- Strengthen the relaxation with valid inequalities: Ex 13.3 (reminder on cuts and B&B)
- Solve a simple case polynomially: Ex 13.4

= Facility location

- ILP formulation
- Local search algorithm: drop, add or swap facilities and assign each client to the cheapest facility
