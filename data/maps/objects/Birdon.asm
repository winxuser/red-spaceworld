Birdon_Object:
	db $00 ; border block

	def_warp_events
	warp_event  8,  5, ROUTE_12_GATE, 3
	warp_event  9,  5, ROUTE_12_GATE, 4

	def_bg_events

	def_object_events

	def_warps_to BIRDON
