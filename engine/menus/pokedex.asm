ShowPokedexMenu:
	call GBPalWhiteOut
	call ClearScreen
	call UpdateSprites
	ld a, [wListScrollOffset]
	push af
	xor a
	ld [wCurrentMenuItem], a
	ld [wListScrollOffset], a
	ld [wLastMenuItem], a
	inc a
	ld [wPokedexNum], a
	ldh [hJoy7], a
.setUpGraphics
	call GBPalWhiteOut
	call ClearScreen
	call UpdateSprites
	ld b, SET_PAL_GENERIC
	call RunPaletteCommand
	callfar LoadPokedexTilePatterns
.doPokemonListMenu
	ld hl, wTopMenuItemY
	ld a, 2
	ld [hli], a ; top menu item Y
	ld a, 10
	ld [hli], a ; top menu item X
	inc a
	ld [wMenuWatchMovingOutOfBounds], a
	inc hl
	inc hl
	ld a, 6
	ld [hli], a ; max menu item ID
	ld [hl], PAD_LEFT | PAD_RIGHT | PAD_B | PAD_A | PAD_SELECT | PAD_START
	call HandlePokedexListMenu
	jr c, .openPokemonData ; if the player chose a pokemon from the list
.exitPokedex
	xor a
	ld [wMenuWatchMovingOutOfBounds], a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	ldh [hJoy7], a
	ld [wUnusedOverrideSimulatedJoypadStatesIndex], a
	ld [wOverrideSimulatedJoypadStatesMask], a
	pop af
	ld [wListScrollOffset], a
	call GBPalWhiteOutWithDelay3
	call RunDefaultPaletteCommand
	jp ReloadMapData

.openPokemonData
	call GetSelectedPokedexNum
	push af
	ld hl, wPokedexSeen
	call IsPokemonBitSet
	pop af
	jr z, .doPokemonListMenu ; if not seen, ignore A press and return to list

	call PokedexToIndex
	call ShowPokedexDataInternal ; Call data screen as a subroutine to keep the stack balanced

	; Reload graphics and palettes cleanly upon returning from the data entry
	call GBPalWhiteOut
	call ClearScreen
	call UpdateSprites
	ld b, SET_PAL_POKEDEX
	call RunPaletteCommand
	callfar LoadPokedexTilePatterns
	jp .doPokemonListMenu

; handles the list of pokemon on the left of the pokedex screen
; sets carry flag if player presses A, unsets carry flag if player presses B
HandlePokedexListMenu:
	xor a
	ldh [hAutoBGTransferEnabled], a

; Disable tile animations so overworld water/flowers don't overwrite sprite tiles
	ldh a, [hTileAnimations]
	push af
	xor a
	ldh [hTileAnimations], a

	call DrawPokedexUIBordersAndStats

; find the highest pokedex number among the pokemon the player has seen
	ld hl, wPokedexSeenEnd - 1
	ld bc, (wPokedexSeenEnd - wPokedexSeen) * 8 + 1
.maxSeenPokemonLoop
	ld a, [hld]
	ld d, 8
.maxSeenPokemonInnerLoop
	dec bc
	sla a
	jr c, .storeMaxSeenPokemon
	dec d
	jr nz, .maxSeenPokemonInnerLoop
	jr .maxSeenPokemonLoop

.storeMaxSeenPokemon
	ld a, c
	ld [wDexMaxSeenMon], a
.loop
	xor a
	ldh [hAutoBGTransferEnabled], a

	hlcoord 1, 1
	lb bc, 7, 7
	call ClearScreenArea

	call GetSelectedPokedexNum
	push hl
	push de
	push bc
	ld hl, wPokedexSeen
	call IsPokemonBitSet
	jr z, .skipSpriteLoading

	xor a
	ldh [hAutoBGTransferPortion], a

	ld a, 1
	ldh [hAutoBGTransferEnabled], a

    ; Transfer the top and middle thirds.
	call DelayFrame
	call DelayFrame

	xor a
	ldh [hAutoBGTransferEnabled], a

	ld a, [wPokedexNum]
	push af

	call PokedexToIndex
	ld a, [wPokedexNum]
	ld [wCurPartySpecies], a
	ld [wCurSpecies], a

	call GetMonHeader

	hlcoord 1, 1
	call LoadFlippedFrontSpriteByMonIndex

	ld b, SET_PAL_POKEDEX
	call RunPaletteCommand
	call GBPalNormal

	pop af
	ld [wPokedexNum], a

.skipSpriteLoading
	pop bc
	pop de
	pop hl

	hlcoord 10, 1
	lb bc, 15, 9 ; clear inner area of the right-side list box
	call ClearScreenArea
	hlcoord 10, 3
	ld a, [wListScrollOffset]
	ld [wPokedexNum], a
	ld d, 7
	ld a, [wDexMaxSeenMon]
	cp 7
	jr nc, .printPokemonLoop
	ld d, a
	dec a
	ld [wMaxMenuItem], a
; loop to print pokemon pokedex numbers and names inside the right box
.printPokemonLoop
	ld a, [wPokedexNum]
	inc a
	ld [wPokedexNum], a
	push af
	push de
	push hl
	push hl
	ld hl, wPokedexOwned
	call IsPokemonBitSet
	pop hl
	ld de, -SCREEN_WIDTH
	add hl, de
	inc hl
	jr z, .writeTile
	ld a, $72 ; pokeball tile
.writeTile
	ld [hl], a
	push hl
	ld hl, wPokedexSeen
	call IsPokemonBitSet
	jr nz, .getPokedexPokemonName
	ld de, .dashedLine
	jr .skipGettingName
.dashedLine
	db "------<LF>@"
.getPokedexPokemonName
	ld a, [wPokedexNum]
	push af
	call PokedexToIndex
	call GetPokedexMonName
	pop af
	ld [wPokedexNum], a
.skipGettingName
	pop hl
	inc hl
	call PlaceString
	pop hl
	ld bc, 2 * SCREEN_WIDTH
	add hl, bc
	pop de
	pop af
	ld [wPokedexNum], a
	dec d
	jr nz, .printPokemonLoop

	; Draw the menu cursor at the current menu item position
	hlcoord 10, 2
	ld a, [wCurrentMenuItem]
	ld bc, 2 * SCREEN_WIDTH
	call AddNTimes
	ld [hl], '▶'

	ld a, 01
	ldh [hAutoBGTransferEnabled], a
	call Delay3
	call GBPalNormal

.waitForInput
	call JoypadLowSensitivity
	ldh a, [hJoy5]
	and PAD_UP | PAD_DOWN | PAD_LEFT | PAD_RIGHT | PAD_A | PAD_B | PAD_SELECT | PAD_START
	jr z, .waitForInput

	; Clear current cursor arrow before moving
	push af
	hlcoord 10, 2
	ld a, [wCurrentMenuItem]
	ld bc, 2 * SCREEN_WIDTH
	call AddNTimes
	ld [hl], ' '
	pop af

	bit B_PAD_B, a
	jp nz, .buttonBPressed
	bit B_PAD_A, a
	jp nz, .buttonAPressed
	bit B_PAD_UP, a
	jr nz, .pressedUp
	bit B_PAD_DOWN, a
	jr nz, .pressedDown
	bit B_PAD_LEFT, a
	jr nz, .pressedLeft
	bit B_PAD_RIGHT, a
	jr nz, .pressedRight
	bit B_PAD_SELECT, a
	jp nz, .checkIfSelectPressed
	bit B_PAD_START, a
	jp nz, .checkIfStartPressed
	jp .loop

.pressedUp
	ld a, [wCurrentMenuItem]
	and a
	jr z, .scrollUpPage
	dec a
	ld [wCurrentMenuItem], a
	jp .loop
.scrollUpPage
	ld a, [wListScrollOffset]
	and a
	jp z, .loop
	dec a
	ld [wListScrollOffset], a
	jp .loop
.pressedDown
	ld a, [wCurrentMenuItem]
	cp 6
	jr z, .scrollDownPage
	push af
	ld a, [wListScrollOffset]
	ld b, a
	ld a, [wCurrentMenuItem]
	add b
	inc a
	ld hl, wDexMaxSeenMon
	cp [hl]
	pop af
	jp z, .loop
	inc a
	ld [wCurrentMenuItem], a
	jp .loop
.scrollDownPage
	ld a, [wDexMaxSeenMon]
	cp 7
	jp c, .loop
	sub 7
	ld b, a
	ld a, [wListScrollOffset]
	cp b
	jp z, .loop
	inc a
	ld [wListScrollOffset], a
	jp .loop
.pressedLeft
	ld a, [wListScrollOffset]
	sub 7
	ld [wListScrollOffset], a
	jp nc, .loop
	xor a
	ld [wListScrollOffset], a
	jp .loop
.pressedRight
	ld a, [wDexMaxSeenMon]
	cp 7
	jp c, .loop
	sub 6
	ld b, a
	ld a, [wListScrollOffset]
	add 7
	ld [wListScrollOffset], a
	cp b
	jp c, .loop
	dec b
	ld a, b
	ld [wListScrollOffset], a
	jp .loop

.checkIfSelectPressed
	call GetSelectedPokedexNum
	push hl
	push de
	push bc
	ld hl, wPokedexSeen
	call IsPokemonBitSet
	jr z, .skipCry
	call PokedexToIndex
	ld a, [wPokedexNum]
	push af
	call PlayCry
	pop af
.skipCry
	pop bc
	pop de
	pop hl
	jp .loop

.checkIfStartPressed
	call GetSelectedPokedexNum
	push hl
	push de
	push bc
	ld hl, wPokedexSeen
	call IsPokemonBitSet
	jr z, .skipArea
	call PokedexToIndex
	predef LoadTownMap_Nest
	call GBPalWhiteOut
	call ClearScreen
	call UpdateSprites
	ld b, SET_PAL_POKEDEX
	call RunPaletteCommand
	callfar LoadPokedexTilePatterns
	call DrawPokedexUIBordersAndStats
.skipArea
	pop bc
	pop de
	pop hl
	jp .loop

.buttonAPressed
	pop af
	ldh [hTileAnimations], a
	scf
	ret

.buttonBPressed
	pop af
	ldh [hTileAnimations], a
	and a
	ret

GetSelectedPokedexNum:
	ld a, [wListScrollOffset]
	ld b, a
	ld a, [wCurrentMenuItem]
	add b
	inc a
	ld [wPokedexNum], a
	ret

DrawPokedexUIBordersAndStats:
	hlcoord 0, 0
	lb bc, 7, 7
	call TextBoxBorder

	hlcoord 0, 9
	lb bc, 7, 7
	call TextBoxBorder

	hlcoord 9, 0
	lb bc, 16, 9
	call TextBoxBorder

	hlcoord 1, 11
	ld de, PokedexSeenText
	call PlaceString
	ld hl, wPokedexSeen
	ld b, wPokedexSeenEnd - wPokedexSeen
	call CountSetBits
	ld de, wNumSetBits
	hlcoord 3, 12
	lb bc, 1, 3
	call PrintNumber

	hlcoord 1, 15
	ld de, PokedexOwnText
	call PlaceString
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld de, wNumSetBits
	hlcoord 3, 16
	lb bc, 1, 3
	call PrintNumber
	ret

PokedexSeenText:
	db "SEEN@"

PokedexOwnText:
	db "OWN@"

IsPokemonBitSet:
	ld a, [wPokedexNum]
	dec a
	ld c, a
	ld b, FLAG_TEST
	predef FlagActionPredef
	ld a, c
	and a
	ret

ShowPokedexData:
	call GBPalWhiteOutWithDelay3
	call ClearScreen
	call UpdateSprites
	callfar LoadPokedexTilePatterns

ShowPokedexDataInternal:
	ld hl, wStatusFlags2
	set BIT_NO_AUDIO_FADE_OUT, [hl]
	ld a, $33
	ldh [rAUDVOL], a
	call GBPalWhiteOut
	call ClearScreen
	ld a, [wPokedexNum]
	ld [wCurPartySpecies], a
	push af
	ld b, SET_PAL_POKEDEX
	call RunPaletteCommand
	pop af
	ld [wPokedexNum], a
	ldh a, [hTileAnimations]
	push af
	xor a
	ldh [hTileAnimations], a

	hlcoord 0, 0
	ld de, 1
	lb bc, $64, SCREEN_WIDTH
	call DrawTileLine

	hlcoord 0, 17
	ld b, $6f
	call DrawTileLine

	hlcoord 0, 1
	ld de, 20
	lb bc, $66, $10
	call DrawTileLine

	hlcoord 19, 1
	ld b, $67
	call DrawTileLine

	ld a, $63
	ldcoord_a 0, 0
	ld a, $65
	ldcoord_a 19, 0
	ld a, $6c
	ldcoord_a 0, 17
	ld a, $6e
	ldcoord_a 19, 17

	hlcoord 0, 9
	ld de, PokedexDataDividerLine
	call PlaceString

	hlcoord 9, 6
	ld de, HeightWeightText
	call PlaceString

	call GetMonName
	hlcoord 9, 2
	call PlaceString

	ld hl, PokedexEntryPointers
	ld a, [wPokedexNum]
	dec a
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld e, a
	ld d, [hl]

	hlcoord 9, 4
	call PlaceString

	ld h, b
	ld l, c
	push de
	ld a, [wPokedexNum]
	push af
	call IndexToPokedex

	hlcoord 2, 8
	ld a, '№'
	ld [hli], a
	ld a, '<DOT>'
	ld [hli], a
	ld de, wPokedexNum
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber

	ld hl, wPokedexOwned
	call IsPokemonBitSet
	pop af
	ld [wPokedexNum], a
	ld a, [wCurPartySpecies]
	ld [wCurSpecies], a
	pop de

	push af
	push bc
	push de
	push hl

	call Delay3
	call GBPalNormal
	call GetMonHeader
	hlcoord 1, 1
	call LoadFlippedFrontSpriteByMonIndex

	ld a, [wPokedexNum]
	push af
	ld a, [wCurPartySpecies]
	call PlayCry
	pop af
	ld [wPokedexNum], a

	pop hl
	pop de
	pop bc
	pop af

	ld a, c
	and a
	jp z, .waitForButtonPress
	inc de
	ld a, [de]
	hlcoord 12, 6
	lb bc, 1, 2
	call PrintNumber
	ld a, '′'
	ld [hl], a
	inc de
	inc de
	hlcoord 15, 6
	lb bc, LEADING_ZEROES | 1, 2
	call PrintNumber
	ld a, '″'
	ld [hl], a

	inc de
	inc de
	inc de
	push de
	ld hl, hDexWeight
	ld a, [hl]
	push af
	ld a, [de]
	ld [hli], a
	ld a, [hl]
	push af
	dec de
	ld a, [de]
	ld [hl], a
	ld de, hDexWeight
	hlcoord 11, 8
	lb bc, 2, 5
	call PrintNumber
	hlcoord 14, 8
	ldh a, [hDexWeight + 1]
	sub 10
	ldh a, [hDexWeight]
	sbc 0
	jr nc, .next
	ld [hl], '0'
.next
	inc hl
	ld a, [hli]
	ld [hld], a
	ld [hl], '<DOT>'
	pop af
	ldh [hDexWeight + 1], a
	pop af
	ldh [hDexWeight], a
	pop hl
	inc hl
	bccoord 1, 11
	ld a, %10
	ldh [hClearLetterPrintingDelayFlags], a
	call TextCommandProcessor
	xor a
	ldh [hClearLetterPrintingDelayFlags], a
.waitForButtonPress
	call JoypadLowSensitivity
	ldh a, [hJoy5]
	and PAD_A | PAD_B
	jr z, .waitForButtonPress
	pop af
	ldh [hTileAnimations], a
	call GBPalWhiteOut
	call ClearScreen
	call RunDefaultPaletteCommand
	call LoadTextBoxTilePatterns
	call GBPalNormal
	ld hl, wStatusFlags2
	res BIT_NO_AUDIO_FADE_OUT, [hl]
	ld a, $77
	ldh [rAUDVOL], a
	ret

HeightWeightText:
	db   "HT  ?′??″"
	next "WT   ???lb@"

PokedexDataDividerLine:
	db $68, $69, $6B, $69, $6B, $69, $6B, $69, $6B, $6B
	db $6B, $6B, $69, $6B, $69, $6B, $69, $6B, $69, $6A
	db "@"

DrawTileLine:
	push bc
	push de
.loop
	ld [hl], b
	add hl, de
	dec c
	jr nz, .loop
	pop de
	pop bc
	ret

INCLUDE "data/pokemon/dex_entries.asm"

PokedexToIndex:
	push bc
	push hl
	ld a, [wPokedexNum]
	ld b, a
	ld c, 0
	ld hl, PokedexOrder

.loop
	inc c
	ld a, [hli]
	cp b
	jr nz, .loop

	ld a, c
	ld [wPokedexNum], a
	pop hl
	pop bc
	ret

IndexToPokedex:
	push bc
	push hl
	ld a, [wPokedexNum]
	cp 0
	jr z, .playerback
	dec a
	ld hl, PokedexOrder
	ld b, 0
	ld c, a
	add hl, bc
	ld a, [hl]
.playerback
	ld [wPokedexNum], a
	pop hl
	pop bc
	ret

INCLUDE "data/pokemon/dex_order.asm"
