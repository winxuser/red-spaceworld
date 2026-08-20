Route24Gate_Object:
	db $0 ; border block

	def_warp_events
	warp_event  4,  7, SOUTH_CITY, 4
	warp_event  5,  7, SOUTH_CITY, 5
	warp_event  4,  0, ROUTE_24, 1
	warp_event  5,  0, ROUTE_24, 2

	def_bg_events

	def_object_events

	def_warps_to ROUTE_24_GATE
