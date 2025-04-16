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


(:action Load
:parameters (?x - hoist ?y - crate ?z - truck ?p - place)
:precondition (and (lifting ?x ?y))
:effect (and (not (lifting ?x ?y)) (available ?x)))



(:action Unload
:parameters (?x - hoist ?y - crate ?z - truck ?p - place)
:precondition (and (available ?x) (in ?y ?z))
:effect (and (lifting ?x ?y)))

)