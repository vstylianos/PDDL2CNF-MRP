(define (domain BLOCKS)
  (:requirements :strips :typing)
  (:types block)
  (:predicates (on ?x - block ?y - block)
	       (ontable ?x - block)
	       (clear ?x - block)
	       (handempty)
	       (holding ?x - block)
	       )

  (:action pickup
	     :parameters (?x - block)
	     :precondition (and (handempty))
	     :effect
	     (and
		   (not (handempty))
		   ))

  (:action putdown
	     :parameters (?x - block)
	     :precondition (and (holding ?x))
	     :effect
	     (and (not (holding ?x))

		   (handempty)
		   (ontable ?x)))

  (:action unstack
	     :parameters (?x - block ?y - block)
	     :precondition (and  (handempty))
	     :effect
	     (and

		   (not (handempty))
		   (not (on ?x ?y)))))