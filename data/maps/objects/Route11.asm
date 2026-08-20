	object_const_def

Route11_Object:
	db $45 ; border block

	def_warp_events
;	warp_event 49,  8, ROUTE_11_GATE_1F, 1
;	warp_event 49,  9, ROUTE_11_GATE_1F, 2
;	warp_event 58,  8, ROUTE_11_GATE_1F, 3
;	warp_event 58,  9, ROUTE_11_GATE_1F, 4
;	warp_event  5,  5, DIGLETTS_CAVE_ROUTE_11, 1

	def_bg_events
	bg_event  0,  5, TEXT_ROUTE11_DIGLETTSCAVE_SIGN

	def_object_events


	def_warps_to ROUTE_11
