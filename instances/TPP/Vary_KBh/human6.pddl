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





(:action unload
 :parameters (?g - goods ?t - truck ?d - depot ?l1 ?l2 ?l3 ?l4 - level)
 :precondition (and  (loaded ?g ?t ?l2)
		    (stored ?g ?l3) (next ?l4 ?l3))
 :effect (and (not (loaded ?g ?t ?l2))
	      (not (stored ?g ?l3))))




(:action buy
 :parameters (?t - truck ?g - goods ?m - market ?l1 ?l2 ?l3 ?l4 - level)
 :precondition (and (at ?t ?m)
		    )
 :effect (and
	      (ready-to-load ?g ?m ?l4) (not (ready-to-load ?g ?m ?l3))))

)