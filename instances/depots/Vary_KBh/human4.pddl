(define (domain Depot)
(:requirements :typing)
(:types place locatable - object
	depot distributor - place
        truck hoist surface - locatable
        pallet crate - surface)

(:predicates (at ?x - locatable ?y - place)
             (on ?x - crate ?y - surface)
             (in ?x - crate ?y - truck)
             (lifting ?x - hoist ?y - crate)
             (available ?x - hoist)
             (clear ?x - surface))





(:action Drop
:parameters (?x - hoist ?y - crate ?z - surface ?p - place)
:precondition (and (clear ?z) (lifting ?x ?y))
:effect (and (not (clear ?z)) (clear ?y)
		(on ?y ?z)))

(:action Load
:parameters (?x - hoist ?y - crate ?z - truck ?p - place)
:precondition (and (at ?z ?p) (lifting ?x ?y))
:effect (and (not (lifting ?x ?y)) (available ?x)))

(:action Unload
:parameters (?x - hoist ?y - crate ?z - truck ?p - place)
:precondition (and (at ?z ?p) (available ?x) (in ?y ?z))
:effect (and (not (available ?x)) (lifting ?x ?y)))

)