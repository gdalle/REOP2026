---
title: Optimization problems and graphs
author: Guillaume Dalle (ENPC, CERMICS)
date: REOP - Class 1 (22/09/2021)
output:
  pdf_document:
    toc: true
    number_sections: true
bibliography: "/home/guillaume/Documents/Zotero_biblatex.bib"
geometry: margin=1in
---

# Introduction

## About me

Hi, I'm Guillaume DALLE, a PhD student in applied mathematics at [CERMICS](https://cermics-lab.enpc.fr/). I work with SNCF on predicting and preventing traffic disruptions using tools from machine learning and operations research.

The easiest way to contact me is my academic email <a href="mailto:guillaume.dalle@enpc.fr">guillaume.dalle@enpc.fr</a>. I will answer quickly but never outside of office hours, in order to preserve your personal life and mine. You can also come visit me in room B210 of the Coriolis building at École des Ponts, just remember to schedule it with me beforehand.

## Resources

- Course website on Educnet (<https://educnet.enpc.fr/course/view.php?id=1215>)
- My website (<https://gdalle.github.io/reop/>)
- The Teams workspace (see email from Axel Parmentier)

## Rules

- Be respectful towards your classmates (and teacher).
- Always ask me if you have any problems with the class or with your studies in general. Honesty will never be punished, and I may even be able to help.
- Follow Covid sanitary guidelines. Masks on the mouth and nose at all times.
- Try to arrive on time, send an email if you can't.
- Language should not be an issue.

Please fill the [introduction form on Wooclap](https://www.wooclap.com/REOP2021GDADMIN) if you haven't already!

# General framework of Operations Research

## Problems

Problem $\mathcal{P}$ = family of inputs + question to answer:

- Decision problem: answer is either `yes` or `no`
- Optimization problem: find the best candidate among a family

An optimization problem is often formulated as

$$ \min_x c(x) \quad \text{s.t.} \quad x \in \mathcal{X} \tag{P} $$

- "s.t." means "subject to"
- $x$ is the decision variable
- $\mathcal{X}$ is the set of feasible solutions
- $x \in \mathcal{X}$ is the set of constraints
- $c(x)$ is the criterion / objective / cost function

Solving the problem means finding

- the optimal value $\mathrm{val}(P)$
- if possible, an optimal solution $x^* \in \mathrm{argmin}\{c(x): x \in \mathcal{X}\}$

Instance $\mathcal{I}$ = one particular input with its numerical values.

## Algorithms and heuristics

Algorithm $\mathcal{A}$ = sequence of elementary operations that can be implemented on a computer.

Time complexity $f(n)$ of an algorithm $\mathcal{A}$ = number of elementary operations necessary with input of size $n$.
Polynomial algorithms are usually considered efficient, while exponential algorithms scare many researchers (not us).

There are several types of optimization algorithms:

- Exact algorithms: yield an optimal solution
- Approximation algorithms: yield a solution with bounded sub-optimality
- Heuristics: yield a solution with no guarantee at all

Local descent enables us to explore large solution spaces with small movements.
Typical algorithm: given the current solution $x_k$

1. Compute and explore its neighborhood $\mathcal{N}(x_k)$
2. Pick a next solution $x_{k+1} \in \mathcal{N}(x_{k})$ such that $c(x_k) < c(x_{k+1})$

How to evaluate the quality of a solution without a certificate of optimality? Compare its value $c(x)$ with a lower bound $\ell \leq \mathrm{val}(P) \leq c(x)$

# A bit of graph theory

## Vocabulary

A graph $G = (V, E)$ is composed of:

- a set $V$ of vertices, often called $u$ or $v$, with $|V|=n$
- a set $E$ of edges, often denoted by $e = (u, v)$, with $|E|=m$

A subgraph $H$ is a couple $(V' \subset V, E' \subset E)$.

The degree of a vertex is the number of incidence edges

The adjacency matrix $A = (A_{u,v}) \in \{0, 1\}^{n\times n}$ tells us whether two vertices are linked by an edge

> Exercise 3.3: powers of adjacency matrices

## Paths

A path is a sequence of nodes linked by edges. Types of paths:

- simple: no edge is crossed twice
- elementary: no vertex visited twice
- cycle: start vertex = end vertex
- eulerian: crosses all edges once
- hamiltonian: visits all vertices once

## Types of graphs

- undirected: edges are not ordered $(u, v) = \{u, v\}$
- directed: edges are ordered $(u, v) = u \to v$ (we use the terminology "nodes" and "arcs")
- simple: no duplicate edges or self loops
- complete: simple with all possible edges
- bipartite: split in two parts with all edges in the middle
- connected: all couples of vertices have a path between them
- eulerian / hamiltonian: contains a eulerian/hamiltonian cycle
- forest: contains no cycle
- tree: connected and contains no cycle

A graph is eulerian iff all its vertices have even degree (i.e. an even number of incident edges).

> Exercise 3.5: criterion for Eulerian graphs

## Zoo of graph problems

**Colorings and cliques**

A coloring is a function $c: V \to \mathbb{N}$ such that two adjacent vertices do not share the same color: if $(u, v) \in E$, $c(u) \neq c(v)$. The minimum number of colors needed to color a graph is its chromatic number $\chi(G)$.

A clique is a complete subgraph. The maximum cardinality of a clique is denoted by $\omega(G)$.

We have $\omega(G) \leq \chi(G)$.

**Matchings and covers**

A matching is a set of disjoint edges (maximum cadinality $\nu(G)$).

A vertex cover is a set of vertices that covers (has a member belonging to) every edge (minimum cardinality $\tau(G)$).

We have $\nu(G) \leq \tau(G)$.

**Stable sets and edge covers**

A stable set is a set of vertices such that no two of them are linked to each other (maximum cardinality $\alpha(G)$).

An edge cover is a set of edges that covers (has a member incident to) every vertex (minimum cardinality $\rho(G)$).

We have $\alpha(G) \leq \rho(G)$.

> Exercise 3.10: stable sets and vertex covers

# MILP modeling

A Linear Program is an optimization problem with a linear objective and linear constraints:

$$\min_{x \in \mathbb{R}^n} c^\top x \quad \text{s.t.} \quad Ax \leq b \tag{LP}$$

A Mixed Integer Linear Program is a LP where some of the variables are constrained to be integers

$$\min_{x \in \mathbb{Z}^p \times \mathbb{R}^{n-p}} c^\top x \quad \text{s.t.} \quad Ax \leq b \tag{MILP}$$

In theory, solving a MILP is hard. However:

- they are very useful to model lots of real-life problems
- there are practically efficient solvers that can handle millions of variables if the problem has a certain structure
