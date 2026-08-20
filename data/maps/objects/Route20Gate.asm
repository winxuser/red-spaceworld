Route20Gate_Object:
	db $00 ; border block

	def_warp_events
	warp_event  4,  0, ROUTE_20, 1
	warp_event  5,  0, ROUTE_20, 2
	warp_event  4,  7, STAND, 1
	warp_event  5,  7, STAND, 2

	def_bg_events

	def_object_events

	def_warps_to ROUTE_20_GATE
