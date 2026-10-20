#set document(
  title: "Network design & Lagrangian relaxation",
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

= Network design

== Graphical Steiner tree

Problem description

- Input: an undirected graph $G = (V, E)$ with edge weights $w: E -> RR_+$, a set of terminals $S subset V$

- Task: find a tree $T$ of minimum weight covering $S$

We already know two polynomial special cases:

- $|S| = 2$: shortest path problem
- $S = V$: minimum spanning tree (MST)

Unfortunately, the general version is NP-hard

== Exact algorithms

- Dynamic programming (Dreyfus-Wagner): complexity $O(3^(|T|) n + 2^(|T|) n^2 + m n + n^2 log n)$
- ILP: formulation is similar to TSP, with exponential number of constraints $==>$ branch & cut approach. Let $r in S$ be any fixed terminal (root):

$
  min_(x in {0, 1}^E) sum_(e in E) w(e) x_e quad "s.t." quad sum_(e in delta(X)) x_e >= 1 quad forall X subset.eq V, r in.not X, X inter S != emptyset
$

== Approximation algorithms & heuristics

- $2$-approximation algorithm (Kou-Markowsky-Berman):
  - Let $overline(G)$ be the metric closure of $G$, and $overline(w)$ the (shortest path) edge weights
  - Find an MST $overline(T)$ in $overline(G)[S]$ with respect to $overline(w)$
  - Decompress it to obtain a Steiner tree $T$ in $G$

- Local search: same idea as for facility location.
  - High-level search on the vertices $V(T)$ of the Steiner tree (terminals $union$ Steiner points)
  - If the vertices $V(T)$ are fixed, choosing the edges $E(T)$ amounts to finding an MST

== Variants

- Euclidean Steiner tree: NP-hard
- Manhattan Steiner tree: NP-hard

= Lagrangian relaxation

Sometimes the bound provided by linear relaxation of a MILP is not tight enough.

In a few cases, one can change the formulation and handle an exponential number of constraints with constraint generation (see TSP). We now present another method which is useful to decompose structured problems.

== Motivating example: MAPF

The Multi-Agent Path Finding problem consists in finding paths for a set $A$ of agents on a graph $G$ such that:

+ The path $P_a$ of agent $a$ leads it from its origin $o_a$ to its destination $d_a$
+ The paths of two agents $a_1$ and $a_2$ cannot visit the same vertex at the same time

Without the conflict constraint, this decomposes into a set of $|A|$ independent shortest path problems, which can be quickly solved with any standard algorithm from the class.

Unfortunately, the additional constraint makes MAPF NP-hard, which is why we need an additional trick to exploit the problem's natural decomposition.

== Definition

We consider the general ILP

$
  z_I = min_x c^top x quad "s.t." quad cases(
    A_"easy" x <= b_"easy",
    A_"hard" x <= b_"hard",
    x in ZZ^n,
  )
$

Our premise is that this problem would be easy to solve if we had only the easy constraints. We are going to use this insight by solving a new problem where the hard constraints are penalized instead of being strictly enforced:

$
  z_"LR" (lambda) = min_x c^top x + lambda^top (A_"hard" x - b_"hard") quad "s.t." quad cases(
    A_"easy" x <= b_"easy",
    x in ZZ^n,
  )
$

We can compute $z_"LR" (lambda)$ for any value of $lambda$, but we are interested in the best possible bound, so it makes sense to search for

$ z_"LD" = max_(lambda >= 0) z_"LR" (lambda) $

Since $lambda |-> z_"LR" (lambda)$ is a minimum of linear functions of $lambda$, it is concave and we can maximize it using simple methods such as projected supergradient ascent (the analogue of subgradient descent).

== Quality of the bound

How does this Lagrangian dual bound $z_"LD"$ compare to the linear relaxation $z_"lin"$? To answer that, let us define

$
  X_"easy" = {x in RR^n | A_"easy" x <= b_"easy"} quad "and" quad X_"hard" = {x in RR^n | A_"hard" x <= b_"hard"}
$

Then Geoffrion's theorem tells us

$
  z_"LD" = min_x c^top x quad "s.t." quad cases(
    x in op("conv")(X_"easy" inter ZZ^n),
    x in X_"hard",
  )
$

whereas the linear relaxation yields a weaker lower bound

$
  z_"lin" = min_x c^top x quad "s.t." quad cases(
    x in X_"easy",
    x in X_"hard",
  )
$
