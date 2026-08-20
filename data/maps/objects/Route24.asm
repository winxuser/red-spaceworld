	object_const_def
	const_export ROUTE24_TM_THUNDER_WAVE

Route24_Object:
	db $7a ; border block

	def_warp_events
	warp_event  8, 30, ROUTE_24_GATE, 4
	warp_event  9, 30, ROUTE_24_GATE, 5

	def_bg_events

	def_object_events
	object_event 10,  5, SPRITE_POKE_BALL, STAY, NONE, TEXT_ROUTE24_TM_THUNDER_WAVE, TM_THUNDER_WAVE

	def_warps_to ROUTE_24
