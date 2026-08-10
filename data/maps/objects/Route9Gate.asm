Route9Gate_Object:
	db $0 ; border block

	def_warp_events
	warp_event  0,  7, SOUTH_CITY, 3
	warp_event  1,  7, SOUTH_CITY, 3
	warp_event  8,  7, ROUTE_9, 1
	warp_event  9,  7, ROUTE_9, 1
	def_bg_events

	def_object_events

	def_warps_to ROUTE_9_GATE
