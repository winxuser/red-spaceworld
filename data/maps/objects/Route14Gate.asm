Route14Gate_Object:
	db $0 ; border block

	def_warp_events
	warp_event  5,  0, ROUTE_14, 1
	warp_event  4,  0, ROUTE_14, 2
	warp_event  4,  7, ROUTE_15, 1
	warp_event  5,  7, ROUTE_15, 1

	def_bg_events

	def_object_events

	def_warps_to ROUTE_14_GATE
