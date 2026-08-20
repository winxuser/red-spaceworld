	object_const_def
	const_export ROUTE25_TM_SEISMIC_TOSS

Route25_Object:
	db $21 ; border block

	def_warp_events
	warp_event 42,  0, BILLS_HOUSE, 1

	def_bg_events
	bg_event 41,  0, TEXT_ROUTE25_BILL_SIGN

	def_object_events
	object_event 40,  0, SPRITE_POKE_BALL, STAY, NONE, TEXT_ROUTE25_TM_SEISMIC_TOSS, TM_SEISMIC_TOSS

	def_warps_to ROUTE_25
