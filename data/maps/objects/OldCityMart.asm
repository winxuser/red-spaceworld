	object_const_def
	const_export OLDCITYMART_CLERK
	const_export OLDCITYMART_YOUNGSTER
	const_export OLDCITYMART_COOLTRAINER_M

OldCityMart_Object:
	db $00 ; border block

	def_warp_events
	warp_event  4,  7, OLD_CITY, 2
	warp_event  5,  7, OLD_CITY, 2

	def_bg_events

	def_object_events
	object_event  1,  2, SPRITE_CLERK, STAY, RIGHT, TEXT_OLDCITYMART_CLERK
	object_event 14,  5, SPRITE_YOUNGSTER, WALK, UP_DOWN, TEXT_OLDCITYMART_YOUNGSTER
	object_event  9,  2, SPRITE_COOLTRAINER_M, STAY, NONE, TEXT_OLDCITYMART_COOLTRAINER_M

	def_warps_to OLD_CITY_MART
