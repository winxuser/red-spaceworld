Route1P2_Object:
	db $00 ; border block

	def_warp_events
	warp_event  8,  5, ROUTE_1_GATE_1F, 1
	warp_event  9,  5, ROUTE_1_GATE_1F, 2
	warp_event  8, 25, SILENT_HILLS, 3
	warp_event  9, 25, SILENT_HILLS, 4

	def_bg_events

	def_object_events

	def_warps_to ROUTE_1_P2
