	object_const_def
	const_export REDSHOUSE1F_MOM

RedsHouse1F_Object:
	db $00 ; border block

	def_warp_events
	warp_event  6,  7, LAST_MAP, 1
	warp_event  7,  7, LAST_MAP, 1
	warp_event  9,  0, REDS_HOUSE_2F, 1

	def_bg_events
	bg_event  4,  1, TEXT_REDSHOUSE1F_TV

	def_object_events
	object_event  7,  4, SPRITE_MOM, STAY, LEFT, TEXT_REDSHOUSE1F_MOM

	def_warps_to REDS_HOUSE_1F
