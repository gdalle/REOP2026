#set document(
  title: "Routing problems",
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

We focus on problems with a single vehicle. The input is always the same: a graph $G = (V, E)$ and a cost function $c: E -> RR_+$. We consider undirected graphs (see textbook for the directed case).

= Traveling Salesperson Problem (TSP)

Goal: find a cycle $C$ of minimum cost $sum_(e in E) c(e)$ that visits each vertex at least once.

Reformulation: find a Hamiltonian cycle on the complete graph $K_n$ with shortest path costs $==>$ triangular inequality $c(u, w) <= c(u, v) + c(v, w)$. This is called the metric TSP.

== Heuristics

=== No guarantees

Greedy: Nearest neighbor

Local search: $2$-OPT, $k$-OPT, Lin-Kernighan

=== Approximation algorithms

Double tree algorithm: find a MST, double the edges, construct a Eulerian tour, take shortcuts to ignore vertex repetitions $==>$ approx. ratio of 2

_Proof:_ MST is a lower bound on TSP.
#h(1fr) $qed$

Christofides algorithm: find a MST, find a minimum weight perfect matching between odd-degree vertices, double the edges of the matching, construct a Eulerian tour, take shortcuts to ignore vertex repetitions.

_Proof:_ MST is a lower bound on TSP + each optimal tour is the union of two perfect matchings
#h(1fr) $qed$

_Exercise 15.1: Number of vertices of odd degree (handshaking lemma)_

== Integer Programming

=== Hamiltonian cycle polytope

The TSP can be formulated as an Integer Program:

$
  min sum_(e in E) c(e) x_e quad "s.t." quad cases(
    x_e in {0, 1} & quad forall e,
    sum_(e in delta(v)) x_e = 2 & quad forall v,
    sum_(e in delta(X)) x_e >= 2 & quad forall X subset.neq V\, X != emptyset,
  )
$

The subtour elimination constraint boils down to finding a minimum cut in the graph $K_n [x]$, which means we can separate it in polynomial time.

_Exercise: Prove that the subtour elimination constraint for the TSP can be reformulated as $sum_(e in E(X)) x_e <= |X| - 1$, which we saw in the MST formulation._

_Exercise 15.6: TSP with time constraints._

=== Branch and Cut

The number of constraints is exponential, which is why we cannot include them all in the Branch & Bound scheme. We use a constraint generation method: at each node of the B&B tree, we start with a small number of subsets $X$ and iteratively add constraints that are violated by the solution to the linear relaxation, until we can prove (continuous) feasibility.

In this case, the subproblems are harder than the root problem: we must solve TSP relaxations where some edges are forbidden and others are imposed.

_Exercise: We consider a constrained TSP where the solution must use edges from $A subset E$ and cannot use edges from set $B subset E$. Modify the cost function to formulate this as an unconstrained TSP._

The point of this trick is to use standard lower bounds for the unconstrained TSP at every node of the tree (such as the Held-Karp bound, see textbook).

== Theoretical results

*Theorem* (Beardwood, Halton & Hammersley, 1956): The length $L_n$ of the shortest cycle through $n$ independent uniform random points in $[0, 1]^2$ satisfies $L_n \/ sqrt(n) -> beta$ almost surely, where $beta$ is a constant whose value is not known explicitly.

*Theorem* (Karp, 1972): The TSP is NP-hard.

*Theorem* (Sahni & Gonzalez, 1976): It is NP-hard to approximate the general (non-metric) TSP within any constant factor.

*Theorem* (Christofides, 1976): The metric TSP has a polynomial $3/2$-approximation algorithm.

*Theorem* (Arora, 1998): The Euclidean TSP has a polynomial $(1+epsilon)$-approximation algorithm for any $epsilon > 0$.

*Theorem* (Karpinski, Lampis & Schmied, 2015): It is NP-hard to approximate the metric TSP within a factor of $123/122$, and the metric _asymmetric_ TSP within a factor of $75\/74$.

*Theorem* (Svensson, Tarnawski & Végh, 2018): The metric _asymmetric_ TSP has a polynomial $506$-approximation algorithm.

*Theorem* (Karlin, Klein & Gharan, 2020): The metric TSP has a polynomial $(3/2 - 10^(-36))$-approximation algorithm.

= Postperson Tour Problem

Goal: find a cycle $C$ of minimum cost $sum_(e in E) c(e)$ that visits each edge at least once.
$G$ is a city, vertices are intersections, edges are streets where the postperson must leave mail at each door.

_Exercise: Find a flow formulation._

If the graph is Eulerian, any Eulerian cycle is optimal.

*Lemma 15.6*: The optimal postman tour visits each edge at most twice.

_Proof idea:_ A postman tour on $G$ defines a Eulerian multigraph $G'$, and if $e$ is present $k >= 3$ times, then removing $e$ two times keeps $G'$ Eulerian, which enables us to rebuild a cheaper postman tour on $G$.
#h(1fr) $qed$

We look for the cheapest set of edges $F$ to duplicate in order to make $G$ Eulerian.

*Theorem 15.7*: We can find $F$ in polynomial time.

_Proof idea:_ Same as Christofides algorithm: $F$ is a union of paths linking the vertices of odd degree in $G$. We match these vertices together using the shortest path distance between them as cost.
#h(1fr) $qed$
