Route22_Object:
	db $7a ; border block

	def_warp_events
	warp_event 28,  5, ROUTE_21_GATE, 3
	warp_event 29,  5, ROUTE_21_GATE, 4

	def_bg_events
	bg_event  7, 11, TEXT_ROUTE22_POKEMON_LEAGUE_SIGN

	def_object_events

	def_warps_to ROUTE_22
