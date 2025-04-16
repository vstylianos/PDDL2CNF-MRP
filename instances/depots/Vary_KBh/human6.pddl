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



(:action Lift
:parameters (?x - hoist ?y - crate ?z - surface ?p - place)
:precondition (and  (clear ?y))
:effect (and  (not (available ?x))
             (clear ?z) (not (on ?y ?z))))

(:action Drop
:parameters (?x - hoist ?y - crate ?z - surface ?p - place)
:precondition (and (lifting ?x ?y))
:effect (and (available ?x) (clear ?y)
		(on ?y ?z)))



)