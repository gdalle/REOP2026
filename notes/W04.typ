#set document(
  title: "Spanning trees and complexity",
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

= Minimum spanning trees

== Definitions

A spanning subgraph of $cal(G) = (V, E)$ is a subgraph $cal(H) = (V, F)$ whose set of edges is incident to every vertex of $V$. If $cal(H)$ is also a tree (connected & without cycles), we talk of a spanning tree.

*Minimum spanning tree (MST) problem:*

- Input: An undirected connected graph $cal(G) = (V, E)$, a weight function $c: E -> RR$
- Output: A spanning tree $cal(T) = (V, T)$ of minimum weight $sum_(e in T) c(e)$

== Greedy construction

=== Kruskal's algorithm

+ Sort $E$ by increasing edge weight: $E = {e_1, ..., e_m}$ with $c(e_i) <= c(e_(i+1))$
+ Start with $F_0 = emptyset$
+ For $i = 1, ..., m$: if $F_(i-1) union {e_i}$ has no cycles, set $F_i = F_(i-1) union {e_i}$, otherwise set $F_i = F_(i-1)$.
+ Return $cal(T) = (V, F_m)$.

_Exercise 4.2: applying Kruskal's algorithm_

=== Correctness argument

At any time during the algorithm, $cal(F)_i = (V, F_i)$ is a forest because we ensure that it remains without cycles. So $cal(T)$ is a forest.

If $cal(T) = (V, F_m)$ is not connected (in particular, if it has isolated vertices), then let $V_1$ and $V_2$ be two connected components in $cal(T)$. Since $cal(G)$ is connected, there is an edge $e in E$ between $V_1$ and $V_2$: this edge does not belong to $cal(T)$ and does not create a cycle, hence it should have been added at some point in the algorithm. We obtain a contradiction: $cal(T)$ is a connected forest on $V$, aka a spanning tree.

To prove that $cal(T)$ has minimum weight among all spanning trees, we can use the following loop invariant: _for all $i$, there is a minimum spanning tree $cal(T)_i = (V, T_i)$ such that $cal(F)_i = (V, F_i)$ is a subgraph of $cal(T)_i$_. This will allow us to conclude that $cal(T) = cal(T)_m$ (since both are trees with the same number of vertices).

_Exercise: Prove that the loop invariant stays true during iteration $i$. To do that, try to build $T_i$ from $T_(i-1)$ by considering all possible cases. You will need to justify the following statements, in order:_

+ _We only need to consider the case where $e_i = (u_i, v_i)$ is added to $F_(i-1)$ but doesn't belong to $T_(i-1)$._
+ _In this case, let $X$ be the connected component of $cal(F)_(i-1)$ containing $u_i$: $X$ does not contain $v_i$._
+ _$T_(i-1)$ contains exactly one path between $u_i$ and $v_i$, which crosses the cut $delta(X, V without X)$ using an edge $f != e_i$._
+ _The cut $delta(X, V without X)$ is disjoint from $F_(i-1)$._
+ _$delta(X, V without X)$ does not contain any $e_j$ with $j < i$._
+ _$T_i := T_(i-1) without {f} union {e_i}$ satisfies $c(T_i) <= c(T_(i-1))$._
+ _$T_i$ is still a spanning tree._

Here are the justifications:

+ If we don't add edge $e_i$ to $F_(i-1)$, nothing happens, and since $F_i = F_(i-1) subset T_(i-1)$, we can take $T_i := T_(i-1)$ to be a MST containing $F_i$. If we add $e_i$ to $F_(i-1)$ and $e_i$ is already in $T_(i-1)$, we can also take $T_i := T_(i-1)$. If we add $e_i$ to $F_(i-1)$ but $e_i$ is not in $T_(i-1)$, then we must be more clever since the spanning tree containing $F_i$ changes.
+ $v_i in.not X$ because $e_i in.not F_(i-1)$ and adding $e_i$ does not create a cycle, so there is no way to get from $u_i$ to $v_i$ in $F_(i-1)$.
+ There is only one path from $u_i$ to $v_i$ because $T_(i-1)$ is a tree. The edge of this path crossing the cut is different from $e_i$ because $e_i in.not T_(i-1)$.
+ If we had $delta(X, V without X) inter F_(i-1) != emptyset$ then the connected component $X$ could be extended and would not be maximal.
+ An edge $e_j$ with $j < i$ is either in $F_(i-1)$ (which means it is not in the cut), or it creates a cycle in $F_(i-1)$, but this would require some edge of $delta(X, V without X)$ to be in $F_(i-1)$ (which is impossible).
+ We have $f = e_j$ with $j > i$, which means $c(f) >= c(e_i)$. As a consequence, if we define $T_i := T_(i-1) without {f} union {e_i}$, then we have $c(T_i) = c(T_(i-1)) + c(e_i) - c(f) <= c(T_(i-1))$.
+ $T_(i-1) union {e_i}$ has exactly one cycle containing $e_i$ and $f$, which means removing $f$ preserves the spanning property and the connectedness, while making the subgraph acyclic again.

=== Remarks

Kruskal's algorithm is greedy, but surprisingly it returns an optimal solution! Prim's algorithm is another example of greedy algorithm for the MST: instead of uniting forests, it grows a single tree.

Implementing Kruskal's algorithm is non-trivial: naively checking whether $e_i$ creates a cycle in $F_(i-1)$ would be very inefficient. Standard implementations use a specific data structure called "Union-Find" to store the disjoint forests and merge them.

== Spanning tree polytope

The MST problem can be formulated as a Mixed Integer Linear Program:

$
  min sum_(e in E) c(e) x_e quad "s.t." quad cases(
    sum_(e in E) x_e = |V| - 1,
    sum_(e in E[X]) x_e <= |X| - 1 & quad forall X subset V\, X in.not {emptyset, V},
    x_e in {0, 1} & quad forall e in E
  )
$

Given an optimal solution $x^*$ to this program, we can construct a subgraph $(V, E_(x^*))$ with $E_(x^*) = {e in E: x_e^* = 1}$.

The second constraint imposes the absence of cycle among any subset of the vertices, which ensures we have a forest. The first constraint tells us that the forest is maximal, i.e. a (spanning) tree. The objective function ensures minimality of the weight.

However, this MILP is not easy to solve, for two reasons:

- The integrality constraint $x_e in {0, 1}$. This is addressed by Theorem 4.4: we can replace the constraint by $x_e >= 0$ and still be sure that basic optimal solutions (returned by the simplex) are binary-valued.
- The exponential number of constraints. This is taken care of by Exercise 4.4, which shows how to decide efficiently whether any constraint is broken. Counterintuitively, this means we can solve the LP efficiently, at least in theory.

_Exercise 4.4: The separation problem for the spanning tree polytope is polynomial. For Q2, we assume a feasible solution $x$ is given._

- _Given a set of vertices $X$, show that we can find a cut $phi(X)$ with capacity $|X| + sum_(e in.not E(X)) x_e$._
- _Given a minimum cut $B$ on the graph defined Q1, show that we can find a cut $B'$ of the same capacity and a set of vertices $X$ such that $B' = phi(X)$._

In the standard setting, there is no need for this LP since Kruskal's algorithm is faster. However, it is very useful when additional constraints or objectives are involved.

= Introduction to complexity theory

See the introduction class for the intuitive definitions of "problem" and "algorithm".

There are undecidable problems, such as the halting problem (deciding whether an algorithm will terminate or not on a given input). Here we focus on decidable problems and study their complexity.

== Decision and optimisation problems

Formally, anything we can give to a computer can be described as a word $x$ from a language $X$. A decision problem is a couple $(X, Y)$ where

- $X$ is a language called the input ("decidable" in polynomial time)
- Its elements $x in X$ are called instances
- $Y subset X$ contains all instances for which the answer is "yes"
- $X without Y$ contains all instances for which the answer is "no"

A solution algorithm is a function $f: X -> {mono("yes"), mono("no")}$ such that $f(Y) = {mono("yes")}$ and $f(X without Y) = {mono("no")}$. The algorithm $f$ runs in polynomial time if there is a polynomial $P$ such that its number of steps in its execution on instance $x$ can be bounded by $P(mono("size")(x))$. Here $mono("size")(x)$ is the length of the word $x$ in binary (example: integer factorization).

== Complexity classes

=== Why is it important?

The complexity class determines the method we can try:

- Fast exact algorithms for "easy" problems
- Fast approximate or heuristic algorithms for "hard" problems

#align(center, table(
  columns: 2,
  align: center,
  table.header[Easy][Hard],
  [Eulerian cycle], [Hamiltonian cycle],
  [Shortest path], [Longest path],
  [2-SAT], [3-SAT],
  [Minimum spanning tree], [Steiner tree],
  [Train shunting (night)], [Train shunting (day)],
))

=== The classes $bold("P")$ and $bold("NP")$

The class $bold("P")$ contains all decision problems for which there is a polynomial algorithm that returns a solution.

The class $bold("NP")$ (for "Nondeterministic Polynomial") contains all decision problems for which there is a polynomial algorithm that verifies a solution, using a so-called certificate. We don't need to be able to generate a certificate in polynomial time, just to check it against the instance.

_Exercise: prove that $bold("P") subset bold("NP")$._

Remarks:

- Why polynomial time (Cobham's thesis)? Independent of the underlying computer model.
- Not independent of the encoding: binary vs unary.
- Why no mention of memory? On a Turing machine, memory is bounded by time.

_Exercise: Devise a dynamic programming algorithm for the knapsack problem. Is it enough to prove that this problem is in $bold("P")$?_

=== $bold("NP")$-completeness

A reduction of a problem $P = (X, Y)$ to $P' = (X', Y')$ is a mapping $r: X -> X'$ such that $x in Y <==> r(x) in Y'$. The reduction is called polynomial if $r$ can be computed in polynomial time.

A decision problem $P$ is $bold("NP")$-complete if

+ $P$ is in $bold("NP")$
+ Any decision problem $P'$ in $bold("NP")$ reduces polynomially to $P$

Since mathematicians have already compiled a large list of $bold("NP")$-complete problems, to prove the second point we only need to reduce a known $bold("NP")$-complete problem to $P$.

A decision or optimisation problem is $bold("NP")$-hard if any decision problem $P'$ in $bold("NP")$ reduces polynomially to $P$.

=== The 1M dollar hypothesis

One of the seven Millenium Prize Problems listed by the Clay Mathematics Institute. Still unsolved, although no one expects $bold("P")$ to be equal to $bold("NP")$.

If $bold("P") != bold("NP")$, then both $bold("P")$ problems and $bold("NP")$-complete problems are proper subsets of $bold("NP")$ problems, which is itself a proper subset of $bold("NP")$-hard problems. More surprisingly, this would also mean that there are some problems which are neither polynomial nor $bold("NP")$-complete (graph isomorphism).

There are many more complexity classes with exotic properties: feel free to visit the #link("https://complexityzoo.net/Complexity_Zoo")[complexity zoo] if you want to have a laugh.

=== Optimisation problems

If we can solve the optimisation problem

$ min_x c(x) quad "s.t." quad x in X $

we can solve its decision version

$ exists ? thin x quad "s.t." quad x in X quad "and" quad c(x) <= c_0 $

To prove that an optimisation problem $O$ is $bold("NP")$-hard, it is enough to reduce a known $bold("NP")$-complete decision problem to its decision version $op("dec")(O)$.

_Exercise: Prove that the shortest path problem is $bold("NP")$-hard in the general case. To do that, use a reduction from Hamiltonian path to longest simple path, followed by a second reduction from longest simple path to shortest simple path._

_Exercise: The 3-SAT problem can be described as follows:_

- _Input: A boolean formula $F(x)$ on $n$ binary variables $x_1, ..., x_n$ in conjunctive normal form (i.e. a conjunction $and = mono("AND")$ of $or = mono("OR")$ clauses) with at most three literals by clause (a literal can be $x_i$ or $not x_i$). Example: $F(x) = (x_1 or not x_2 or not x_3) and (not x_1 or x_2 or x_3) and (x_1 or x_2 or x_3)$._
- _Output: $mono("yes")$ if there is an $x in {0, 1}^n$ satisfying $F$, and $mono("no")$ otherwise._

_By the Cook-Levin theorem, 3-SAT is NP-complete. Show that this implies the maximum clique problem is NP-hard. Starting with an instance of 3-SAT, you can build an instance of CLIQUE using the graph shown on the Wooclap slide._
