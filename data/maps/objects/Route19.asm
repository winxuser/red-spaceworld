	object_const_def

Route19_Object:
	db $21 ; border block

	def_warp_events
	warp_event  8, 12, NEW_TYPE, 1
	warp_event  9, 12, NEW_TYPE, 2
	warp_event  8, 12, ROUTE_18_GATE, 3
	warp_event  9, 12, ROUTE_18_GATE, 4

	def_bg_events
	bg_event 11,  9, TEXT_ROUTE19_SIGN

	def_object_events

	def_warps_to ROUTE_19
