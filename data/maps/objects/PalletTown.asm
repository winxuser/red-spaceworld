	object_const_def
	const_export PALLETTOWN_OAK
	const_export PALLETTOWN_GIRL
	const_export PALLETTOWN_FISHER

PalletTown_Object:
	db $3b ; border block

	def_warp_events
	warp_event  5,  4, REDS_HOUSE_1F, 1
	warp_event  3, 12, BLUES_HOUSE, 1
	warp_event 14, 11, OAKS_LAB, 2

	def_bg_events
	bg_event 12, 13, TEXT_PALLETTOWN_OAKSLAB_SIGN
	bg_event 11,  7, TEXT_PALLETTOWN_SIGN
	bg_event  8,  4, TEXT_PALLETTOWN_PLAYERSHOUSE_SIGN
	bg_event  6, 12, TEXT_PALLETTOWN_RIVALSHOUSE_SIGN

	def_object_events
	object_event  6,  9, SPRITE_OAK, STAY, NONE, TEXT_PALLETTOWN_OAK
	object_event  6,  7, SPRITE_GIRL, WALK, ANY_DIR, TEXT_PALLETTOWN_GIRL
	object_event 11, 13, SPRITE_FISHER, WALK, ANY_DIR, TEXT_PALLETTOWN_FISHER

	def_warps_to PALLET_TOWN
