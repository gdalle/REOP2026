#set document(
  title: "Shortest paths",
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

== Exercise 3.3

In the adjacency matrix, $A_(u,v) = 1$ iff there is an edge between $u$ and $v$. Therefore,

$ A^2_(u,v) = sum_(w in V) A_(u,w) A_(w,v) = sum_(w in V) bold(1)(u -> w -> v "exists") = "nb of paths" u -> w -> v $

We can prove recursively that $A^k_(u,v)$ is the number of paths of length $k$ from $u$ to $v$.

== Exercise 3.5

Suppose $G$ is connected and undirected.

If $G$ is a Eulerian graph, then it has a Eulerian cycle (containing every edge exactly once). Each vertex $v$ appears in this cycle a certain number $k_v >= 1$ of times (not $0$). This means that $op("deg")(v) = 2 k_v$.

If every vertex has even degree, we can construct the Eulerian cycle. Start from any vertex $v_1$ and iteratively pick uncrossed edges until you are stuck. You will necessarily be stuck in $v_0$ again because the even degree of the vertices implies that for every way in there is a way out. If there is a vertex $u$ on the cycle that has uncrossed incident edges, start a new cycle from $v_2 = u$ and join it with the previous one. This allows us to cross all edges of the connected component.

== Exercise 3.10

$S$ be a stable iff

- no edge has both its endpoints in $S$
- every edge has at least one endpoint in $V without S$
- $V without S$ is a vertex cover

$S$ is the largest stable set in $G$ iff $V without S$ is the smallest vertex cover. Hence $alpha(G) = abs(S) = abs(V) - abs(V without S) = abs(V) - tau(G)$.

= Shortest path problem

== Statement

*Input*:

- a directed graph $D = (V, A)$
- a cost function $c : A -> QQ$
- two vertices $o$ and $d$

*Output*: an $o -> d$ path $P$ of minimum cost $c(P) = sum_(a in P) c(a)$ (or a proof that none exists because $o$ and $d$ are not connected)

We denote by $c(v)$ the cost of a shortest $o -> v$ path.

In cases where the problem is not well-defined (example: all weights are negative), we will ask for the shortest _simple_ or _elementary_ path instead.

== Integer Programming formulation

*Reminders*

A Linear Program is an optimization problem with a linear objective and linear constraints:

$ min_(x in RR^n) c^top x quad "s.t." quad A x <= b $

A Mixed Integer Linear Program is a LP where some of the variables are constrained to be integers

$ min_(x in ZZ^p times RR^(n-p)) c^top x quad "s.t." quad A x <= b $

In theory, solving a MILP is hard. However:

- they are very useful to model lots of real-life problems
- there are practically efficient solvers that can handle millions of variables if the problem has a certain structure

*Formulation*

Let $x_(u,v)$ be a binary variable equal to $1$ if edge $(u, v)$ is part of the path we choose, and $0$ otherwise.

The shortest _elementary_ path problem can be stated as:

$ min_x sum_((u,v) in A) c(u, v) x_(u,v) quad "s.t." quad x in {0, 1}^A "defines an" o -> d "path" $

The constraint "$x$ defines an $o -> d$ path" can be expressed linearly: if a vertex $v$ different from $o$ and $d$ is visited, then it needs one incoming edge and one outgoing edge:

$
  forall v in V, quad sum_(u in cal(N)^-(v)) x_(u,v) - sum_(w in cal(N)^+(v)) x_(v,w) = cases(0 "if" v eq.not o\, d, -1 "if" v = o, 1 "if" v=d)
$

== Complexity

*Theorem*: The shortest path problem is NP-complete in the general case.

*Proof*:

- Reduction from Hamiltonian path to longest simple path
- Reduction from longest simple path to shortest simple path

*Polynomial cases*:

- Unweighted graph: Breadth-First Search
- Acyclic graphs:
  - Undirected: forest (at most $1$ path between each pair)
  - Directed: topological sorting
- Nonnegative costs
  - Directed & undirected: Dijkstra's algorithm
- No negative / absorbing cycles
  - Directed: Bellman-Ford
  - Undirected: T-joints

#align(center, table(
  columns: 3,
  align: center,
  table.header[Algorithm][Naive complexity][Best complexity],
  [Topological sorting], $O(m+n)$, $O(m+n)$,
  [Dijkstra], $O(n^2)$, $O(m + n log n)$,
  [Bellman-Ford], $O(m n)$, $O(m n)$,
))

== Dynamic programming

Underlying idea: Bellman's optimality principle

_A subtrajectory of an optimal trajectory is itself optimal._

Generalize the problem to derive a recursion called the Bellman equation. Usually done by changing the bounds or adding parameters.

Knapsack example $=>$ IP formulation, DP algorithm.

First compute the value of a solution. It is usually easy to go back to the minimizer by working your way backwards.

== Shortest path variants

*Various flavors*:

- Single source $o$, multiple destinations: the one studied here
- Single source $o$, single destination $d$: almost as hard
- Multiple sources, multiple destinations: harder

*Extensions*:

- Shortest paths with resource constraints (A. Parmentier's thesis)
- Multi-criteria shortest paths
- Shortest paths on transportation networks: timed trips, multiple modes (Bast et al., 2016, "Route Planning in Transportation Networks")

== Modeling examples

#quote[Exercise 5.12: disjoint intervals and profitable rentals]

= Solution algorithms

== Directed graphs with no absorbing cycles

=== Bellman principle

*Proposition 5.2*:

Let $P$ be an $o -> v$ path with $k$ arcs and $Q$ be an $o -> u$ path, where $u$ is the vertex before $v$ on $P$. If $P$ is a shortest $o -> v$ path among those with $k$ arcs, then $Q$ is a shortest $o -> u$ path among those with $k-1$ arcs.

*Proof*:

- Suppose there is another $o -> u$ path $Q'$ with $k-1$ arcs such that $c(Q') < c(Q)$.
- $P' = Q' union (u, v)$ is an $o -> v$ path with $k$ arcs.
- $P'$ has a cost $c(P') = c(Q') + c(u, v) < c(Q) + c(u, v) = c(P)$.

=== Bellman-Ford algorithm

The length of a shortest $o -> v$ path satisfies the Bellman equation

$ c(v, k) = min_(u in N^-(v)) c(u, k-1) + c(u, v) $

with initial conditions

$ c(v, 0) = cases(0 "if" v = o, -infinity "otherwise") $

We can compute its values starting from $k=0$. But when do we stop? Since $D$ has no negative cycles, there is a simple shortest path of length at most $n-1$. We compute $c(v, k)$ for all $v in V$ and $k in [0, n]$, and then pick $k$ minimizing $c(d, k)$.

By remembering, for each $v$, the in-neighbor $u$ that achieved the minimum, we can build a shortest-path tree.

== Directed Acyclic Graphs (DAGs)

=== Bellman principle

*Proposition 5.4*:

Let $D$ be a DAG, $P$ be an $o -> v$ path ending with edge $(u,v)$, and $Q$ be an $o -> u$ path. If $P$ is a shortest $o -> v$ path, then $Q$ is a shortest $o -> u$ path.

*Proof*:

- Suppose there is another $o -> u$ path $Q'$ such that $c(Q') < c(Q)$.
- $P' = Q' union (u, v)$ is an $o -> v$ path.
- $P'$ has a cost $c(P') = c(Q') + c(u, v) < c(Q) + c(u, v) = c(P)$.

*Recursive equation*

The length of a shortest $o -> v$ path satisfies the Bellman equation

$ c(v) = min_(u in N^-(v)) c(u) + c(u, v) quad "and" quad c(o) = 0 $

*Problem*: in which order do we enumerate the vertices? The constraint is that we must compute $c(u)$ before $c(v)$ if there is an edge $(u, v)$ in $A$.

=== Topological ordering

A digraph $D = (V, A)$ is acyclic iff there exists a total order $prec.eq$ (i.e. a numbering of the vertices) such that $(u, v) in A => u prec.eq v$.

We define the operation $op("DFS")(v)$ (Depth-First Search) as follows:

+ open $v$ (put in $S$)
+ scan its children
+ close $v$ (put in $L$)

This recursive definition is consistent since the graph has no cycles.

If we add a dummy vertex which has all the "orphan" nodes as children, we can consider the case with only one orphan node $o$. Then, this procedure is equivalent to applying $op("DFS")(o)$.

Reversing the order in which vertices are closed yields a topological sort, since children are always closed before their parents.

== Directed graphs with nonnegative costs

=== Dijkstra's algorithm

*Pseudocode*:

Input: a digraph $D = (V, A)$ and costs $c in QQ_+^A$.

+ Set $U = emptyset$ (set of visited vertices)
+ Set $lambda(v) = 0$ if $v = o$ and $lambda(v) = +infinity$ otherwise (initialize labels)
+ While $V without U eq.not emptyset$:
  + Choose $v in V without U$ such that $lambda(v) = min_(v' in V without U) lambda(v')$ (choose the closest unvisited vertex according to the label)
  + Add $v$ to $U$ (visit it)
  + Set $lambda(w) = min{lambda(w), lambda(v) + c(v, w)}$ for all $w in N^+(v)$ (update neighbor labels)

Output: the vector $lambda$ which contains all distances $o -> v$

*Proposition*: (Values of the tentative distance)

- For all $u in U$, $lambda(u) = c(u)$
- For all $w in V without U$, $lambda(w) = min_(u in U) c(u) + c(u, w) >= c(w)$

*Proof*: Make a drawing!

Since they hold after initialization, we must only check that these properties are preserved by the loop.

Let $v$ be the closest vertex according to the tentative distance, i.e. the one achieving $min_(v' in V without U) lambda(v')$.
By property 2, $lambda(v) = min_(u in U) c(u) + c(u, v')$, so let $u$ be the minimizer there.

Consider any other path from $o$ to $v$. Let $v'$ be its first vertex outside of $U$, and $u'$ the one before that.

The path $o ~> u ~> v$ has cost $c(u) + c(u, v) = lambda(v)$. The path $o ~> u' ~> v'$ has cost $c(u') + c(u', v') = lambda(v') >= lambda(v)$. The remaining path $v' ~> v$ has strictly positive cost. Hence $o ~> v' ~> v$ is not better.

Therefore, $lambda(v) = c(v)$ and the first property is preserved. The second property is easier to verify.

=== A\* algorithm

Idea: speed up Dijkstra using a heuristic $h(v)$ to lower-bound the remaining distance $v -> d$.

Procedure: grow a set of paths and trim the ones that are hopeless.

Special case of Branch & Bound and LP duality.

Essential in transportation networks because the graphs are large but we have an idea of where to go.

== Dynamic Programming for MDPs

See course notes

Talk about my internship at EDF on the optimization of cleaning schedules for photovoltaic solar panels

== Exercises

#quote[Exercise 5.19: longest common subword]

#quote[Exercise 5.20: Held-Karp algorithm for the TSP]
