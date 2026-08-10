	object_const_def
	const_export ROUTE9_TM_TELEPORT

Route9_Object:
	db $00 ; border block

	def_warp_events
	warp_event  6,  9, ROUTE_9_GATE, 3

	def_bg_events
	bg_event 24,  7, TEXT_ROUTE9_SIGN

	def_object_events
	object_event 10, 15, SPRITE_POKE_BALL, STAY, NONE, TEXT_ROUTE9_TM_TELEPORT, TM_TELEPORT

	def_warps_to ROUTE_9
