SouthCity_Object:
	db $00 ; border block

	def_warp_events
	warp_event 31, 30, ROUTE_7_GATE, 2
	warp_event 30, 30, ROUTE_7_GATE, 1
	warp_event 35, 19, ROUTE_9_GATE, 1
	warp_event 30,  5, ROUTE_24_GATE, 1
	warp_event 31,  5, ROUTE_24_GATE, 2

	def_bg_events

	def_object_events

	def_warps_to SOUTH_CITY
