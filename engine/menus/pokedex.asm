ShowPokedexMenu:
	call GBPalWhiteOut
	call ClearScreen
	call UpdateSprites

	ldh a, [hTileAnimations]
	push af          ; Save current animation state (On or Off)
	xor a
	ldh [hTileAnimations], a ; Force animations OFF

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
	ld b, SET_PAL_POKEDEX
;	ld b, SET_PAL_GENERIC
	call RunPaletteCommand
	callfar LoadPokedexTilePatterns
	call GBPalNormal
.doPokemonListMenu
	ld hl, wTopMenuItemY
	ld a, 2
	ld [hli], a ; top menu item Y
	ld a, 8
	ld [hli], a ; top menu item X
	inc a
	ld [wMenuWatchMovingOutOfBounds], a
	inc hl
	inc hl
	ld a, 6
	ld [hli], a ; max menu item ID
	ld [hl], PAD_UP | PAD_DOWN | PAD_LEFT | PAD_RIGHT | PAD_B | PAD_A
	call HandlePokedexListMenu
	jr c, .goToSideMenu ; if the player chose a pokemon from the list
.exitPokedex
	pop af
	ld [wListScrollOffset], a ; Restore scroll offset
	pop af
	ldh [hTileAnimations], a  ; Restore Animations

	xor a
	ld [wMenuWatchMovingOutOfBounds], a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	ldh [hJoy7], a
	ld [wUnusedOverrideSimulatedJoypadStatesIndex], a
	ld [wOverrideSimulatedJoypadStatesMask], a

	call GBPalWhiteOutWithDelay3
	call RunDefaultPaletteCommand
	jp ReloadMapData ; THIS restores the overworld graphics
.goToSideMenu
	call HandlePokedexSideMenu
	dec b
	jr z, .exitPokedex ; if the player chose Quit
	dec b
	jr z, .doPokemonListMenu ; if pokemon not seen or player pressed B button
	jp .setUpGraphics ; if pokemon data or area was shown

; handles the menu on the lower right in the pokedex screen
; OUTPUT:
; b = reason for exiting menu
; 00: showed pokemon data or area
; 01: the player chose Quit
; 02: the pokemon has not been seen yet or the player pressed the B button
HandlePokedexSideMenu:
	call PlaceUnfilledArrowMenuCursor
	ld a, [wCurrentMenuItem]
	push af
	ld b, a
	ld a, [wLastMenuItem]
	push af
	ld a, [wListScrollOffset]
	push af
	add b
	inc a
	ld [wPokedexNum], a
	ld a, [wPokedexNum]
	push af
	ld a, [wDexMaxSeenMon]
	push af ; this doesn't need to be preserved
	ld hl, wPokedexSeen
	call IsPokemonBitSet
	ld b, 2
	jr z, .exitSideMenu
	call PokedexToIndex
	ld hl, wTopMenuItemY
	ld a, 10
	ld [hli], a ; top menu item Y
	ld a, 15
	ld [hli], a ; top menu item X
	xor a
	ld [hli], a ; current menu item ID
	inc hl
	ld a, 3
	ld [hli], a ; max menu item ID
	;ld a, PAD_A | PAD_B
	ld [hli], a ; menu watched keys (A button and B button)
	xor a
	ld [hli], a ; old menu item ID
	ld [wMenuWatchMovingOutOfBounds], a
.handleMenuInput
	call HandleMenuInput
	bit B_PAD_B, a
	ld b, 2
	jr nz, .buttonBPressed
	ld a, [wCurrentMenuItem]
	and a
	jr z, .choseData
	dec a
	jr z, .choseCry
	dec a
	jr z, .choseArea
; chose Quit
	ld b, 1
.exitSideMenu
	pop af
	ld [wDexMaxSeenMon], a
	pop af
	ld [wPokedexNum], a
	pop af
	ld [wListScrollOffset], a
	pop af
	ld [wLastMenuItem], a
	pop af
	ld [wCurrentMenuItem], a
	push bc
	hlcoord 0, 3
	ld de, 20
	lb bc, ' ', 13
	call DrawTileLine ; cover up the menu cursor in the pokemon list
	pop bc
	ret

.buttonBPressed
	push bc
	hlcoord 15, 10
	ld de, 20
	lb bc, ' ', 7
	call DrawTileLine ; cover up the menu cursor in the side menu
	pop bc
	jr .exitSideMenu

.choseData
	call ShowPokedexDataInternal
	ld b, 0
	jr .exitSideMenu

; play pokemon cry
.choseCry
	ld a, [wPokedexNum]
	push af
	call PlayCry
	pop af
	ld [wPokedexNum], a
;	call GetCryData
;	rst _PlaySound
	jr .handleMenuInput

.choseArea
	predef LoadTownMap_Nest ; display pokemon areas
	ld b, 0
	jr .exitSideMenu

; handles the list of pokemon on the left of the pokedex screen
; sets carry flag if player presses A, unsets carry flag if player presses B
HandlePokedexListMenu:
	xor a
	ldh [hAutoBGTransferEnabled], a
	call ClearScreen ; Start with a fresh canvas

; --- DRAW THE LAYOUT BORDERS ---

; 1. Draw the Main Vertical Divider (Separates List from Left Side)
	hlcoord 7, 10
	ld c, 9
	call DrawPokedexVerticalLine

; 2. Draw the Horizontal Divider (Separates Sprite Box from Info Box)
;	hlcoord 0, 9
;	ld b, $64 ; Horizontal line tile
;	ld c, 7   ; Width
;	ld de, 1  ; Horizontal direction
;	call DrawTileLine

; 3. Clean up the Junction
	ld a, $66 ; Try tile $6A or $65 for a cleaner "-|" junction
	ldcoord_a 7, 9

	; REMOVED: ldcoord_a 0, 0 (This removes the stray line in the top left)

; --- DRAW OWNED/SEEN BOX (Bottom Left) ---
	hlcoord 1, 12
	ld de, PokedexSeenText
	call PlaceString
	hlcoord 1, 15
	ld de, PokedexOwnText
	call PlaceString

; --- PREPARE DATA ---
; (The rest of the logic to count bits stays the same for now)
	ld hl, wPokedexSeen
	ld b, wPokedexSeenEnd - wPokedexSeen
	call CountSetBits
	ld de, wNumSetBits
	hlcoord 3, 13 ; Moved coordinates to fit the new small box
	lb bc, 1, 3
	call PrintNumber

	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld de, wNumSetBits
	hlcoord 3, 16 ; Moved coordinates to fit the new small box
	lb bc, 1, 3
	call PrintNumber

; find the highest pokedex number...
	ld hl, wPokedexSeenEnd - 1
	ld b, (wPokedexSeenEnd - wPokedexSeen) * 8 + 1
.maxSeenPokemonLoop
	ld a, [hld]
	ld c, 8
.maxSeenPokemonInnerLoop
	dec b
	sla a
	jr c, .storeMaxSeenPokemon
	dec c
	jr nz, .maxSeenPokemonInnerLoop
	jr .maxSeenPokemonLoop

.storeMaxSeenPokemon
	ld a, b
	ld [wDexMaxSeenMon], a
.loop
	xor a
	ldh [hAutoBGTransferEnabled], a

	call PokedexDrawLiveSprite
	call Pokedex_ApplyAttributes
	ld a, 1
	ldh [hAutoBGTransferEnabled], a
	call DelayFrame

; 1. Redraw the UI Skeleton (Ensures borders don't vanish)
	hlcoord 7, 10
	ld c, 9
	call DrawPokedexVerticalLine

	hlcoord 0, 9
	ld b, $64 ; Horizontal line tile
	ld c, 7   ; Width
	ld de, 1  ; Horizontal
	call DrawTileLine ; Horizontal Divider


;	ld a, $68 ; T-junction tile
;	ldcoord_a 7, 9
;	ld a, $64 ; Top-left corner fix
;	ldcoord_a 0, 0

; 2. Redraw "Seen/Owned" Labels & Numbers
	hlcoord 1, 12
	ld de, PokedexSeenText
	call PlaceString
	hlcoord 1, 15
	ld de, PokedexOwnText
	call PlaceString

	; Redraw the actual numbers
	ld hl, wPokedexSeen
	ld b, wPokedexSeenEnd - wPokedexSeen
	call CountSetBits
	ld de, wNumSetBits
	hlcoord 3, 13
	lb bc, 1, 3
	call PrintNumber

	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld de, wNumSetBits
	hlcoord 3, 16
	lb bc, 1, 3
	call PrintNumber

; 4. Clear and Print the Pokémon List (Right Side)
	hlcoord 8, 0
	lb bc, 18, 12
	call ClearScreenArea

	hlcoord 9, 2 ; List start (Column 10 gives space for cursor + pokeball)
	ld a, [wListScrollOffset]
	ld [wPokedexNum], a
	ld d, 7
	ld a, [wDexMaxSeenMon]
	cp 7
	jr nc, .printPokemonLoop
	ld d, a
	dec a
	ld [wMaxMenuItem], a

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
	ld a, ' '
	jr z, .writeTile
	ld a, $72 ; pokeball tile
.writeTile
	ld [hl], a
	push hl
	ld hl, wPokedexSeen
	call IsPokemonBitSet
	jr nz, .getPokemonName
	ld de, .dashedLine
	jr .skipGettingName
.dashedLine
	db "----------@"
.getPokemonName
	call PokedexToIndex
	call GetMonName
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

.waitForInput
	ld a, $01
	ldh [hAutoBGTransferEnabled], a
	call Delay3
	call HandleMenuInput

	bit B_PAD_B, a
	jp nz, .buttonBPressed
	bit B_PAD_A, a
	jp nz, .buttonAPressed

	; Check if we need to scroll or just update the sprite
	bit B_PAD_UP, a
	jr nz, .upPressed
	bit B_PAD_DOWN, a
	jr nz, .downPressed
	bit B_PAD_RIGHT, a
	jp nz, .checkIfRightPressed
	bit B_PAD_LEFT, a
	jp nz, .checkIfLeftPressed

	; If no relevant button was pressed, just wait for input again
	jr .waitForInput

.upPressed
	ld a, [wCurrentMenuItem]
	and a
	jp nz, .loop ; Not at top? Just loop to update sprite
	ld a, [wListScrollOffset]
	and a
	jp z, .loop ; At very top of dex? Do nothing
	dec a
	ld [wListScrollOffset], a
	call ClearSprites
	jp .loop

.downPressed
	ld a, [wCurrentMenuItem]
	ld b, a
	ld a, [wMaxMenuItem]
	cp b
	jp nz, .loop ; Not at bottom? Just loop to update sprite
	ld a, [wDexMaxSeenMon]
	cp 7
	jp c, .loop ; Dex too short to scroll?
	sub 7
	ld b, a
	ld a, [wListScrollOffset]
	cp b
	jp z, .loop ; At very end of dex?
	inc a
	ld [wListScrollOffset], a
	call ClearSprites
	jp .loop
.checkIfRightPressed
	bit B_PAD_RIGHT, a
	jr z, .checkIfLeftPressed
; Right pressed, scroll down 7 rows
	ld a, [wDexMaxSeenMon]
	cp 7
	jp c, .loop ; can't if the list is shorter than 7
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
.checkIfLeftPressed ; scroll up 7 rows
	bit B_PAD_LEFT, a
	jr z, .buttonAPressed
; Left pressed
	ld a, [wListScrollOffset]
	sub 7
	ld [wListScrollOffset], a
	jp nc, .loop
	xor a
	ld [wListScrollOffset], a
	jp .loop
.buttonAPressed
	; 1. Calculate which Dex number is actually highlighted
	ld a, [wListScrollOffset]
	ld b, a
	ld a, [wCurrentMenuItem]
	add b
	inc a                 ; Now A = the correct Pokédex Number
	ld [wPokedexNum], a   ; Store it so the Data screen knows who to load

	; 2. Check if seen
	ld hl, wPokedexSeen
	call IsPokemonBitSet
	jp z, .waitForInput

	; 3. Transition to Data Screen
	call PokedexToIndex
    call ShowPokedexDataInternal

    ; --- THE FIX STARTS HERE ---
    callfar LoadPokedexTilePatterns ; Restore the tiles

    ; We need to force a redraw of the UI so it's not a white screen
    ld b, SET_PAL_POKEDEX
    call RunPaletteCommand
    call GBPalNormal

    ; Jump back to .loop instead of .waitForInput
    ; .loop contains the code that draws the sprite, borders, and names
    jp .loop
.buttonBPressed
	and a
	ret

; Reusable routine to draw a vertical line
; hl = starting coordinate
; c = height
DrawPokedexVerticalLine:
	ld de, SCREEN_WIDTH
	ld a, $66 ; Standard vertical border tile
.loop
	ld [hl], a
	add hl, de
	dec c
	jp nz, .loop
	ret

PokedexDrawLiveSprite:

    ; compute mon index
    ld a, [wListScrollOffset]
    ld b, a
    ld a, [wCurrentMenuItem]
    add b
    inc a
    ld [wPokedexNum], a

    ; check seen
    ld hl, wPokedexSeen
    call IsPokemonBitSet
    jr z, .unseen

    call PokedexToIndex

    ; set species FIRST
    ld a, [wPokedexNum]
    ld [wCurPartySpecies], a
    ld [wCurSpecies], a

    call GetMonHeader

    ; 🔥 1. CLEAR OLD SPRITE FIRST
    hlcoord 0, 1
    lb bc, 7, 7
    ld a, $7F
    call FillPokedexRect

    ; 🔥 2. DRAW SPRITE FIRST (no palette yet)
    hlcoord 0, 1
    call LoadFlippedFrontSpriteByMonIndex

    ; 🔥 3. NOW apply palette AFTER sprite exists
    ld b, SET_PAL_POKEDEX
    call RunPaletteCommand

    ; force update
    ld a, 2
    ldh [rWBK], a
    ld a, 1
    ld [W2_ForceBGPUpdate], a
    xor a
    ldh [rWBK], a

    ret

.unseen
    hlcoord 0, 1
    lb bc, 7, 7
    ld a, $7F
    jp FillPokedexRect

; Add this helper below or at the end of the file
FillPokedexRect:
.rowLoop
	push bc
	push hl
.colLoop
	ld [hli], a
	dec b
	jr nz, .colLoop
	pop hl
	ld de, SCREEN_WIDTH
	add hl, de
	pop bc
	dec c
	jr nz, .rowLoop
	ret

PokedexSeenText:
	db "SEEN@"

PokedexOwnText:
	db "OWN@"

PokedexContentsText:
	db "CONTENTS@"

PokedexMenuItemsText:
	db   "DATA"
	next "CRY"
	next "AREA"
	next "QUIT@"

; tests if a pokemon's bit is set in the seen or owned pokemon bit fields
; INPUT:
; [wPokedexNum] = pokedex number
; hl = address of bit field
IsPokemonBitSet:
	ld a, [wPokedexNum]
	dec a
	ld c, a
	ld b, FLAG_TEST
	predef FlagActionPredef
	ld a, c
	and a
	ret

; function to display pokedex data from outside the pokedex
ShowPokedexData:
	call GBPalWhiteOutWithDelay3
	call ClearScreen
	call UpdateSprites
	callfar LoadPokedexTilePatterns ; load pokedex tiles

; function to display pokedex data from inside the pokedex
ShowPokedexDataInternal:
	ld hl, wStatusFlags2
	set BIT_NO_AUDIO_FADE_OUT, [hl]
	ld a, $33 ; 3/7 volume
	ldh [rAUDVOL], a
	call GBPalWhiteOut ; zero all palettes
	call ClearScreen
	ld a, [wPokedexNum]
	ld [wCurPartySpecies], a
	push af
	ld b, SET_PAL_POKEDEX
	call RunPaletteCommand

	ld a, 2
	ldh [rWBK], a
	ld a, 1
	ld [W2_ForceBGPUpdate], a ; Force the colors to change
	xor a
	ldh [rWBK], a

	pop af
	ld [wPokedexNum], a
	ldh a, [hTileAnimations]
	push af
.redrawAfterMap
	xor a
	ldh [hTileAnimations], a

	hlcoord 0, 0
	ld de, 1
	lb bc, $64, SCREEN_WIDTH
	call DrawTileLine ; draw top border

	hlcoord 0, 17
	ld b, $6f
	call DrawTileLine ; draw bottom border

	hlcoord 0, 1
	ld de, 20
	lb bc, $66, $10
	call DrawTileLine ; draw left border

	hlcoord 19, 1
	ld b, $67
	call DrawTileLine ; draw right border

	ld a, $63 ; upper left corner tile
	ldcoord_a 0, 0
	ld a, $65 ; upper right corner tile
	ldcoord_a 19, 0
	ld a, $6c ; lower left corner tile
	ldcoord_a 0, 17
	ld a, $6e ; lower right corner tile
	ldcoord_a 19, 17

	hlcoord 0, 9
	ld de, PokedexDataDividerLine
	call PlaceString ; draw horizontal divider line

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
	ld d, [hl] ; de = address of pokedex entry

	hlcoord 9, 4
	call PlaceString ; print species name

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
	call PrintNumber ; print pokedex number

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
	call GetMonHeader ; load pokemon picture location
	hlcoord 1, 1
	call LoadFlippedFrontSpriteByMonIndex ; draw pokemon picture

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
	jp z, .waitForButtonPress ; if the pokemon has not been owned, don't print the height, weight, or description
	inc de ; de = address of feet (height)
	ld a, [de] ; reads feet, but a is overwritten without being used
	hlcoord 12, 6
	lb bc, 1, 2
	call PrintNumber ; print feet (height)
	ld a, '′'
	ld [hl], a
	inc de
	inc de ; de = address of inches (height)
	hlcoord 15, 6
	lb bc, LEADING_ZEROES | 1, 2
	call PrintNumber ; print inches (height)
	ld a, '″'
	ld [hl], a
; now print the weight (note that weight is stored in tenths of pounds internally)
	inc de
	inc de
	inc de ; de = address of upper byte of weight
	push de
; put weight in big-endian order at hDexWeight
	ld hl, hDexWeight
	ld a, [hl] ; save existing value of [hDexWeight]
	push af
	ld a, [de] ; a = upper byte of weight
	ld [hli], a ; store upper byte of weight in [hDexWeight]
	ld a, [hl] ; save existing value of [hDexWeight + 1]
	push af
	dec de
	ld a, [de] ; a = lower byte of weight
	ld [hl], a ; store lower byte of weight in [hDexWeight + 1]
	ld de, hDexWeight
	hlcoord 11, 8
	lb bc, 2, 5 ; 2 bytes, 5 digits
	call PrintNumber ; print weight
	hlcoord 14, 8
	ldh a, [hDexWeight + 1]
	sub 10
	ldh a, [hDexWeight]
	sbc 0
	jr nc, .next
	ld [hl], '0' ; if the weight is less than 10, put a 0 before the decimal point
.next
	inc hl
	ld a, [hli]
	ld [hld], a ; make space for the decimal point by moving the last digit forward one tile
	ld [hl], '<DOT>' ; decimal point tile
	pop af
	ldh [hDexWeight + 1], a ; restore original value of [hDexWeight + 1]
	pop af
	ldh [hDexWeight], a ; restore original value of [hDexWeight]
	pop hl
	inc hl ; hl = address of pokedex description text
	bccoord 1, 11
	ld a, %10
	ldh [hClearLetterPrintingDelayFlags], a
	call TextCommandProcessor ; print pokedex description text
	xor a
	ldh [hClearLetterPrintingDelayFlags], a
.waitForButtonPress
    call JoypadLowSensitivity
    ldh a, [hJoy5]
    ld b, a

    ; 1. Check START (Bit 3) for Cry
    bit B_PAD_START, b
    jr nz, .playCry

    ; 2. Check SELECT (Bit 2) for Map
    bit B_PAD_SELECT, b
    jr nz, .showMap

    ; 3. Check A (Bit 0) or B (Bit 1) for Exit
    ld a, b
    and PAD_A | PAD_B     ; This uses the (1 << bit) masks from your file
    jr nz, .exitData

    call DelayFrame
    jr .waitForButtonPress

.playCry
    ; We use wCurPartySpecies because it was set at the start of the routine
    ld a, [wCurPartySpecies]
    call PlayCry
    ; After the cry, go back to waiting for more buttons
    jr .waitForButtonPress

.showMap
	predef LoadTownMap_Nest

	; 1. Reload the tiles the map just wiped out
	callfar LoadPokedexTilePatterns

	; 2. Restore the colors
	ld b, SET_PAL_POKEDEX
	call RunPaletteCommand
	call GBPalNormal

	ld a, [wCurPartySpecies]
	ld [wPokedexNum], a

	; 3. Jump to the REDRAW section, NOT the start
	; If we jump to "ShowPokedexDataInternal", we crash the stack (push af).
	; We need to jump to the code right AFTER the push commands.
	jp .redrawAfterMap

.exitData
    pop af
    ldh [hTileAnimations], a
    call GBPalWhiteOut
    call ClearScreen
    call RunDefaultPaletteCommand
    ; Return to the list menu
    ret

HeightWeightText:
	db   "HT  ?′??″"
	next "WT   ???lb@"

; leftover from JPN Pokedex, where species have the suffix "Pokemon"
PokeText: ; unreferenced
	db "#@"

; horizontal line that divides the pokedex text description from the rest of the data
PokedexDataDividerLine:
	db $68, $69, $6B, $69, $6B, $69, $6B, $69, $6B, $6B
	db $6B, $6B, $69, $6B, $69, $6B, $69, $6B, $69, $6A
	db "@"

; draws a line of tiles
; INPUT:
; b = tile ID
; c = number of tile ID's to write
; de = amount to destination address after each tile (1 for horizontal, 20 for vertical)
; hl = destination address
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
	; converts the Pokédex number at [wPokedexNum] to an index
	push bc
	push hl
	ld a, [wPokedexNum]
	ld b, a
	ld c, 0
	ld hl, PokedexOrder

.loop ; go through the list until we find an entry with a matching dex number
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
	; converts the index number at [wPokedexNum] to a Pokédex number
	push bc
	push hl
	ld a, [wPokedexNum]
	dec a
	ld hl, PokedexOrder
	ld b, 0
	ld c, a
	add hl, bc
	ld a, [hl]
	ld [wPokedexNum], a
	pop hl
	pop bc
	ret

INCLUDE "data/pokemon/dex_order.asm"

Pokedex_SetAttributes:
	; 1. Set the 7x7 Sprite Area to Palette 0
	hlcoord 1, 1
	ld b, 7 ; height
	ld c, 7 ; width
	ld a, 0 ; Palette ID 0
	call .fillArea

; 1. Set the Pokéball Column (Column 9) to Palette 0 (RED)
	hlcoord 9, 0
	ld b, 18 ; height
	ld c, 1  ; width
	ld a, 0    ; Palette ID 0 (Red)
	call .fillArea

	; 2. Set the rest of the List Area (Column 10 to 19) to Palette 1 (BLUE)
	hlcoord 10, 0
	ld b, 18 ; height
	ld c, 10 ; width
	ld a, 1  ; Palette ID 1 (Standard Blue/Text)
	call .fillArea

    ; 3. Overlay Pokéball column (X = 9) with Palette 0 (RED)
    ld hl, W2_TilesetPaletteMap + 9 ; X=9, Y=0
    ld de, 20 - 1
    ld b, 18        ; full height
.pokeballLoop
    ld c, 1
.pokeballInner
    xor a           ; Palette 0 (red)
    ld [hli], a
    dec c
    jr nz, .pokeballInner
    add hl, de
    dec b
    jr nz, .pokeballLoop

.fillArea
	push hl
	push bc
.colLoop
	; This writes to VRAM Bank 1 where attributes live
	ld d, a
	ld a, 1
	ldh [rVBK], a ; Switch to VRAM Bank 1
	ld a, d
	ld [hli], a   ; Set the palette for this tile
	xor a
	ldh [rVBK], a ; Switch back to VRAM Bank 0
	dec c
	jr nz, .colLoop
	pop bc
	pop hl
	ld de, SCREEN_WIDTH
	add hl, de
	dec b
	jr nz, .fillArea
	ret

Pokedex_ApplyAttributes:
	ld a, 2
	ldh [rWBK], a ; Switch to RAM Bank 2

	; 1. Set the ENTIRE screen to Palette 1 (UI Colors)
	ld hl, W2_TilesetPaletteMap
	ld bc, 20 * 18
	ld d, 1      ; Palette 1

.fillLoop
	ld [hl], d
	inc hl
	dec bc
	ld a, b
	or c
	jr nz, .fillLoop

	; 2. Overlay the Sprite Area with Palette 0 (Pokemon Colors)
	ld hl, W2_TilesetPaletteMap + 20 ; Starts at X=0, Y=1
	ld de, 20 - 7
	ld b, 7
.pokeLoop
	ld c, 7
.pokeInnerLoop
	xor a        ; Palette 0
	ld [hli], a
	dec c
	jr nz, .pokeInnerLoop
	add hl, de
	dec b
	jr nz, .pokeLoop

	; 3. Trigger the update
	ld a, 3
	ld [W2_StaticPaletteMapChanged], a
	ld a, 1
	ld [W2_ForceBGPUpdate], a ; Tell the hardware to refresh NOW

	xor a
	ldh [rWBK], a ; Back to Bank 0
	ret
