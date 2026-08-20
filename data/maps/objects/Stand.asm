Stand_Object:
	db $00 ; border block

	def_warp_events
	warp_event 30, 13, ROUTE_20_GATE, 3
	warp_event 31, 13, ROUTE_20_GATE, 4

	def_bg_events

	def_object_events

	def_warps_to STAND
