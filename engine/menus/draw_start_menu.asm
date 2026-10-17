; Function that displays the start menu
DrawStartMenu::
	; Common box parameters (anchor at X=10, Y=0, Width=8)
	hlcoord 10, 0
	ld c, $08

	CheckEvent EVENT_GOT_TOWN_MAP
	ld b, $10
	jr nz, .drawTextBoxBorder

	CheckEvent EVENT_GOT_POKEDEX
	ld b, $0e
	jr nz, .drawTextBoxBorder

	ld b, $0c ; Shorter menu if no Pokedex/Town Map

.drawTextBoxBorder
	call TextBoxBorder

	; Draw clock box in top-left
	hlcoord 0, 0
	ld b, 2
	ld c, 5
	call TextBoxBorder
	call PrintStartMenuClock

	ld a, PAD_DOWN | PAD_UP | PAD_START | PAD_B | PAD_A
	ld [wMenuWatchedKeys], a
	ld a, $02
	ld [wTopMenuItemY], a ; Y position of first menu choice
	ld a, $0b
	ld [wTopMenuItemX], a ; X position of first menu choice
	ld a, [wBattleAndStartSavedMenuItem]
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	xor a
	ld [wMenuWatchMovingOutOfBounds], a

	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, [hl]
	hlcoord 12, 2

	CheckEvent EVENT_GOT_TOWN_MAP
	ld a, $08
	jr nz, .printPokedexText ; Must have Pokedex if player has Town Map

	CheckEvent EVENT_GOT_POKEDEX
	ld a, $07
	jr nz, .printPokedexText

	ld a, $06 ; No Pokedex or Town Map
	jr .storeMenuItemCount

.printPokedexText
	ld de, StartMenuPokedexText
	call PrintStartMenuItem

.storeMenuItemCount
	ld [wMaxMenuItem], a ; Number of menu items
	ld de, StartMenuPokemonText
	call PrintStartMenuItem
	ld de, StartMenuItemText
	call PrintStartMenuItem

	; Check to print town map
	CheckEvent EVENT_GOT_TOWN_MAP
	jr z, .printPlayerNameText
	ld de, StartMenuTownMapText
	call PrintStartMenuItem

.printPlayerNameText
	ld de, wPlayerName
	call PrintStartMenuItem

	ld a, [wStatusFlags4]
	bit BIT_LINK_CONNECTED, a
	ld de, StartMenuSaveText
	jr z, .printSaveOrResetText
	ld de, StartMenuResetText

.printSaveOrResetText
	call PrintStartMenuItem
	ld de, StartMenuOptionText
	call PrintStartMenuItem
	ld de, StartMenuExitText
	call PlaceString

	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	ret

PrintStartMenuClock::
	hlcoord 1, 1
	ld de, wRTCHours
	lb bc, LEADING_ZEROES | 1, 2
	call PrintNumber

	ld a, ':'
	ld [hli], a

	ld de, wRTCMinutes
	lb bc, LEADING_ZEROES | 1, 2
	jp PrintNumber ; Tail-call optimization (jp instead of call + ret)

PrintStartMenuItem:
	push hl
	call PlaceString
	pop hl
	ld de, SCREEN_WIDTH * 2
	add hl, de
	ret

; Displays a short blurb about the current selection
DrawMenuAccount::
	hlcoord 0, 13
	lb bc, 5, 10
	call ClearScreenArea

	ld a, [wStatusFlags4]
	bit BIT_LINK_CONNECTED, a
	ld de, StartMenuDescriptionTable.LinkTable
	jr nz, .check_pokedex

	CheckEvent EVENT_GOT_TOWN_MAP
	ld de, StartMenuDescriptionTable.GotTownMap
	jr nz, .check_pokedex
	ld de, StartMenuDescriptionTable

.check_pokedex
	CheckEvent EVENT_GOT_POKEDEX
	ld a, [wCurrentMenuItem]
	jr nz, .got_table
	inc a ; Offset index if Pokedex is missing

.got_table
	add a                  ; Double index for 2-byte pointer table
	ld l, a
	ld h, 0
	add hl, de             ; Add offset to table base in de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld d, h
	ld e, l

	hlcoord 0, 14
	jp PlaceString         ; Display description text cleanly

INCLUDE "data/start_menu_descriptions.asm"

; Menu Text Constants
StartMenuPokedexText: db "POKéDEX@"
StartMenuPokemonText: db "POKéMON@"
StartMenuItemText:    db "ITEM@"
StartMenuTownMapText: db "MAP@"
StartMenuSaveText:    db "SAVE@"
StartMenuResetText:   db "RESET@"
StartMenuExitText:    db "EXIT@"
StartMenuOptionText:  db "OPTION@"
