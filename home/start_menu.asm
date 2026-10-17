DisplayStartMenu::
	ld a, BANK(StartMenu_Pokedex)
	call SetRomBank
	ld a, [wWalkBikeSurfState]
	ld [wWalkBikeSurfStateCopy], a
	ld a, SFX_START_MENU
	rst _PlaySound

RedisplayStartMenu::
	farcall DrawStartMenu
	farcall PrintSafariZoneSteps
	call UpdateSprites
.loop
	farcall PrintStartMenuClock
	farcall DrawMenuAccount
	call HandleMenuInput
	ld b, a
; check if Up pressed
	bit B_PAD_UP, a
	jr z, .checkIfDownPressed
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .loop
	ld a, [wLastMenuItem]
	and a
	jr nz, .loop
; if the player tried to go past the top item, wrap around to the bottom
	CheckEvent EVENT_GOT_TOWN_MAP
	ld a, 7
	jr nz, .wrapMenuItemId
	CheckEvent EVENT_GOT_POKEDEX
	ld a, 6
	jr nz, .wrapMenuItemId
	dec a
.wrapMenuItemId
	ld [wCurrentMenuItem], a
	call EraseMenuCursor
	jr .loop
.checkIfDownPressed
	bit B_PAD_DOWN, a
	jr z, .buttonPressed
; if the player tried to go past the bottom item, wrap around to the top
	CheckEvent EVENT_GOT_TOWN_MAP
	ld a, [wCurrentMenuItem]
	ld c, 8
	jr nz, .checkIfPastBottom
	CheckEvent EVENT_GOT_POKEDEX
	ld a, [wCurrentMenuItem]
	ld c, 7
	jr nz, .checkIfPastBottom
	dec c
.checkIfPastBottom
	cp c
	jr nz, .loop
	xor a
	ld [wCurrentMenuItem], a
	call EraseMenuCursor
	jr .loop
.buttonPressed
	call PlaceUnfilledArrowMenuCursor
	ld a, [wCurrentMenuItem]
	ld [wBattleAndStartSavedMenuItem], a
	ld a, b
	and PAD_B | PAD_START
	jp nz, CloseStartMenu
	call SaveScreenTilesToBuffer2
	CheckEvent EVENT_GOT_POKEDEX
	ld a, [wCurrentMenuItem]
	jr nz, .displayMenuItem
	inc a
.displayMenuItem
	cp 0
	jp z, StartMenu_Pokedex
	cp 1
	jp z, StartMenu_Pokemon
	cp 2
	jp z, StartMenu_Item
	ld b, a
	CheckEvent EVENT_GOT_TOWN_MAP
	ld a, b
	jr nz, .displayTownMap
	inc a
	jr .displayRemainingMenuItems
.displayTownMap
	cp 3
	jp z, StartMenu_TownMap
.displayRemainingMenuItems
	cp 4
	jp z, StartMenu_TrainerInfo
	cp 5
	jp z, StartMenu_SaveReset
	cp 6
	jp z, StartMenu_Option

CloseStartMenu::
	call Joypad
	ldh a, [hJoyPressed]
	bit B_PAD_A, a
	jr nz, CloseStartMenu
	call LoadTextBoxTilePatterns
	jp CloseTextDisplay
