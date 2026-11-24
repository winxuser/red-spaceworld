; Helper functions for oak intro

GetNidorinoPalID:
	call ClearScreen
IF GEN_2_GRAPHICS
	ld a, PAL_INTRO_NIDORINO
ELSE
	ld a, PAL_PURPLEMON
ENDC
	jr GotPalID

GetRedPalID:
	call ClearScreen
	farcall GetPlayerPaletteIDFar
	ld a, d
	jr GotPalID

GetRivalPalID:
	call ClearScreen
IF GEN_2_GRAPHICS
	ld a, RIVAL1
	jr LoadIntroTrainerPalette
ELSE
	ld a, PAL_MEWMON
	jr GotPalID
ENDC

GetOakPalID:
IF GEN_2_GRAPHICS
	ld a, PROF_OAK
	jr LoadIntroTrainerPalette
ELSE
	ld a, PAL_BROWNMON
	jr GotPalID
ENDC

; a = trainer class
LoadIntroTrainerPalette:
	ld d, a
	ld e, 0

	ld a, 2
	ldh [rWBK], a

	farcall LoadTrainerPortraitPalette

	xor a
	ldh [rWBK], a
	ret

GotPalID:
	ld e, 0
	ld d, a

	ld a, 2
	ldh [rWBK], a
	CALL_INDIRECT LoadSGBPalette
	xor a
	ldh [rWBK], a
	ret

