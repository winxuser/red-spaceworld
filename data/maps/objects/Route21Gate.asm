Route21Gate_Object:
	db $00 ; border block

	def_warp_events
	warp_event  4,  0, ROUTE_21, 1
	warp_event  5,  0, ROUTE_21, 2
	warp_event  4,  7, ROUTE_22, 1
	warp_event  5,  7, ROUTE_22, 2

	def_bg_events

	def_object_events

	def_warps_to ROUTE_21_GATE
