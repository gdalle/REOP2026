#set document(
  title: "Integer Programming",
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

= Homework

_Exercise: Prove that min cut is the dual of max flow._

We can formulate the maximum flow problem as follows:

$
   max_x & quad sum_(a in delta^+(s)) x_a - sum_(a in delta^-(s)) x_a \
  "s.t." & quad sum_(a in delta^-(v)) x_a = sum_(a in delta^+(v)) x_a quad quad forall v in V without {s, t} \
         & quad 0 <= x_a <= u(a) quad quad forall a in A
$

We will prove the following result later in the course:
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

= Mixed Integer Linear Programs

== The notion of relaxation

A MILP is an LP where some variables are forced to take integer values:

#math.equation(
  block: true,
  numbering: _ => "(P)",
  $min_(x in ZZ^p times RR^(n-p)) c^top x quad "s.t." quad A x <= b$,
)
#counter(math.equation).update(n => n - 1)

The continuous relaxation of a MILP is the LP obtained by removing integrality constraints:

#math.equation(
  block: true,
  numbering: _ => "(R)",
  $min_(x in RR^n) c^top x quad "s.t." quad A x <= b$,
)
#counter(math.equation).update(n => n - 1)

Examples:

- $x in NN$ becomes $x >= 0$
- $x in {0, 1}$ becomes $0 <= x <= 1$

If $x$ is a solution of (P), then it is a solution of (R). As a consequence, $op("sol")(P) subset op("sol")(R)$ and $op("val")(P) >= op("val")(R)$ (because taking the infimum over a smaller set leads to a larger value).

== Naive ideas

Why can't we just solve the relaxation and round the solution to the nearest integer?

- Rounding is hard in high dimension: $2^d$ possibilities
- Sometimes none of the closest integer solutions are feasible
- There can be an arbitrary gap between the value of (R) and the value of (P)

Naive approach:

+ Enumerate all possible assignments of integer variables
+ For each of them, solve the resulting LP
+ Pick the best solution

Unfortunately, this is very inefficient.

== Modeling examples

See _Model Building in Mathematical Programming_ by H. Paul Williams (2013) for very useful tricks in model building.

_Exercise: Given binary variables modeling individual propositions, express the following logical constructs: and, or, implication, equivalence, at most one, exactly two._

_Exercise: Let $x in {0, 1}$ and $y in [0, M]$. Show that the constraint $z = x y$ can be linearized (McCormick linearization)._

_Exercise: Consider a set of $H$ hospitals with reanimation capacity $r_h$ and initial patient load $p_h$. An excess patient in $h$ costs $e_h$, and a patient transfer from $h_1$ to $h_2$ costs $t_(h_1 h_2)$. Formulate a MILP to optimize patient dispatch._

_Exercise: Model facility location as a MILP._

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

= Solution algorithms

== Branch & Bound

Branch & Bound speeds up enumeration by discarding useless cases. It is still exponentially slow in the worst case, but it works very well in practice.

B&B starts by solving the relaxation (R). If the solution $x^*$ has only integer coordinates, bingo, we stop there. Otherwise, we select a fractional coordinate $x_j^*$ and divide the search space by adding one of two constraints: $x_j <= floor(x_j^*)$ or $x_j >= ceil(x_j^*)$. Then we iteratively apply the same procedure to these two smaller MILPs, thus building a binary tree where each node corresponds to a subregion of the search space.

To avoid enumerating all possible assignments, we have pruning techniques:

- Prune by infeasibility: If the relaxation at a node has no continuous solution, then we don't need to keep looking, because there will be no integer solution either in this region of the space.
- Prune by optimality: If the relaxation at a node returns an integer solution, then we don't need to keep looking because we already know the best candidate in this region of the space.
- Prune by bound (the most important): If the relaxation at a node has a value higher than the best solution found so far (in the whole tree), then we don't need to keep looking because no matter what we find in this region of the space, it will be worse than the best candidate we already have.

_Exercise: Modify the B&B algorithm to find a solution with cost at most $(1+g)%$ that of the optimum._

Tuning Branch & Bound is often necessary, and commercial solvers include many complicated heuristics meant to speed up the search. Among the most important design choices, we can list:

- Choice of the variable to branch on
- Choice of the next node to explore

Note that Branch & Bound is a general principle which applies beyond Integer Programming (see course notes for a more abstract formulation of the algorithm).

== Cutting planes

TBC

== Primal heuristics

TBC
