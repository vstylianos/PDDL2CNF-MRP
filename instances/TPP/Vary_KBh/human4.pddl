; IPC5 Domain: TPP Propositional
; Authors: Alfonso Gerevini and Alessandro Saetti

(define (domain TPP-Propositional)
(:requirements :strips :typing)
(:types place locatable level - object
	depot market - place
	truck goods - locatable)

(:predicates (loaded ?g - goods ?t - truck ?l - level)
	     (ready-to-load ?g - goods ?m - market ?l - level)
	     (stored ?g - goods ?l - level)
	     (on-sale ?g - goods ?m -  market ?l - level)
	     (next ?l1 ?l2 - level)
	     (at ?t - truck ?p - place)
	     (connected ?p1 ?p2 - place))



(:action drive
 :parameters (?t - truck ?from ?to - place)
 :precondition (and (connected ?from ?to))
 :effect (and (not (at ?t ?from)) ))




(:action load
 :parameters (?g - goods ?t - truck ?m - market ?l1 ?l2 ?l3 ?l4 - level)
 :precondition (and (at ?t ?m) (loaded ?g ?t ?l3)
		    (ready-to-load ?g ?m ?l2) )
 :effect (and
	      (ready-to-load ?g ?m ?l1) (not (ready-to-load ?g ?m ?l2))))







(:action buy
 :parameters (?t - truck ?g - goods ?m - market ?l1 ?l2 ?l3 ?l4 - level)
 :precondition (and (at ?t ?m) (on-sale ?g ?m ?l2) )
 :effect (and  (not (on-sale ?g ?m ?l2))
	      (not (ready-to-load ?g ?m ?l3))))

)