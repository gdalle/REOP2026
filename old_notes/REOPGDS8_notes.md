---
title: Bin packing & Facility location
author: Guillaume Dalle (ENPC, CERMICS)
date: REOP - Class 8 (08/12/2021)
output:
  pdf_document:
    toc: true
    number_sections: true
bibliography: "/home/guillaume/Documents/Zotero_biblatex.bib"
geometry: margin=1in
---

# Bin packing

## One container: the knapsack problem

- We already saw a dynamic programming approach last week
- There is also an ILP formulation
- The continuous relaxation can be solved analytically: just sort the objects by decreasing price per kilogram
- Using this relaxation, we can deduce a simple 2-approximation algorithm

## Several containers

- The objective is to minimize the number of containers used
- Easy lower bound
- Online heuristics: NEXT-FIT (2-approx) & FIRST-FIT (17/10-approx)
- Offline heuristic: FIRST-FIT-DECREASING (3/2-approx, cannot do better)
- ILP formulation: need to assume we have $K$ boxes available
- Strengthen the relaxation with valid inequalities: Ex 13.3 (reminder on cuts and B&B)
- Solve a simple case polynomially: Ex 13.4

# Facility location

- ILP formulation
- Local search algorithm: drop, add or swap facilities and assign each client to the cheapest facility