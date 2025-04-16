(define (domain logistics)
  (:requirements :strips :typing)
  (:types place
          physobj - object
          vehicle - physobj
          truck - vehicle
          airplane - vehicle
          package - physobj
          airport - place
          location - place
          city)

  (:predicates 	(in-city ?loc - place ?city - city)
		(at ?obj - physobj ?loc - place)
		(in ?pkg - package ?veh - vehicle))



(:action load-airplane
  :parameters   (?pkg - package ?airplane - airplane ?loc - place)
  :precondition (and  (at ?airplane ?loc))
  :effect       (and  (in ?pkg ?airplane)))

(:action unload-truck
  :parameters   (?pkg - package ?truck - truck ?loc - place)
  :precondition (and (in ?pkg ?truck))
  :effect       (and (at ?pkg ?loc)))





(:action fly-airplane
  :parameters (?airplane - airplane ?loc-from - airport ?loc-to - airport)
  :precondition
   (at ?airplane ?loc-from)
  :effect
   (and (not (at ?airplane ?loc-from)) ))
)