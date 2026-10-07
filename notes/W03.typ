#set document(
  title: "Flows",
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

= Homework solutions

== Longest common subword

_Exercise 5.19_

As usual in dynamic programming, we generalize the problem. Let us try to compute the length $ell(i, j)$ of the longest common subword of $w_1 [1:i]$ and $w_2 [1:j]$. There are several cases to consider:

+ The end letters of both words are identical: $ ell(n_1, n_2) = 1 + ell(n_1-1, n_2-1) $
+ The end letters of both words are different: $ ell(n_1, n_2) = max{ell(n_1-1, n_2), ell(n_1, n_2-1)} $

That way, we get the recursive Bellman equation. The initialization is done with $ ell(n_1, 0) = ell(0, n_2) = 0 $

== Held-Karp algorithm for the TSP

_Exercise 5.20_

1. We fix a source vertex $s in V$ and use $(X, v)$ as the state, with $X subset V backslash {s}$ and $v in V backslash X$. Let $ell(X, v)$ be the length of the shortest tour starting at $s$, going through all the vertices of $X$ and ending at $v$. We initialize $ell(emptyset, v) = c(s, v)$ and write the Bellman equation:
$ ell(X, v) = min {ell(X backslash {v}, u) + c(u, v) : u in X backslash {v}} $
2. A naive algorithm would evaluate $n!$ solutions. We can do slightly better by fixing a starting vertex (divides complexity by $n$) and ignoring reflected tours (divides complexity by $2$). The final enumeration still costs $(n-1)!/2$.

= Flow vocabulary

== Flows from a source to a target

We consider a digraph $D = (V, A)$ with additional features:

- nonnegative upper capacities $u(a) >= 0$ on each arc
- two special nodes: a source $s$ and a target $t$

An $s$-$t$ flow under $u$ is a vector $f in RR^A$ satisfying Kirchhoff's current law

$ forall v in V without {s, t}, quad sum_(a in delta^-(v)) f(a) = sum_(a in delta^+(v)) f(a) $

and capacity constraints

$ forall a in A, quad 0 <= f(a) <= u(a) $

The value of an $s$-$t$ flow $f$ is the total quantity flowing out of the source:

$ op("val")(f) = sum_(a in delta^+(s)) f(a) - sum_(a in delta^-(s)) f(a) $

Maximum flow problem: Find an $s$-$t$ flow under $u$ of maximum value $op("val")(f)$.

== Cuts between a source and a target

An $s$-$t$ cut $(S, T)$ is a partition $V = S union T$ of the vertices into disjoint subsets ($S inter T = emptyset$) such that $s in S$ and $t in T$.
It can be viewed as a set of arcs $B = delta^+(S)$ intersecting any $s$-$t$ path.

The capacity of a cut is the sum of the capacities of its arcs:

$ u(S, T) = sum_(i in S \ j in T \ (i,j) in A) u(i,j) quad "or" quad u(B) = sum_(a in B) u(a) $

Minimum cut problem: Find an $s$-$t$ cut of minimum capacity $u(B)$

== Flows with arbitrary inputs and outputs

For this setting we consider a digraph $D = (V, A)$ with slightly different features:

- lower and upper capacities $0 <= ell(a) <= u(a)$ on each arc
- cost values $c(a) >= 0$ on each arc
- algebraic inflows $b(v)$ at each vertex such that $sum_(v in V) b(v) = 0$

A $b$-flow under $(ell, u)$ is a vector $f in RR^A$ satisfying Kirchhoff's current law

$ forall v in V, quad b(v) + sum_(a in delta^-(v)) f(a) = sum_(a in delta^+(v)) f(a) $

and capacity constraints

$ forall a in A, quad ell(a) <= f(a) <= u(a) $

If $b(v) = 0$ everywhere, we call $f$ a circulation.

The cost of a $b$-flow $f$ is the sum of the costs induced by $f$ on each arc:

$ c(f) = sum_(a in A) c(a) f(a) $

Minimum cost flow problem: find a $b$-flow under $(ell, u)$ of minimum cost.

== Modeling examples

_Exercise 6.8: Monge's transportation problem. We have $n$ sand heaps of volume $s_i$ each, and $m$ holes to fill of volume $t_j$ each. The moving cost per cubic meter between heap $i$ and hole $j$ is $d_(i j)$. How do we transport the mass while minimizing total cost?_

The trick is to add a fictitious source $s$ and target $t$.
Also pay attention to the case where there is excess volume on either end.
#h(1fr) $qed$

_Exercise 6.9: bus trip. A bus with capacity $B$ leaves city $1$ and visits cities $2, ..., n$ in order. For each pair $i < j$ of cities, $d_(i j)$ passengers want to make the trip, for a ticket price $p_(i j)$. How many passengers should the driver take in each city to maximize profit?_

= Flow algorithms

== Optimality criterion for maximum flows

Historical context: cold war.

=== Weak duality

*Proposition* (Cuts as upper bounds on flows): Let $0 <= f <= u$ be an $s$-$t$ flow and $(S,T)$ be an $s$-$t$ cut. Then
- the value of the flow is equal to the "net flow $f(S, T)$ across the cut ($S -> T$ minus $T -> S$)
- it is upper-bounded by the capacity of the cut ($S -> T$ only).

_Proof:_
$
  op("val")(f) &= sum_(a in delta^+(s)) f(a) - sum_(a in delta^-(s)) f(a) + sum_(v in S without {s}) (sum_(a in delta^+(v)) f(a) - sum_(a in delta^-(v)) f(a)) \
  &= sum_(a in delta^+(S)) f(a) - sum_(a in delta^-(S)) f(a) = sum_(a in delta(S, T)) f(a) - sum_(a in delta(T, S)) f(a) \
  &= f(S, T) <= sum_(a in delta(S, T)) u(a) - sum_(a in delta(T, S)) 0 \
  &= u(S)
$
#h(1fr) $qed$

=== Residual graph & augmenting paths

For every arc $a = (i, j) in A$, we define a reversed arc $accent(a, arrow.l) = (j, i)$ and the residual capacities (assuming that $accent(a, arrow.l) in.not A$):

$ u_f (a) = u(a) - f(a) quad "and" quad u_f (accent(a, arrow.l)) = f(a) $

In the general case where both directions of an edge can be present, we must use

$ u_f (a) = u(a) - f(a) + f(accent(a, arrow.l)) $

The residual graph is the capacitated graph $D_f = (V, A_f, u_f)$ with

$ A_f = {a in A union accent(A, arrow.l): u_f (a) > 0} $

An $f$-augmenting path is an $s$-$t$ path in the residual graph $D_f$.

To augment $f$ by $gamma$ along an $f$-augmenting path $P$ means performing, for every $a in P$:

- $f(a) <- f(a) + gamma$ if $a in A$
- $f(a) <- f(a) - gamma$ if $a in accent(A, arrow.l)$

=== Strong duality

*Theorem* (Optimality criterion): An $s$-$t$ flow $f$ is maximal if and only if there is no $f$-augmenting path.

_Proof:_
1. If there is an augmenting path $P$, the flow can be augmented along this path (by the minimum residual capacity $min {u_f (a) : a in P}$).
2. If no such path exists, then $s$ and $t$ are separated in the residual graph. Let $S$ denote the connected component of $D_f$ to which $s$ belongs, and $T = V backslash S$. The residual capacity is $u_f (S,T) = 0$, which means that the net flow $f(S, T)$ is equal to the cut capacity $u(S)$ (if an edge across the cut is not properly saturated, this contradicts the disconnectedness of $S$ and $T$). The previous proposition implies that the flow $f$ is maximal and the cut $(S, T)$ is minimal in $D$.
#h(1fr) $qed$

*Theorem* (Max flow / min cut): The maximum value of an $s$-$t$ flow is equal to the minimum value of an $s$-$t$ cut.

== Ford-Fulkerson

=== Pseudocode

Input: a digraph $D = (V, A)$ with capacities $u$, two vertices $s$ and $t$

+ Set $f(a) = 0$ for all $a in A$
+ While there is an $f$-augmenting path:
  + Select an $f$-augmenting path $P$
  + Augment $f$ along $P$ by $min_(a in P) u_f (a)$

Output: a maximum $s$-$t$ flow $f$

Questions:

- How do we find / select an augmenting path?
- Does the algorithm terminate, and if so when?

=== Complexity

Each iteration of the Ford-Fulkerson loop takes $O(|A|)$ time

If the capacities $u$ are integral, so are the flow augmentations.

*Theorem*: If the capacities $u$ are integral, the Ford-Fulkerson algorithm returns an integral maximum $s$-$t$ flow in $O(|A| times op("val")_(max))$ time, where $op("val")_(max)$ is the maximum value of an $s$-$t$ flow.

== Edmonds-Karp

=== Pseudocode

Input: a digraph $D = (V, A)$ with capacities $u$, two vertices $s$ and $t$

+ Set $f(a) = 0$ for all $a in A$
+ While there is an $f$-augmenting path:
  + Select an $f$-augmenting path $P$ _with minimum number of edges_
  + Augment $f$ along $P$ by $min_(a in P) u_f (a)$

Output: a maximum $s$-$t$ flow $f$

Questions:

- How do we select such an augmenting path?
- Why does it improve the complexity?

=== Complexity

The Edmonds-Karp loop is crossed at most $|A| times |V|$ times.

_Proof:_ We can show that

- The (unweighted) distance $op("dist")_(D_f)(s, t)$ in the residual graph is nonincreasing
- It can only remain constant for at most $|A|$ iterations

*Theorem*: The Edmonds-Karp algorithm returns a maximum $s$-$t$ flow in $O(|A|^2 times |V|)$ time.

== Minimum mean cycle-canceling (for minimum cost $b$-flows)

*Pseudocode*

Input: a digraph $D = (V, A)$ with capacities $ell <= u$, costs $c$ and inflows $b$

+ Find an initial $b$-flow $f$
+ While there is an $f$-augmenting cycle with negative cost
  + Select an $f$-augmenting cycle $C$ _with minimum mean cost_
  + Augment $f$ along $C$ by $min_(a in C) u_f (a)$

Output: a minimum cost $b$-flow $f$

Questions:

- How do we find an initial $b$-flow?
- How do we select an $f$-augmenting cycle with minimum mean cost?

*Complexity*

An initial $b$-flow can be found in $O(|A| times |V|)$ time (see Ex 6.4).

An $f$-augmenting cycle of minimum mean cost can be found in $O(|A| times |V|)$ time (see Ex 6.3).

*Theorem 6.10*: The cycle-canceling algorithm returns a minimum cost $b$-flow in $O(|A|^3 |V|^2 log|V|)$ time.

= Linear programming for flows

== Formulation

We can formulate the maximum flow problem as follows:

$
   max_x & quad sum_(a in delta^+(s)) x_a - sum_(a in delta^-(s)) x_a \
  "s.t." & quad sum_(a in delta^-(v)) x_a = sum_(a in delta^+(v)) x_a quad quad forall v in V without {s, t} \
         & quad 0 <= x_a <= u(a) quad quad forall a in A
$

We will prove the following results later in the course:

- The constraint matrix of the max flow LP is "totally unimodular".
- The minimum cut is the "Lagrangian dual" of the maximum flow, up to integrality.

_Exercise: prove this_

The equivalent max-flow formulation

$
  max_(x >= 0, q) & quad q \
           "s.t." & quad sum_(a in delta^+(s)) x_a - sum_(a in delta^-(s)) x_a = q \
                  & quad sum_(a in delta^+(t)) x_a - sum_(a in delta^-(t)) x_a = -q \
                  & quad sum_(a in delta^-(v)) x_a = sum_(a in delta^+(v)) x_a quad quad forall v in V without {s, t} \
                  & quad x <= u
$

has the following dual

$
  min_(y, z) & quad sum_a u_a z_a \
      "s.t." & quad z_a >= y_v - y_w quad quad forall a = (v, w) in A \
             & quad y_s - y_t >= 1 \
             & quad z_a >= 0 quad quad forall a in A
$

where $z_a = 1$ if we select an edge in the cut and $y_v = 1$ if $v in S$. Using binary variables, the first inequality forces $a$ to be in the cut if $v$ and $w$ are in separate connected components.
#h(1fr) $qed$

== Polyhedral interpretation

A general result in polyhedral geometry (the Minkowski-Weyl theorem) states that every polyhedron $P$ can be written as

$ P = {sum_i lambda_i x_i + sum_j mu_j y_j: lambda >= 0, mu >= 0, sum_i lambda_i = 1} $

The flow version of this result is Proposition 6.13: every $s$-$t$ flow can be decomposed as a positive sum of flows along elementary $s$-$t$ paths or elementary cycles.

== Homework

_Exercise 6.12: taxi fleet. A fleet of taxis has $p$ clients to serve on a given day, known in advance. For each client $i$, we know their origin $o_i$, destination $d_i$, departure time $h_i$ and trip duration $t_i$. How to compute the minimum number of taxis necessary to satisfy the demand?_

_Exercise 6.14: consistent rounding. Let $A = (a_(i j)) in RR^(m times n)$ be a matrix. We want to round each entry either up or down to an integer, such that the rounding of each row (resp. column) sum equals the sum of the roundings. Show that this is always possible._
