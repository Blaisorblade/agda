\documentclass[11pt]{article}

%include lhs2TeX.fmt
%include lhs2TeX.sty

%if anyMath

%format ~ = "~"

%format .   = ".~"
%format Set = "\Set"
%format Type = "\Type"
%format ==  = "=="
%format **  = "×"
%format :   = "\mathrel{:}"

%format zero = "\mathsf{z}"
%format suc  = "\mathsf{s}"
%format refl = "\mathsf{refl}"

%format === = "\equiv"

%format of_  = "\mathit{of}"

%format iota    = "ι"
%format sigma   = "σ"
%format delta   = "δ"
%format gamma   = "γ"
%format eps     = "ε"

%format eps_I   = "ε_I"

%format inl     = "\mathsf{inl}"
%format inr     = "\mathsf{inr}"

%format bot     = "\bot"

%format Even'   = "\mathit{Even}^{*}"
%format evenZ   = "\mathsf{evenZ}"
%format evenSS  = "\mathsf{evenSS}"
%format evenZ'  = "\mathsf{evenZ}^{*}"
%format evenSS' = "\mathsf{evenSS}^{*}"
%format elim_Even = "elim_{Even}"

%format pi0 = "π_0"
%format pi1 = "π_1"

%format OP  = "\mathit{OP}"
%format OPg = "\mathit{OP}^g"
%format OPr = "\mathit{OP}^r"

%format Fin_n       = "\mathit{Fin}_n"
%format Args_IE     = "\mathit{Args}_{I,E}"
%format index_IE    = "\mathit{index}_{I,E}"
%format IndArg_IE   = "\mathit{IndArg}_{I,E}"
%format IndIndex_IE = "\mathit{IndIndex}_{I,E}"
%format Ind_IE      = "\mathit{Ind}_{I,E}"
%format IndHyp_IE   = "\mathit{IndHyp}_{I,E}"
%format indHyp_IE   = "\mathit{indHyp}_{I,E}"

%format elimUrg     = "\mathit{elim}{-}U^r_γ"
%format elimUreg    = "\mathit{elim}{-}U^r_{εγ}"
%format elimUgg     = "\mathit{elim}{-}U^g_γ"

%format elimId  = "\mathit{elim}_{==}"

%format 1 = "\mathbf{1}"
%format 0 = "\mathbf{0}"
%format star = "\star"

%format < = "\left\langle"
%format > = "\right\rangle"

%format << = "<"
%format =~= = "\cong"

%format Urg     = "U^r_γ"
%format introrg = "\mathrm{intro}^r_γ"

%format Ugg     = "U^g_γ"
%format introgg = "\mathrm{intro}^g_γ"

%format Ureg     = "U^r_{εγ}"
%format introreg = "\mathrm{intro}^r_{εγ}"

%format grArgs = "g{\to}rArgs"
%format grArgs_I = "g{\to}rArgs_I"

%format rgArgs = "r{\to}gArgs"
%format rgArgs_I = "r{\to}gArgs_I"

%format rgArgssubst = "rgArgs{-}subst"
%endif

\usepackage{ucs}
\usepackage[utf8x]{inputenc}
\usepackage{autofe}
\usepackage{color}

\usepackage{amsthm}
\newtheorem{theorem}{Theorem}[section]
\newtheorem{lemma}[theorem]{Lemma}
\newtheorem{corollary}[theorem]{Corollary}
\newtheorem{definition}[theorem]{Definition}

% Enables greek letters in math environment
\everymath{\SetUnicodeOption{mathletters}}
\everydisplay{\SetUnicodeOption{mathletters}}

% This makes sure that local glyph overrides below are
% chosen.
\DeclareUnicodeOption{localDefs}
\SetUnicodeOption{localDefs}

% For some reason these macros need to be defined.
\newcommand{\textmu}{$\mu$}
\newcommand{\textnu}{$\nu$}

% This character doesn't seem to be defined by ucs.sty.
\DeclareUnicodeCharacter{"21A6}{\ensuremath{\mapsto}}

\input{macros}

\title{Encoding indexed inductive types using the identity type}
\author{Ulf Norell}

\begin{document}
\maketitle
\begin{abstract}
    An indexed inductive-recursive definition (IIRD) simultaneously defines an
    indexed family of sets and a recursive function over this family.  This
    notion is sufficiently powerful to capture essentially all definitions of
    sets in Martin-Löf type theory.

    I show that it is enough to have one particular indexed inductive type,
    namely the intensional identity relation, to be able to interpret all IIRD
    as non-indexed definitions.
    
    The proof is formally verified in Agda.
\end{abstract}

\section{Introduction}

% Describe the current state of affairs

Indexed induction recursion is the thing.

% Indentify gap

Dybjer and Setzer~\cite{dybjer:indexed-ir} show that in an extensional theory
generalised IIRD can be interpreted by restricted IIRD~\cite{dybjer:jsl}. We're
not using an extensional theory though.

The main contribution of this paper is to show that generalised IID can be
interpreted using restricted IID and an intensional identity type. This
strengthens the results of Dybjer and Setzer~\cite{dybjer:indexed-ir} who show
that the interpretation is possible in extensional type theory.

\TODO{What's the relation between restricted IIRD and IRD?}

% Fill gap

I improve on this result showing that it is enough to add intensional equality.
The proof is formalised in Agda.

Non-indexed definitions are simpler(?), so if can get away with just adding the
identity type we get simpler meta theory that if we would add indexed
definitions directly.

\section{The Logical Framework}

    Martin-Löf's logical framework~\cite{nordstrom:book} extended with sigma
    types ($\SIGMA x A B$), $\Zero$, $\One$, and $\Two$.

    \TODO{what about $Π$ in Set? Used on the meta level but probably not on the object level.}

    $\HasType {Γ} x A$

    $\IsType {Γ} A$

    $\PI x A B$

    $\SIGMA x A B$

\section{The Identity Type}

There are many versions.

\begin{code}
  ~
  (==)  : {A : Set} -> A -> A -> Set
  refl  : {A : Set}(x : A) -> x == x
  ~
\end{code}

Martin-Löf identity relation, introduced in 1973~\cite{martin-lof:predicative}.

\begin{definition}[Martin-Löf elimination]

The Martin-Löf elimination rule (sometimes called $J$) has the type

\begin{code}
~
elim_ML :  {A : Set}(C : (x, y : A) -> x == y -> Set) ->
           ((x : A) -> C x x (refl x)) ->
           (x, y : A)(p : x == y) -> C x y p
~
\end{code}

and the corresponding computation rule is

> elim_ML C h x x (refl x) = h x

\end{definition}

\begin{definition}[Paulin elimination]
Paulin identity relation~\cite{pfenning-paulin:inductive-coc}.

\begin{code}
~
elim_P :  {A : Set}(x : A)(C : (y : A) -> x == y -> Set) ->
          C x (refl x) -> (y : A)(p : x == y) -> C y p
~
\end{code}

The corresponding computation rule is

> elim_P x C h x (refl x) = h

\end{definition}

\begin{lemma}
    Martin-Löf elimination can be defined in terms of Paulin elimination.
\end{lemma}

\begin{proof}

Trivial.

> elim_ML C h x y p = elim_P x (\z q. C x z q) (h x) y p

\end{proof}

\begin{lemma}
    Paulin elimination can be defined in terms of Martin-Löf elimination.
\end{lemma}

\begin{proof}
    This proof is slightly more involved.

    We first define the substitution rule
\begin{code}
~
    subst :  {A : Set}(C : A -> Set)(x, y : A)
             x == y -> C x -> C y
    subst C x y p Cx = elim_ML  (\ a b q. C a -> C b)
                                (\ a Ca. Ca) x y p Cx
~
\end{code}

    Now define

\begin{code}
~
    E : {A : Set}(x : A) -> Set
    E x = (y : A) ** (x == y)
~
\end{code}

    We can prove that any element of |E x| is in fact equal to |(x, refl x)|.

\begin{code}
~
    uniqE : {A : Set}(x, y : A)(p : x == y) -> (x, refl x) == (y, p)
    uniqE = elim (\ x y p. (x, refl x) == (y, p)) refl
~
\end{code}

\begin{code}
~
    elim_P x C h y p = subst  (\ z. C (pi0 z) (pi1 z))
                              (x, refl x) (y, p) (uniqE x y p) h
~
\end{code}

    Note that in an impredicative setting there is a simpler proof due to
    Streicher~\cite{streicher:habilitation}.

\end{proof}

\begin{theorem}
    Martin-Löf elimination and Paulin elimination are equivalent.
\end{theorem}

Streicher axiom K. Not valid~\cite{HofmannM:gromru}. Fortunately we don't need it.

In the following we will use Paulin elimination.

\section{Indexed Inductive Datatypes} \label{sec-IID}

In this section we present the formalisation of indexed inductive types. We
follow the formalisation of indexed induction recursion of Dybjer and
Setzer~\cite{dybjer:indexed-ir} but leave out the recursion to simplify the
presentation.

\subsection{Codes for IID} \label{sec-IID-Codes}

In accordance with Dybjer and Setzer we introduce a common type of codes which
will serve both as codes for general IID and restricted IID.

\begin{code}
~
data OP (I : Set)(E : Set) where
  iota   : E -> OP I E
  sigma  : (A : Set)(gamma : A -> OP I E) -> OP I E
  delta  : (A : Set)(i : A -> I)(gamma : OP I E) -> OP I E
~
\end{code}

Now the codes for general indexed inductive types are defined by |OPg I = OP I
I|, and the codes for restricted types are |OPr I = I -> OP I 1|. The intuition
is that for general IID the index is computed from the shape of the value,
whereas the index of a restricted IID is given beforehand. With these
definitions in mind, let us study the type of codes in more detail. We have
three constructors:
\begin{itemize}
    \item
        Base case: |iota e|. This corresponds to an IID with no arguments to the
        constructor. In the case of a general IID we have to give the index for
        the constructor. For instance the code for the singleton type of true
        booleans given by |IsTrue : Bool -> Set| and introduction rule |IsTrue
        true| is
        \begin{code}
        ~
            iota true : OPg Bool
        ~
        \end{code}
    \item
        Non-inductive argument: |sigma A gamma|. In this case the constructor
        has a non-inductive argument |a : A|. The remaining arguments may depend
        on |a| and are coded by |gamma a|. For instance, a datatype with
        |n| constructors can be coded by |sigma Fin_n gamma|, where |Fin_n| is
        an |n| element type and |gamma i| is the code for the |i|th constructor.

        Another example is the type of pairs over |A| and |B|
        \begin{code}
        ~
            \ i. sigma A (\ a. sigma B (\ b. iota star)) : OPr 1
        ~
        \end{code}
        In this case the following arguments do not depend on the value of the
        non-inductive arguments.
    \item
        Inductive argument: |delta A i gamma|. For an inductive argument we
        need to know the index of the argument. Note that the following
        arguments cannot depend on the value of the inductive argument. The
        inductive argument may occur under some assumptions |A|. For example
        consider the accessible part of a relation |<<| over |A|, |Acc : A ->
        Set| with introduction rule that for any |x|, if |((y : A) -> y << x
        -> Acc y)| then |Acc x|. Here the inductive argument |Acc y| occurs
        under the assumptions |(y : A)| and |y << x|. The code for this type is
        \begin{code}
        ~
            \ x. delta ((y : A) ** (y << x)) pi0 (iota star) : OPr A
        ~
        \end{code}
        The index of the inductive argument is |y| which is the first projection
        of the assumptions.
\end{itemize}
See Section~\ref{sec-IID-Examples} for more examples.

\subsection{From codes to types} \label{sec-IID-Types}

Now that we have defined the codes for IID the next step is to describe their
semantics, i.e. what the elements of an IID with a given code are. First we
define the type of arguments to the constructor parameterised by the type of
inductive arguments\footnote{Analogous to when you for simple inductive types
define an inductive type as the fixed point of some functor.}.
\begin{code}
~
Args_IE : (gamma : OP I E)(U : I -> Set) -> Set
Args (iota e)           U  = 1
Args (sigma A gamma)    U  = A ** \ a. Args (gamma a) U
Args (delta A i gamma)  U  = ((a : A) -> U (i a)) ** \ d. Args gamma U
~
\end{code}
There are no surprises here, in the base case there are no arguments, in the
non-inductive case there is one argument |a : A| followed by the rest of the
arguments (which may depend on |a|). In the inductive case we have a function
from the assumptions |A| to a value of the inductive type at the specified
index.

For general IID we also need to be able to compute the index of a given
constructor argument.
\begin{code}
~
index_IE : (gamma : OP I E)(U : I -> Set)(a : Args gamma U) -> E
index (iota e)           U  _       = e
index (sigma A gamma)    U  <x, a>  = index (gamma x) U a
index (delta A i gamma)  U  <_, a>  = index gamma U a
~
\end{code}
Note that only the non-inductive arguments are used when computing the index.

This is all the machinery needed to introduce the types of general and restricted
IID. For restricted IID we introduce, given |gamma : OPr I| and |i : I|
\begin{code}
~
    Urg : I -> Set
    introrg i : Args (gamma i) Urg -> Urg i
~
\end{code}
For general IID, given |gamma : OPg I| we want
\begin{code}
~
    Ugg : I -> Set
    introgg : (a : Args gamma Ugg) -> Ugg (index gamma Ugg a)
~
\end{code}
In Section~\ref{sec-Encoding} we show that it is sufficient to introduce
restricted IID together with an intensional identity type, to be able to define
|Ugg|.

As an example take the type of pairs over |A| and |B|:
\begin{code}
~
    gamma = \ i. sigma A (\ a. sigma B (\ b. iota star)) : OPr 1
    Pair A B = Urg : 1 -> Set
    introrg star : A ** (\ a. B ** (\ b. 1)) -> Pair A B star
~
\end{code}

Note that while the index of a restricted IID is determined from the outside we
still allow so called nested types~\cite{bird98nested}. An example of this is
the accessibility predicate given in Section~\ref{sec-IID-Codes}. This is
crucial when interpreting general IID by restricted IID (see
Section~\ref{sec-Encoding}).

\subsection{Elimination rules} \label{sec-IID-Elimination}

To complete the formalisation of IID we have to give the elimination rules.  We
start by defining the set of assumptions of the inductive occurrences in a
given constructor argument.
\begin{code}
~
IndArg_IE : (gamma : OP I E)(U : I -> Set) -> Args gamma U -> Set
IndArg (iota e)           U _         = 0
IndArg (sigma A gamma)    U < a, b >  = IndArg (gamma a) U b
IndArg (delta A i gamma)  U < g, b >  = A + IndArg gamma U b
~
\end{code}
Simply put |IndArg gamma a| is the disjoint union of the assumptions of the
inductive occurrences in |a|.

Now, given the assumptions of one inductive occurrence we can compute the index
of that occurrence.
\begin{code}
~
IndIndex_IE :  (gamma : OP I E)(U : I -> Set)
               (a : Args gamma U) -> IndArg gamma U a -> I
IndIndex (iota e)           U  _         bot
IndIndex (sigma A gamma)    U  < a, b >  c        = IndIndex (gamma a) U b c
IndIndex (delta A i gamma)  U  < g, b >  (inl a)  = i a
IndIndex (delta A i gamma)  U  < g, b >  (inr a)  = IndIndex gamma U b a
~
\end{code}
The code |gamma| contains the values of the indices for the inductive
occurrences so we just have to find the right inductive occurrence.

We can now define a function to extract a particular inductive occurrence from
a constructor argument.
\begin{code}
~
Ind_IE :  (gamma : OP I E)(U : I -> Set)
          (a : Args gamma U)(v : IndArg gamma U a) -> U (IndIndex gamma U a v)
Ind (iota e)           U  _         bot
Ind (sigma A gamma)    U  < a, b >  c        = Ind (gamma a) U b c
Ind (delta A i gamma)  U  < g, b >  (inl a)  = g a
Ind (delta A i gamma)  U  < g, b >  (inr a)  = Ind gamma U b a
~
\end{code}
Again the definition is very simple.

Next we define the notion of an induction hypothesis. Given a predicate |C|
over elements in a datatype, an induction hypothesis for a constructor argument
|a| is a function that proves the predicate for all inductive occurrences in
|a|.
\begin{code}
~
IndHyp_IE :  (gamma : OP I E)(U : I -> Set) ->
             (C : (i : I) -> U i -> Set)(a : Args gamma U) -> Set
IndHyp gamma U C a =  (v : IndArg gamma U a) ->
                      C (IndIndex gamma U a v) (Ind gamma U a v)
~
\end{code}

Given a function |g| that proves |C i u| for all |i| and |u| we can construct an
induction hypothesis for |a| by applying |g| to all inductive occurrences in
|a|.
\begin{code}
~
indHyp_IE :
  (gamma : OP I E)(U : I -> Set)
  (C : (i : I) -> U i -> Set)
  (g : (i : I)(u : U i) -> C i u)
  (a : Args gamma U) -> IndHyp gamma U C a
indHyp gamma U C g a = \ v -> g (IndIndex gamma U a v) (Ind gamma U a v)
~
\end{code}

We are now ready to introduce the elimination rules. Given |I : Set| and |gamma
: OPr I| the elimination rule for the restricted IID |Urg| is given by the
following type and computation rule:
\begin{code}
~
elimUrg :
  (C : (i : I) -> Urg i -> Set) ->
  (  (i : I)(a : Args (γ i) Urg) ->
     IndHyp (γ i) Urg C a -> C i (introrg i a)) ->
  (i : I)(u : Urg i) -> C i u
elimUrg C step i (introrg a) =
  step i a (indHyp (γ i) Urg C (elimUrg C step) a)
~
\end{code}
That is, for any predicate |C| over |Urg|, if given that |C| holds for all
inductive occurrences in some arbitrary constructor argument |a| then |C| holds
for |introrg a|, then |C| holds for all elements of |Urg|. The computation rule
states that eliminating an element built by the introduction rule is the same
as first eliminating all inductive occurrences and then applying the induction
step.

The elimination rule for a general IID is similar. The difference is that the
index of a constructor argument is computed from the value of the argument.
\begin{code}
~
elimUgg :
  (C : (i : I) -> Ugg i -> Set) ->
  (  (a : Args γ Ugg) -> IndHyp γ Ugg C a ->
     C (index γ Ugg a) (introgg a)) ->
  (i : I)(u : Ugg i) -> C i u
elimUgg C step (index γ Ugg a) (introgg a) =
  step a (indHyp γ Ugg C (elimUgg C m) a)
~
\end{code}

\TODO{examples}

\subsection{Examples} \label{sec-IID-Examples}

Datatypes with multiple constructors.

Intensional identity relation (Paulin version).

\begin{code}
~
data (==) {A : Set}(x : A) : A -> Set where
  refl : x == x
~
\end{code}

The elimination rule for this type is Paulin elimination.

\section{Encoding generalised IID as restricted IID} \label{sec-Encoding}

\subsection{Formation rule}

To show that generalised IID are expressible in the system of restricted IID
extended with the intensional identity type, we first show how to transform the
code for a generalised IID into the code for its encoding as a restricted IID.
The basic idea is to add a proof that the index of the restricted IID is equal
to index computed for the generalised IID. Concretely:

\begin{code}
~
eps_I : OPg I -> OPr I
eps (iota i)           j = sigma (i == j) (\ _ -> iota star)
eps (sigma A gamma)    j = sigma A (\ a -> eps (gamma a) j)
eps (delta H i gamma)  j = delta H i (eps gamma j)
~
\end{code}

For example, the generalised IID of proof that a number is even, given by
\begin{code}
~
data Even : Nat -> Set where
  evenZ   : Even zero
  evenSS  : (n : Nat) -> Even n -> Even (suc (suc n))
~
\end{code}
is encoded by the following restricted IID:
\begin{code}
~
data Even' (n : Nat) : Set where
  evenZ'   : zero == n -> Even' n
  evenSS'  : (m : Nat) -> Even m -> suc (suc m) == n -> Even' n
~
\end{code}

Using the coding function |eps| we represent the general IID for a code |gamma
: OPg I| as
\begin{code}
~
Ugg : I -> Set
Ugg i = Ureg i
~
\end{code}
In the case that the equality proofs added by |eps| are extensional there is an
equivalence between the generalised IID and its representation as a restricted
IID as shown by Dybjer and Setzer~\cite{dybjer:indexed-ir}. With an intensional
equality proof, however, this is not the case. For instance, for |p, q : zero
== n| it is not necessarily the case that |evenZ' p = evenZ' q|. This means
that our representation of generalised IID contains more elements than the ones
corresponding to elements in the generalised IID. The crucial insight of this
paper is that this does not matter. As long as the extra elements are
well-behaved, i.e. as long as the elimination rule is valid there is no
problem. Before tackling the elimination rule, however, we look at the
introduction rule.

\subsection{Introduction rule}

We need an introduction rule
\begin{code}
introgg : (a : Args gamma Ugg) -> Ugg (index gamma Ugg a)
\end{code}
and we have the introduction rule for the restricted IID:
\begin{code}
introreg i  :  Args (eps gamma i) Ureg  -> Ureg i
            =  Args (eps gamma i) Ugg   -> Ugg i
\end{code}
So, what we need is a function |grArgs| to convert a constructor argument for a
generalised IID, |a : Args gamma Ugg|, to a constructor argument for its
representation, |Args (eps gamma (index gamma Ugg a)) Ugg|. This function
simply adds a reflexivity proof to |a|:
\begin{code}
~
grArgs_I :  (gamma : OPg I)(U : I -> Set)
	    (a : Args gamma U) -> Args (eps gamma (index gamma U a)) U
grArgs (iota e)           U a         = < refl, star >
grArgs (sigma A gamma)    U < a, b >  = < a, grArgs (gamma a) U b >
grArgs (delta H i gamma)  U < g, b >  = < g, grArgs gamma U b >
~
\end{code}
As usual we abstract over the type of inductive occurrences. Now the
introduction rule is simply defined by
\begin{code}
~
introgg a = introreg (index gamma Ugg a) (grArgs gamma Ugg a)
~
\end{code}
In our example:
\begin{code}
~
evenZ : Even' zero
evenZ = evenZ' refl

evenSS : (n : Nat) -> Even' n -> Even' (suc (suc n))
evenSS n e = evenSS' n e refl
~
\end{code}

\subsection{Elimination rule}

As we have already observed, the representation of a generalised IID contains
more elements than necessary, so it not obvious that we will be able to define
the elimination rule we want. Fortunately it turns out that we can. First,
recall the elimination rule that we want to define:
\begin{code}
~
elimUgg :  (C : (i : I) -> Ugg i -> Set) ->
           (  (a : Args γ Ugg) -> IndHyp γ Ugg C a ->
              C (index γ Ugg a) (introgg a)) ->
           (i : I)(u : Ugg i) -> C i u
~
\end{code}
The elimination for the restricted IID is
\begin{code}
~
elimUreg :  (C : (i : I) -> Ugg i -> Set) ->
            (  (i : I)(a : Args (eps gamma i) Ugg) ->
               IndHyp (eps gamma i) Ugg C a -> C i (introreg i a)) ->
            (i : I)(u : Ugg i) -> C i u
~
\end{code}
Now we face the opposite problem from what we encountered when defining the
introduction rule. In order to apply the induction step we have to convert a
constructor argument to the restricted IID to a generalised argument, and
likewise for the induction hypothesis. To convert a restricted constructor
argument we simply remove the equality proof.

\begin{code}
~
rgArgs_I : (gamma : OPg I)(U : I -> Set)
	   (i : I)(a : Args (eps gamma i) U) -> Args gamma U
rgArgs (iota i)           U j _         = star
rgArgs (sigma A gamma)    U j < a, b >  = < a, rgArgs (gamma a) U j b >
rgArgs (delta H i gamma)  U j < g, b >  = < g, rgArgs gamma U j b >
~
\end{code}

Converting induction hypotheses requires a little more work. This work,
however, is pure book-keeping, as we will see.  We have an induction hypothesis
for the restricted IID. Namely, for |a : Args (eps gamma i) Ugg| we have
\begin{code}
ih  :  IndHyp (eps gamma i) Ugg C a
    =  (v : IndArg (eps gamma i) U a -> C  (IndIndex (eps gamma i) U a v)
                                           (Ind (eps gamma i) U a v)
\end{code}
We need, for |a' = rgArgs gamma Ugg i a|
\begin{code}
ih  :  IndHyp gamma Ugg C a'
    =  (v : IndArg gamma U a') -> C (IndIndex gamma U a' v) (Ind gamma U a' v)
\end{code}
By induction on |gamma| we can prove that the following equalities holds
definitionally for any |a : Args (eps gamma i) U| and |v : IndArg (eps gamma i)
U a|:
\begin{code}
~
IndArg    gamma U (rgArgs gamma U i a)    = IndArg    (eps gamma i) U a
IndIndex  gamma U (rgArgs gamma U i a) v  = IndIndex  (eps gamma i) U a v
Ind       gamma U (rgArgs gamma U i a) v  = Ind       (eps gamma i) U a v
~
\end{code}
\TODO{make into a lemma}
That is, we can use the induction hypothesis we have as it is. Let us now try
to define the elimination rule. We are given
\begin{code}
~
C     :  (i : I) -> Ugg i -> Set
step  :  (a : Args gamma Ugg) -> IndHyp gamma Ugg C a ->
         C (index gamma Ugg a) (introgg a)
i     :  I
u     :  Ugg i
~
\end{code}
and we have to prove |C i u|. To apply the restricted elimination rule
(|elimUreg|) we need an induction step |step'| of type
\begin{code}
(i : I)(a : Args (eps gamma i) Ugg) -> IndHyp (eps gamma i) Ugg C a -> C i (intror i a)
\end{code}
As we have observed the induction hypothesis already has the right type, so we attempt to
define
\begin{code}
step' i a ih = step (rgArgs gamma Ugg i a) ih
\end{code}
The type of |step' i a ih| is |C (index gamma U a') (intror (grArgs gamma U
a'))|, where |a' = rgArgs gamma Ugg i a|. Here, the extra elements in |Ugg|
get in the way. Basically we would like the conversion of a constructor
argument from the restricted representation to a generalised argument and back
to be the (definitional) identity. It is easy to see that this is not the case.
For instance, in our |Even| example the argument to the |evenZ'| constructor
is proof |p : zero == zero|. Converting to a generalised argument we
throw away the proof, and converting back we add a proof by reflexivity. But
|p| and |refl| are not definitionally equal. Fortunately they are
propositionally equal, so we can prove the following substitution rule:

\begin{code}
~
rgArgssubst :  (gamma : OPg I)(U : I -> Set)
               (C : (i : I) -> rArgs (eps gamma) U i -> Set)
               (i : I)(a : rArgs (eps gamma) U i) ->
               (C  (index gamma U (rgArgs gamma U i a))
                   (grArgs gamma U (rgArgs gamma U i a))
               ) -> C i a

rgArgssubst (iota i) U C j < p, star > m =
  elimId i (\ k q -> C k < q, star >) m j p

rgArgssubst (delta A gamma)   U C j < a, b > m = 
  rgArgssubst (gamma a) U (\ i c -> C i < a, c >) j b m

rgArgssubst (delta H i gamma) U C j < g, b > m =
  rgArgssubst gamma U (\ i c -> C i < g, c >) j b m
~
\end{code}
The interesting case is the |iota|-case where we have to prove |C j <p, star>|
from |C i <refl, star>| and |p : i == j|. This is proven using the elimination
rule, |elimId|, for the identity type. Armed with this substitution rule we can
define the elimination rule for a generalised IID:
\begin{code}
~
elimUgg C step i u = elimUreg C step' i u
  where
    step' i a ih = rgArgssubst  gamma Ugg (\ i a -> C i (intror i a))
                                i a (step (rgArgs gamma Ugg i a) ih)
~
\end{code}

\subsection{Equality rule}

So far we have shown that we can represent generalised IID as a restricted IID
and that the elimination rule is still valid. The only thing remaining is to
show that the equality rule is also valid. That is, that we get the same reduction
behaviour for our representation as we would if we extended our system with
generalised IID.

Let us recall the equality rule we have to prove:
\begin{code}
~
elimUgg C step (index γ Ugg a) (introgg a) =
  step a (indHyp γ Ugg C (elimUgg C step) a)
~
\end{code}
The key insight here is that the equality rule does not talk about arbitrary
elements of |Ugg|, but only those that have been constructed using the
introduction rule. This means that we do not have to satisfy any definitional
equalities for elements where the equality proof is not |refl|. So, the main
step in the proof is to prove that |rgArgssubst| is the definitional identity
when the equality proof is |refl|, i.e. when the argument is build using the
|grArgs| function.

%format ar   = "a_r"
%format arg  = "a_{rg}"

\begin{lemma} \label{lem-rgArgsubst}
  For all |gamma|, |U|, |C|, |a : Args gamma U|, and
  \begin{code}
    h : C (index gamma U arg) (grArgs gamma U arg)
  \end{code}
  where
  \begin{code}
    ar    = grArgs gamma U a
    i     = index gamma U a
    arg   = rgArgs gamma U i ar
  \end{code}
  it holds definitionally that
  \begin{code}
    rgArgssubst gamma U C i ar h = h
  \end{code}
\end{lemma}

%format lem_rgArgsubst = "\ref{lem-rgArgsubst}"

\begin{proof}
  By induction on |gamma|. In the |iota|-case we have to prove that
  \begin{code}
    elimId i C' h i refl = h
  \end{code}
  which is exactly the equality rule for the identity type.
\end{proof}

\begin{lemma} \label{lem-arg-is-a}
  |arg = a|
\end{lemma}

%format lem_argIsa = "\ref{lem-arg-is-a}"

Now take
\begin{code}
  a   : Args gamma Ugg
  i   = index gamma Ugg a
  ar  = grArgs gamma Ugg a
  arg = rgArgs gamma Ugg i ar
\end{code}
we have
\begin{code}
~
elimUgg C step i (introgg a)
=  {definition of_ elimUgg and introrg}
   elimUreg C step' i (introreg i ar)
=  {equality rule for Ureg}
   step' i ar (indHyp (eps gamma i) Ugg C (elimUgg C step) ar)
=  {definition of_ step'}
   rgArgssubst gamma Ugg (\ i a. C i (intror i ar)) i ar
      (step arg (indHyp (eps gamma i) Ugg C (elimUgg C step) ar))
=  {Lemma lem_rgArgsubst}
   step arg (indHyp (eps gamma i) Ugg C (elimUgg C step) ar)
=  {Lemma lem_argIsa}
   step a (indHyp gamma Ugg C (elimUgg C step) a)
~
\end{code}

\TODO{indHyp equality}

\section{Conclusions}

This is good stuff.

\bibliographystyle{abbrv}
\bibliography{../../../../bib/pmgrefs}

\end{document}

% vim: et
