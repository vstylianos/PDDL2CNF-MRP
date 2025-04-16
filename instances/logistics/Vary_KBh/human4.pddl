(define (domain logistics)
  (:requirements :strips :typing)
  (:types truck
          airplane - vehicle
          package
          vehicle - physobj
          airport
          location - place
          city
          place
          physobj - object)

  (:predicates 	(in-city ?loc - place ?city - city)
		(at ?obj - physobj ?loc - place)
		(in ?pkg - package ?veh - vehicle))



(:action load-airplane
  :parameters   (?pkg - package ?airplane - airplane ?loc - place)
  :precondition (and (at ?pkg ?loc) )
  :effect       (and (in ?pkg ?airplane)))


(:action unload-airplane
  :parameters    (?pkg - package ?airplane - airplane ?loc - place)
  :precondition  (and  (at ?airplane ?loc))
  :effect        (and (not (in ?pkg ?airplane)) ))

(:action drive-truck
  :parameters (?truck - truck ?loc-from - place ?loc-to - place ?city - city)
  :precondition
   (and  (in-city ?loc-from ?city) (in-city ?loc-to ?city))
  :effect
   (and (at ?truck ?loc-to)))

(:action fly-airplane
  :parameters (?airplane - airplane ?loc-from - airport ?loc-to - airport)
  :precondition
   (at ?airplane ?loc-from)
  :effect
   (and  (at ?airplane ?loc-to)))
)