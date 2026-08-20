	object_const_def
	const_export ROUTE12GATE1F_GUARD

Route12Gate_Object:
	db $00 ; border block

	def_warp_events
	warp_event  4,  0, ROUTE_12, 1
	warp_event  5,  0, ROUTE_12, 2
	warp_event  4,  7, BIRDON, 1
	warp_event  5,  7, BIRDON, 2
;	warp_event  8,  6, ROUTE_12_GATE_2F, 1

	def_bg_events

	def_object_events
	object_event  1,  3, SPRITE_GUARD, STAY, NONE, TEXT_ROUTE12GATE1F_GUARD

	def_warps_to ROUTE_12_GATE
