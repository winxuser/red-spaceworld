	object_const_def
	const_export OLDCITYPOKECENTER1F_NURSE
	const_export OLDCITYPOKECENTER1F_LINK_RECEPTIONIST

OldCityPokecenter1F_Object:
	db $00 ; border block

	def_warp_events
	warp_event  5,  7, OLD_CITY, 1
	warp_event  6,  7, OLD_CITY, 1

	def_bg_events

	def_object_events
	object_event  5,  1, SPRITE_NURSE, STAY, DOWN, TEXT_OLDCITYPOKECENTER1F_NURSE
	object_event  8,  2, SPRITE_LINK_RECEPTIONIST, STAY, DOWN, TEXT_OLDCITYPOKECENTER1F_LINK_RECEPTIONIST

	def_warps_to OLD_CITY_POKECENTER_1F
