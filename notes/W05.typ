#set document(
  title: "Linear Programming",
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

= Heuristics

== General framework

A heuristic is a problem-specific algorithm that returns a solution

- rather quickly
- of decent quality
- without optimality guarantee

How to evaluate it? Mostly experimental.

== Constructive heuristics

Create a solution from nothing.
Often greedy: while solution not complete, add the next most convenient item.

Examples:

- TSP: nearest neighbor, best insertion
- Knapsack: largest value per kg
- Scheduling: earliest deadline

Other constructive heuristics are based on a relaxation.

_Exercise: Vertex cover through ILP rounding. (1) Propose a heuristic to solve the minimum vertex cover from the LP relaxation of its ILP formulation. (2) Prove that this actually yields a 2-approximation algorithm. (3) Turn it into an iterative procedure for vertex addition._

== Local search

Improve a solution with small moves.

Define a neighborhood function $cal(N)(x)$ which lists all solutions that can be attained from $x$ with one move.
In a neighborhood, pick either the first improvement or the best improvement.

Examples:

- TSP: vertex exchange, 2-opt
- Knapsack: exchange 2 items

When the neighborhood is too big: Large Neighborhood Search uses mathematical programming to explore it.

== Metaheuristics

- Iterated local search (random perturbation)
- Variable neighborhood search (increasing radius)
- Simulated annealing (temperature determines acceptance)
- Evolutionary algorithms (analogy with genetics & natural selection)
- Tabu search (avoid last visited solutions)

== Practical considerations

- Solution encoding & evaluation
  - make small changes easy to apply and evaluate
- Handling constraints:
  - reject infeasible solutions
  - penalize infeasible solutions
  - repair them

= Modeling with linear functions

== Polyhedra

A polyhedron $P$ is a finite intersection of closed half-spaces:

$ P = inter.big_(i in [m]) {x in RR^n: a_i x <= b_i} = {x in RR^n: A x <= b} $

Here the inequality $A x <= b$ must be understood entrywise.

A polytope is a bounded polyhedron.

We say that $x in P$ is a vertex (or extreme point) of the polyhedron if $x$ cannot be written as a non-trivial mean of two other points of $P$:

$ x = (y + z) / 2 quad "with" quad y, z in P quad ==> quad y = z = x $

== Linear optimization problems

A Linear Program is an optimization problem with linear objective and affine constraints:

$ min_(x in RR^n) c^top x quad "s.t." quad A x <= b quad <==> quad min_(x in P) c^top x $

In standard form, it is written

$ min_x c^top x quad "s.t." quad A x = b, x >= 0 #h(4em) "(LP)" $

and we assume without loss of generality that $op("rank")(A) = m <= n$ (no redundant constraints).

_Exercise (Meunier - PL1): Prove that both forms above are equivalent._

A base $B subset [n]$ is a subset of $m$ linearly independent columns of $A$: the submatrix $A_B = (a_(i,j))_(i in [m], j in B)$ is nonsingular. Every base defines a basic solution of (LP)

$ x = vec(x_B, x_N) quad "with" quad cases(x_B & = A_B^(-1) b, x_N & = 0) $

which is called basic feasible if $A_B^(-1) b >= 0$.

== Where to find an optimum?

*Theorem* (Interpretation of bases): $x$ is a basic feasible solution of (LP) iff it is a vertex of the polyhedron $P$.

_Proof:_

- Suppose $x$ is a feasible basic solution. There is a basis $B$ such that $x_B = A_B^(-1) b >= 0$ and $x_N = 0$. In addition, since $A y = A_B y_B = b$ we see that $y_B = A_B^(-1) b = x_B$ and the same goes for $z_B$. Therefore, $y = z = x$.
- Now suppose that $x$ is a vertex of $P$. Let $K = {j in [n]: x_j > 0}$. Let $d_K in ker A_K$ and $d in RR^n$ equal to $d_K$ on $K$ and equal to $0$ elsewhere. Then for $epsilon.alt > 0$ small enough, $x plus.minus epsilon.alt d in P$, which means that $d = 0$. Thus $A_K$ has independent columns, and since $op("rank") A = m$, $K$ can be completed into a set $B$ of size $m$ such that $A_B$ is invertible. As a consequence, $B$ is a basis and $x = (x_B, x_N)$ with $x_N = 0$ and $x_B = A_B^(-1) b >= 0$.
#h(1fr) $qed$

*Theorem* (Existence of an optimum): If $P != emptyset$ and $inf_(x in P) c^top x > -infinity$, then (LP) has an optimal solution.

_Proof_ (for the bounded case):
If $P$ is a polytope, $P$ is compact and the result follows.
#h(1fr) $qed$

*Theorem* (Optimal basis): If (LP) has an optimal solution, then at least one of the optimal solutions is basic (feasible).

_Proof_ (for the bounded case):
We admit the Minkowski-Weyl theorem (every polytope is the convex hull of its vertices). Let $x$ be an optimal solution of (LP), then $x = sum_k lambda_k v_k$ where the $v_k$ are the vertices of $P$ and the $lambda_k >= 0$ sum to $1$. By concavity of $x |-> c^top x$, we know that $c^top x >= sum_k lambda_k (c^top v_k)$, hence there is a $k$ such that $c^top x >= c^top v_k$. Then $v_k$ is an optimal solution, and it is basic feasible.
#h(1fr) $qed$

_Exercise (Meunier - PL6): Computing sums of order statistics. For any vector $x in RR^n$, we denote by $x^([i])$ the $i$-th largest element of the set ${x_1, ..., x_n}$. For instance, $x^([1])$ is the largest component of $x$, and $x^([n])$ is the smallest._

+ _Let $A in RR^(m times n)$ and $b in RR^m$. We fix an integer $k in [n]$. Show that the problem_
  $ min sum_(i=1)^k x^([i]) quad "s.t." quad A x = b, x in RR_+^n $
  _can be formulated as a Linear Program. Hint: introduce one constraint per subset $S subset [n]$ of size $k$._
+ _(Harder) Show that there is a formulation with at most $m + n$ constraints._

= Solution algorithms for LPs

Naive algorithm: enumerate all bases, discard the infeasible ones and compare the feasible ones. Unfortunately, this method has exponential runtime.

== Simplex algorithm

=== General idea

Starting from a given vertex, try to find one of its neighbors with smaller cost. The way we choose the neighbor is called a pivot rule.

*Theorem*: There exists a pivot rule such that the simplex doesn't cycle.

To find the initial vertex, we run a first simplex on an auxiliary problem which is easier to initialize.

=== Reduced costs

Going from one vertex to the next is like going from one basis to the next. We can rewrite the constraints of (LP) by decomposing $x$ along the current basis $B$:

$ A x = b <==> A_B x_B + A_N x_N = b <==> x_B = A_B^(-1) (b - A_N x_N) $

Starting from $B$, we rewrite the objective as:

$
  c^top x & = c_B^top x_B + c_N^top x_N \
  & = c_B^top (A_B^(-1) (b - A_N x_N)) + c_N^top x_N \
  & = underbrace(c_B^top A_B^(-1) b, #[cost of the \ basic solution]) + underbrace((c_N - A_N^top (A_B^(-1))^top c_B)^top, "reduced cost" r_N^top) x_N \
  & = op("cost")(op("sol")(B)) + r_N^top x_N
$

*Proposition* (Role of the reduced cost): If $r_N >= 0$, then $B$ is an optimal basis. Otherwise, we can decrease the objective value by increasing $x_j$ where $j in N$ is such that $r_j < 0$. This either leads to a new basis $B' subset B union {j}$ or to a direction of unboundedness.

== Ellipsoid and interior point methods

The simplex is efficient in practice, but has exponential worst-case running time for all known pivot rules. Other methods, discovered much later, have a much better theoretical complexity (polynomial even in the worst case): ellipsoid algorithm, interior point algorithms.

In particular, the ellipsoid algorithm runs in polynomial time even with an exponential number of constraints, as long as the separation problem can be solved efficiently.

= Lagrangian duality

*Proposition* (Expression of the dual): The dual of the Linear Program in standard form (LP) is:

$ max_(y in RR^m) b^top y quad "s.t." quad A^top y <= c #h(4em) "(LPD)" $

_Exercise: Prove it._

_Proof:_ The Lagrangian for (LP) writes:

$ cal(L)(x, lambda, mu) = c^top x + lambda^top (b - A x) + mu^top (-x) $

where $lambda in RR^m$ and $mu in RR_+^n$ are Lagrange multipliers associated with each constraint. The dual problem is defined as

$ max_(lambda, mu >= 0) underbrace(min_(x in RR^n) cal(L)(x, lambda, mu), "dual function" g(lambda, mu)) $

#h(1fr) $qed$

*Theorem* (Weak duality): We always have $op("val")("LPD") <= op("val")("LP")$.

*Theorem* (Strong duality in Linear Programming): If either (LP) or (LPD) has a feasible solution, then the values of both problems are equal.

_Proof:_ Based on the termination of the simplex algorithm and a correspondence between the final reduced costs & the optimal dual variables $y^* = A_(B^*)^(-1) b$.
#h(1fr) $qed$

*Proposition* (Complementary slackness): Let $x$ and $y$ be feasible solutions of the primal and the dual respectively. Then $x$ and $y$ are both optimal solutions iff

$ (c - A^top y)^top x = 0 quad "and" quad y^top (b - A x) = 0 $

_Proof:_ Once we note that
$
  y^top (b - A x) <= 0 <= x^top (c - A^top y)
$
the result follows directly from strong duality.
#h(1fr) $qed$

Remark: The dual variables have an economic interpretation. In the standard form LP, we replace the constraint $A x = b$ by $A x = b + epsilon$, then the value of the problem will change by approximately $-(y^*)^top epsilon$, where $y^*$ is the optimal dual solution.

= Total unimodularity

== When MILPs become easy to solve

A polyhedron $P$ is integral if $P = op("conv")(P inter ZZ^n)$. In particular, all its vertices have integer coordinates, which means that

- any LP with $P$ as feasible set has one integral optimal solution
- the simplex algorithm finds such a solution

This implies that solving a MILP is just as easy as solving its continuous relaxation.

== Total Unimodularity

A matrix $A$ is Totally Unimodular (TU) if the determinant of all its square submatrices (obtained by removing rows and/or columns) is in ${-1, 0, 1}$. In particular, all of its coefficients must be in ${-1, 0, 1}$ too.

*Theorem* (Importance of TU matrices): If $A$ is TU and $b in ZZ^m$, then $P = {A x = b, x >= 0}$ is integral.

_Proof:_ For any vertex $x$ of $P$, there is a basis $B$ such that $x$ is the basic feasible solution associated with $B$. This implies that $x_N = 0$ and $x_B = A_B^(-1) b >= 0$. Since $A$ is TU and $A_B$ is invertible, the determinant of $A_B$ is in ${-1, 1}$. By the comatrix formula, $A_B^(-1) = 1/(det A_B) op("com")(A_B)^top$, which means $A_B^(-1)$ has integer coefficients. Since $b$ does too, we conclude that $x in ZZ^n$.
#h(1fr) $qed$

*Proposition* (Poincaré criterion for TU): Let $A in {-1, 0, 1}^(m times n)$. If $A$ contains at most one $1$ and one $-1$ per column, then $A$ is TU.

_Proof:_ By recursion.
#h(1fr) $qed$

*Corollary* (Integrality of the flow polyhedron): The incidence matrix of a directed graph is TU.

How to build new TU matrices? If $A$ is TU, then the following matrices are too: $A^top$, $-A$, $(A, plus.minus A)$, $(A, e_j)$, any matrix obtained multiplying a row or column of $A$ by $-1$.

= Homework

_Exercise: Prove that min cut is the dual of max flow._

_Exercise (Meunier - course notes): Nash equilibria in zero-sum games_
