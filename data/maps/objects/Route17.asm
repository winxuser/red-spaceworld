Route17_Object:
	db $29 ; border block

	def_warp_events

	def_bg_events
	bg_event  9, 51, TEXT_ROUTE17_NOTICE_SIGN1
	bg_event  9, 63, TEXT_ROUTE17_TRAINER_TIPS1
	bg_event  9, 75, TEXT_ROUTE17_TRAINER_TIPS2
	bg_event  9, 87, TEXT_ROUTE17_SIGN
	bg_event  9, 111, TEXT_ROUTE17_NOTICE_SIGN2
	bg_event  9, 141, TEXT_ROUTE17_CYCLING_ROAD_ENDS_SIGN

	def_object_events


	def_warps_to ROUTE_17
