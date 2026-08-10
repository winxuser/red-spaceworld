	object_const_def
;	const_export ROUTE7GATE_GUARD

Route7Gate_Object:
	db $00 ; border block

	def_warp_events
	warp_event  4,  0, SOUTH_CITY, 1
	warp_event  5,  0, SOUTH_CITY, 2
	warp_event  4,  7, ROUTE_7, 1
	warp_event  5,  7, ROUTE_7, 2

	def_bg_events

	def_object_events
;	object_event  3,  1, SPRITE_GUARD, STAY, DOWN, TEXT_ROUTE7GATE_GUARD

	def_warps_to ROUTE_7_GATE
