	object_const_def
	const_export ROUTE2GATE_OAKS_AIDE
	const_export ROUTE2GATE_YOUNGSTER

Route2Gate_Object:
	db $00 ; border block

	def_warp_events
	warp_event  8,  7, ROUTE_2, 1
	warp_event  9,  7, ROUTE_2, 1
	warp_event  0,  7, WEST_CITY, 1
	warp_event  1,  7, WEST_CITY, 1

	def_bg_events

	def_object_events
	object_event  1,  3, SPRITE_SCIENTIST, STAY, LEFT, TEXT_ROUTE2GATE_OAKS_AIDE
	object_event  8,  2, SPRITE_YOUNGSTER, WALK, LEFT_RIGHT, TEXT_ROUTE2GATE_YOUNGSTER

	def_warps_to ROUTE_2_GATE
