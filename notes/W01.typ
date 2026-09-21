#set document(
  title: "Introduction to operations research",
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

= Course logistics

== About me

Hi, I'm #link("https://gdalle.github.io/")[Guillaume Dalle], a researcher in applied mathematics at #link("https://www.lvmt.fr/")[LVMT].
I work on various topics related to operations research, machine learning and high-performance computing, with applications to transport and logistics.

The easiest way to contact me is my academic email #link("mailto:guillaume.dalle@enpc.fr")[`guillaume.dalle@enpc.fr`] or the Microsoft Teams messaging app.
I will answer quickly unless we're outside of office hours, in order to preserve your personal life and mine.
You can also come visit me in room A409 of the Bienvenüe building at École des Ponts, just remember to schedule it with me beforehand.

== Resources

- Course website on #link("https://educnet.enpc.fr/course/view.php?id=1215")[Educnet].
- The website for #link("https://gdalle.github.io/REOP2026/")[this group].

== Rules

- Be respectful towards your classmates and teacher: listen when they speak, raise your hand, etc.
- Arrive on time, send me an email if you can't.
- Feel free to ask me if you have any problems with this course.
- Language should not be an issue: English or French is fine with me.

== LLM policy

My two golden rules are the following:

1. Don't use an LLM to mediate or replace communication with a human.
2. Don't use an LLM in a way that threatens your skill-building.

About rule 1: the goal of the class is not just to impart knowledge, but to communicate some of the passion and excitement I feel about the subject.
There is a community aspect to mathematics which is precious to me, and I want to encourage it by fostering live interactions with students.
That is also why I chose to teach on the blackboard, instead of presenting slides.
Thus, when we're together in class, there should be no reason to ask an LLM: I would much rather have you ask me whenever something is unclear.
And if you send me an LLM-written email, I won't even bother reading it.

About rule 2: LLMs have become impressive tools for science, but learning requires friction.
If you don't work to understand the ideas/math/code presented here, you won't even be able to supervise a robot doing the ideas/math/code.
Therefore, no part of this course will _require_ LLM assistance, because the priority is building _your_ skills.
At home, you may still use an LLM _if you want_, to further your understanding or assist with the project.
Then it becomes your responsibility to ensure that (a) you understand the entire output and (b) given enough time, you could have obtained the same result yourself.

== Grading

- 50%: in-class written exam (pen and paper)
- 50%: oral presentation of your work during the class project (no written report)

= Basics of optimization

== Problems

An optimization problem $cal(P)$ is a family of inputs + a question to answer.
For a decision problem, the answer is either `yes` or `no`
For an optimization problem, we seek the best candidate among a family.

An optimization problem is often formulated as

$ min_x c(x) quad "s.t." quad x in cal(X) $

- "s.t." means "subject to"
- $x$ is the decision variable
- $cal(X)$ is the set of feasible solutions
- $x in cal(X)$ is the set of constraints
- $c(x)$ is the criterion / objective / cost function

Solving the problem means finding the optimal value $op("val")(P)$, and if possible, an optimal solution $x^* in op("argmin") {c(x) : x in cal(X)}$.

An instance $cal(I)$ of a problem is one particular input with its numerical values.

== Algorithms and heuristics

An algorithm $cal(A)$ is a sequence of elementary operations that can be implemented on a computer.

Time complexity $f(n)$ of an algorithm $cal(A)$ = number of elementary operations necessary with input of size $n$.
Polynomial algorithms are usually considered efficient, while exponential algorithms scare many researchers (not us).

There are several types of optimization algorithms:

- Exact algorithms: yield an optimal solution
- Approximation algorithms: yield a solution with bounded sub-optimality
- Heuristics: yield a solution with no guarantee at all

Local descent enables us to explore large solution spaces with small movements.
Typical algorithm: given the current solution $x_k$

+ Compute and explore its neighborhood $cal(N)(x_k)$
+ Pick a next solution $x_(k+1) in cal(N)(x_k)$ such that $c(x_(k+1)) < c(x_(k))$

How to evaluate the quality of a solution without a certificate of optimality? Compare its value $c(x)$ with a lower bound $ell <= op("val")(P) <= c(x)$

== Goals of the class

TBD

= Basics of graph theory

== Vocabulary

A graph $G = (V, E)$ is composed of:

- a set $V$ of vertices, often called $u$ or $v$, with $abs(V) = n$
- a set $E$ of edges, often denoted by $e = (u, v)$, with $abs(E) = m$

A subgraph $H$ is a couple $(V' subset V, E' subset E)$.

The degree of a vertex is the number of incidence edges.

The adjacency matrix $A = (A_(u,v)) in {0, 1}^(n times n)$ tells us whether two vertices are linked by an edge.

_Exercise 3.3: powers of adjacency matrices._

== Paths

A path is a sequence of nodes linked by edges. Types of paths:

- simple: no edge is crossed twice
- elementary: no vertex visited twice
- cycle: start vertex = end vertex
- eulerian: crosses all edges once
- hamiltonian: visits all vertices once

== Types of graphs

- undirected: edges are not ordered $(u, v) = {u, v}$
- directed: edges are ordered $(u, v) = u -> v$ (we use the terminology "nodes" and "arcs")
- simple: no duplicate edges or self loops
- complete: simple with all possible edges
- bipartite: split in two parts with all edges in the middle
- connected: all couples of vertices have a path between them
- eulerian / hamiltonian: contains a eulerian/hamiltonian cycle
- forest: contains no cycle
- tree: connected and contains no cycle

A graph is eulerian iff all its vertices have even degree (i.e. an even number of incident edges).

_Exercise 3.5: criterion for Eulerian graphs._

== Zoo of graph problems

=== Colorings and cliques

A coloring is a function $c: V -> NN$ such that two adjacent vertices do not share the same color: if $(u, v) in E$, $c(u) != c(v)$. The minimum number of colors needed to color a graph is its chromatic number $chi(G)$.

A clique is a complete subgraph. The maximum cardinality of a clique is denoted by $omega(G)$.

We have $omega(G) <= chi(G)$.

=== Matchings and covers

A matching is a set of disjoint edges (maximum cadinality $nu(G)$).

A vertex cover is a set of vertices that covers (has a member belonging to) every edge (minimum cardinality $tau(G)$).

We have $nu(G) <= tau(G)$.

=== Stable sets and edge covers

A stable set is a set of vertices such that no two of them are linked to each other (maximum cardinality $alpha(G)$).

An edge cover is a set of edges that covers (has a member incident to) every vertex (minimum cardinality $rho(G)$).

We have $alpha(G) <= rho(G)$.

_Exercise 3.10: stable sets and vertex covers._

= MILP modeling

A Linear Program is an optimization problem with a linear objective and linear constraints:

$ min_(x in RR^n) c^top x quad "s.t." quad A x <= b $

A Mixed Integer Linear Program is an LP where some of the variables are constrained to be integers:

$ min_(x in ZZ^p times RR^(n-p)) c^top x quad "s.t." quad A x <= b $

In theory, solving a MILP is hard.
However:

- they are very useful to model lots of real-life problems
- there are practically efficient solvers that can handle millions of variables if the problem has a certain structure
