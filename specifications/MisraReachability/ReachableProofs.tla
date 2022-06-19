-------------------------- MODULE ReachableProofs --------------------------
(***************************************************************************)
(* This module contains the TLAPS checked proofs of partial correctness of *)
(* the algorithm in module Reachable, based on the invariants Inv1, Inv2,  *)
(* and Inv3 defined in that module.  The proofs here are pretty simple     *)
(* because the difficult parts involve proving general results about       *)
(* reachability that are independent of the algorithm.  Those results are  *)
(* stated and proved in module ReachabilityProofs and are used by the      *)
(* proofs in this module.                                                  *)
(*                                                                         *)
(* You might be sufficiently motivated to make sure the algorithm is       *)
(* correct to want a machine-checked proof that is, but not motivated      *)
(* enough to write machine-checked proofs of the properties of directed    *)
(* graphs that the proof uses.  If that's the case, or you're curious      *)
(* about why it might be the case, read module ReachabilityTest.           *)
(*                                                                         *)
(* After writing the proof, it occurred to me that it might be easier to   *)
(* replace invariants Inv2 and Inv3 by the single invariant                *)
(*                                                                         *)
(*    Inv23 == Reachable = ReachableFrom(marked \cup vroot)                *)
(*                                                                         *)
(* Inv23 is obviously true initially and its invariance is maintained by   *)
(* this general result about marked graphs                                 *)
(*                                                                         *)
(*     \A S \in SUBSET Nodes :                                             *)
(*        \A n \in S : reachableFrom(S) = reachableFrom(S \cup Succ[n])    *)
(*                                                                         *)
(* since marked \cup vroot is changed only by adding successors of nodes   *)
(* in vroot to it.  Partial correctness is true because when vroot = {},   *)
(* we have                                                                 *)
(*                                                                         *)
(*    Inv1  => \A n \in marked : Succ[n] \subseteq marked                  *)
(*    Inv23 <=>  Reachable = ReachableFrom(marked)                         *)
(*                                                                         *)
(* and the following is true for any directed graph:                       *)
(*                                                                         *)
(*    \A S \in SUBSET Nodes:                                               *)
(*      (\A n \in S : Succ[n] \subseteq S) => (S = reachableFrom(S))       *)
(*                                                                         *)
(* As an exercise, you can try rewriting the proof of partial correctness  *)
(* of the algorithm using only the invariants Inv1 and Inv23, using the    *)
(* necessary results about reachability.  When you've finished doing that, *)
(* you can try proving those reachability results.                         *)
(***************************************************************************)
EXTENDS Reachable, ReachabilityProofs, TLAPS

(***************************************************************************)
(* Note that there is no need to write a separate proof that TypeOK is     *)
(* invariant, since its invariance is implied by the invariance of Inv1.   *)
(***************************************************************************)

THEOREM Thm1 == Spec => []Inv1
  (*************************************************************************)
  (* The three level <1> steps and its QED step's proof are the same for   *)
  (* any inductive invariance proof.  Step <1>2 is the only one that TLAPS *)
  (* couldn't prove with a BY proof.                                       *)
  (*************************************************************************)
  <1>1. Init => Inv1
    BY RootAssump DEF Init, Inv1, TypeOK
  <1>2. Inv1 /\ [Next]_vars => Inv1'
    (***********************************************************************)
    (* The steps of this level <2> proof are the standard way of proving   *)
    (* the formula <1>2; they were generated by the Toolbox's Decompose    *)
    (* Proof Command.  The algorithm is simple enough that TLAPS can prove *)
    (* steps <2>1 and <2>2, which are the only nontrivial ones, with BY    *)
    (* proofs.                                                             *)
    (***********************************************************************)
    <2> SUFFICES ASSUME Inv1,
                        [Next]_vars
                 PROVE  Inv1'
      OBVIOUS
    <2>1. CASE a
        BY <2>1, SuccAssump DEF Inv1, TypeOK, a
    <2>2. CASE UNCHANGED vars
      BY <2>2 DEF Inv1, TypeOK, vars
    <2>3. QED
      BY <2>1, <2>2 DEF Next
  <1>3. QED
    BY <1>1, <1>2, PTL DEF Spec


THEOREM Thm2 == Spec => [](TypeOK /\ Inv2)
  (*************************************************************************)
  (* This theorem is a trivial consequence of a general fact about         *)
  (* reachability in a directed graph, which is called Reachable1 and      *)
  (* proved in Module ReachabilityProofs,                                  *)
  (*************************************************************************)
  <1>1. Inv1 => TypeOK /\ Inv2
    BY Reachable1 DEF Inv1, Inv2, TypeOK
  <1> QED
    BY <1>1, Thm1, PTL

(***************************************************************************)
(* The best way to read the proof of the following theorem is              *)
(* hierarchically.  Read all the steps of a proof at a given level, then   *)
(* read separately the proof of each of those steps, starting with the     *)
(* proof of the QED step.  Start by executing the Hide Current Subtree     *)
(* command on the theorem, then use the little + and - icons beside the    *)
(* theorem and each proof step to show and hide its proof.                 *)
(***************************************************************************)
THEOREM Thm3 == Spec => []Inv3
  (*************************************************************************)
  (* Observe the level <1> proof and the proof of its QED step to see how  *)
  (* the invariance of TypeOK and Inv2 are used in the proof of invariance *)
  (* of Inv3.                                                              *)
  (*************************************************************************)
  <1>1. Init => Inv3
    BY RootAssump DEF Init, Inv3, TypeOK, Reachable
  <1>2. TypeOK /\ TypeOK' /\ Inv2 /\ Inv2' /\ Inv3 /\ [Next]_vars => Inv3'
    (***********************************************************************)
    (* The SUFFICES step and its proof, the QED step and its proof, and    *)
    (* the CASE steps <2>2 and <2>3 were generated by the Toolbox's        *)
    (* Decompose Proof command.                                            *)
    (***********************************************************************)
    <2> SUFFICES ASSUME TypeOK,
                        TypeOK',
                        Inv2,
                        Inv2',
                        Inv3,
                        [Next]_vars
                 PROVE  Inv3'
      OBVIOUS
    (***********************************************************************)
    (* Step <2>1 is obviously true because Reachable and ReachableFrom are *)
    (* constants.  It helps TLAPS to give it these results explicitly so   *)
    (* it doesn't have to figure them out when it needs them.              *)
    (***********************************************************************)
    <2>1. /\ Reachable' = Reachable
          /\ ReachableFrom(vroot)' = ReachableFrom(vroot')
          /\ ReachableFrom(marked \cup vroot)' = ReachableFrom(marked' \cup vroot')
      OBVIOUS
    <2>2. CASE a
      (*********************************************************************)
      (* `a' is a simple enough formula so there's no need to hide its     *)
      (* definition when it's not needed.                                  *)
      (*********************************************************************)
      <3> USE <2>2 DEF a
      (*********************************************************************)
      (* Splitting the proof into these two cases is an obvious way to     *)
      (* write the proof--especially since TLAPS is not very good at       *)
      (* figuring out by itself when it should do a proof by a case split. *)
      (*********************************************************************)
      <3>1. CASE vroot = {}
        BY <2>1, <3>1 DEF Inv3, TypeOK
      <3>2. CASE vroot # {}
        (*******************************************************************)
        (* The way to use a fact of the form \E x \in S : P(x) is to pick  *)
        (* an x in S satisfying P(x).                                      *)
        (*******************************************************************)
        <4>1. PICK v \in vroot :
                IF v \notin marked
                   THEN /\ marked' = (marked \cup {v})
                        /\ vroot' = vroot \cup Succ[v]
                   ELSE /\ vroot' = vroot \ {v}
                        /\ UNCHANGED marked
          BY <3>2
        (*******************************************************************)
        (* Again, the obvious way to use a fact of the form                *)
        (*                                                                 *)
        (*    IF P THEN ... ELSE ...                                       *)
        (*                                                                 *)
        (* is by splitting the proof into the two cases P and ~P.          *)
        (*******************************************************************)
        <4>2. CASE v \notin marked
          (*****************************************************************)
          (* This case follows immediately from the general reachability   *)
          (* result Reachable2 from module ReachabilityProofs.             *)
          (*****************************************************************)
          <5>1. /\ ReachableFrom(vroot') = ReachableFrom(vroot)
                /\ v \in ReachableFrom(vroot)
            BY <4>1, <4>2, Reachable2 DEF TypeOK
          <5>2. QED
            BY <5>1, <4>1, <4>2, <5>1, <2>1 DEF Inv3
        <4>3. CASE v \in marked
          (*****************************************************************)
          (* This case is obvious.                                         *)
          (*****************************************************************)
          <5>1. marked' \cup vroot' = marked \cup vroot
            BY <4>1, <4>3
          <5>2. QED
            BY <5>1, <2>1 DEF Inv2, Inv3
        <4>4. QED
          BY <4>2, <4>3
       <3>3. QED
          BY <3>1, <3>2
    <2>3. CASE UNCHANGED vars
      (*********************************************************************)
      (* As is almost all invariance proofs, this case is trivial.         *)
      (*********************************************************************)
      BY <2>1, <2>3 DEF Inv3, TypeOK, vars
    <2>4. QED
      BY <2>2, <2>3 DEF Next
  <1>3. QED
    BY <1>1, <1>2, Thm2, PTL DEF Spec


THEOREM Spec => []((pc = "Done") => (marked = Reachable))
  (*************************************************************************)
  (* This theorem follows easily from the invariance of Inv1 and Inv3 and  *)
  (* the trivial result Reachable3 of module ReachabilityProofs that       *)
  (* Reachable({}) equals {}.  That result was put in module               *)
  (* ReachabilityProofs so all the reasoning about the algorithm depends   *)
  (* only on properties of ReachableFrom, and doesn't depend on how        *)
  (* ReachableFrom is defined.                                             *)
  (*************************************************************************)
  <1>1. Inv1 => ((pc = "Done") => (vroot = {}))
    BY DEF Inv1, TypeOK
  <1>2. Inv3 /\ (vroot = {}) => (marked = Reachable)
    BY Reachable3 DEF Inv3
  <1>3. QED
    BY <1>1, <1>2, Thm1, Thm3, PTL
=============================================================================
\* Modification History
\* Last modified Sun Apr 14 16:24:32 PDT 2019 by lamport
\* Created Thu Apr 11 18:41:11 PDT 2019 by lamport
