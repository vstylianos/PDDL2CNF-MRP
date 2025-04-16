(define (problem depotprob1818) (:domain Depot)
(:objects
	depot0 - Depot
	distributor0 distributor1 - Distributor
	truck0  - Truck
	pallet1 pallet2 - Pallet
	crate0 - Crate
	hoist0 hoist1 hoist2 - Hoist)
(:init
	(clear crate0)
	(clear pallet2)
	(at truck0 distributor1)
	(at hoist0 depot0)
	(available hoist0)
	(at hoist1 distributor0)
	(available hoist1)
	(at hoist2 distributor1)
	(available hoist2)
	(at crate0 distributor0)
	(on crate0 pallet1)
	(at pallet2 distributor0)

)

(:goal (and
		(on crate0 pallet2)
	)
))

