StartMenu_Pokedex::
	predef ShowPokedexMenu
	call LoadScreenTilesFromBuffer2
	call Delay3
	call LoadGBPal
	call UpdateSprites
	jp RedisplayStartMenu

StartMenu_Pokemon::
	ld a, [wPartyCount]
	and a
	jp z, RedisplayStartMenu
	xor a
	ld [wMenuItemToSwap], a
	ld [wPartyMenuTypeOrMessageID], a
	ld [wUpdateSpritesEnabled], a
	call DisplayPartyMenu
	jr .checkIfPokemonChosen
.loop
	xor a
	ld [wMenuItemToSwap], a
	ld [wPartyMenuTypeOrMessageID], a
	call GoBackToPartyMenu
.checkIfPokemonChosen
	jr nc, .chosePokemon
.exitMenu
	call GBPalWhiteOutWithDelay3
	call RestoreScreenTilesAndReloadTilePatterns
	call LoadGBPal
	call ReloadMapData
	jp RedisplayStartMenu
.chosePokemon
	call SaveScreenTilesToBuffer1
	ld a, FIELD_MOVE_MON_MENU
	ld [wTextBoxID], a
	call DisplayTextBoxID
	ld hl, wFieldMoves
	lb bc, 2, 12
	ld e, 5
.adjustMenuVariablesLoop
	dec e
	jr z, .storeMenuVariables
	ld a, [hli]
	and a
	jr z, .storeMenuVariables
	inc b
	dec c
	dec c
	jr .adjustMenuVariablesLoop
.storeMenuVariables
	ld hl, wTopMenuItemY
	ld a, c
	ld [hli], a
	ldh a, [hFieldMoveMonMenuTopMenuItemX]
	ld [hli], a
	xor a
	ld [hli], a
	inc hl
	ld a, b
	ld [hli], a
	ld a, PAD_A | PAD_B
	ld [hli], a
	xor a
	ld [hl], a
	call HandleMenuInput
	push af
	call LoadScreenTilesFromBuffer1
	pop af
	bit B_PAD_B, a
	jp nz, .loop
	ld a, [wMaxMenuItem]
	ld b, a
	ld a, [wCurrentMenuItem]
	cp b
	jp z, .exitMenu
	dec b
	cp b
	jr z, .choseSwitch
	dec b
	cp b
	jp z, .choseStats
	ld c, a
	ld b, 0
	ld hl, wFieldMoves
	add hl, bc
	jp .choseOutOfBattleMove
.choseSwitch
	ld a, [wPartyCount]
	cp 2
	jp c, StartMenu_Pokemon
	call SwitchPartyMon_InitVarOrSwapData
	ld a, SWAP_MONS_PARTY_MENU
	ld [wPartyMenuTypeOrMessageID], a
	call GoBackToPartyMenu
	jp .checkIfPokemonChosen
.choseStats
	call ClearSprites
	xor a
	ld [wMonDataLocation], a
	predef StatusScreen
	call ReloadMapData
	jp StartMenu_Pokemon
.choseOutOfBattleMove
	push hl
	ld a, [wWhichPokemon]
	ld hl, wPartyMonNicks
	call GetPartyMonName
	pop hl
	ld a, [hl]
	dec a
	add a
	ld b, 0
	ld c, a
	ld hl, .outOfBattleMovePointers
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wObtainedBadges]
	jp hl
.outOfBattleMovePointers
	dw .cut
	dw .fly
	dw .surf
	dw .strength
	dw .flash
	dw .dig
	dw .teleport
	dw .softboiled
.fly
	bit BIT_THUNDERBADGE, a
	jp z, .newBadgeRequired
	call CheckIfInOutsideMap
	jr z, .canFly
	ld a, [wCurMap]
	cp CELADON_MART_ROOF
	jr z, .canFly
	cp CELADON_MANSION_ROOF
	jr z, .canFly
	cp VERMILION_DOCK
	jr z, .canFly
	cp SS_ANNE_BOW
	jr z, .canFly
	cp OLD_CITY
	jr z, .canFly
	cp WEST_CITY
	jr z, .canFly
	cp BIRDON
	jr z, .canFly
	cp HIGH_TECH
	jr z, .canFly
	cp FONT
	jr z, .canFly
	cp SOUTH_CITY
	jr z, .canFly
	cp NEW_TYPE
	jr z, .canFly
	cp PRINCE
	jr z, .canFly
	cp KANTO
	jr z, .canFly
	cp BLUE_FOREST
	jr z, .canFly
	cp NORTH_CITY
	jr z, .canFly
	ld a, [wWhichPokemon]
	ld hl, wPartyMonNicks
	call GetPartyMonName
	ld hl, .cannotFlyHereText
	rst _PrintText
	jp .loop
.canFly
	call ChooseFlyDestination
	ld a, [wStatusFlags6]
	bit BIT_FLY_WARP, a
	jp nz, .goBackToMap
	call LoadFontTilePatterns
	ld hl, wStatusFlags4
	set BIT_UNKNOWN_4_1, [hl]
	jp StartMenu_Pokemon
.cut
	bit BIT_CASCADEBADGE, a
	jp z, .newBadgeRequired
	predef UsedCut
	ld a, [wActionResultOrTookBattleTurn]
	and a
	jp z, .loop
	jp CloseTextDisplay
.surf
	bit BIT_SOULBADGE, a
	jp z, .newBadgeRequired
	farcall IsSurfingAllowed
	ld hl, wStatusFlags1
	bit BIT_SURF_ALLOWED, [hl]
	res BIT_SURF_ALLOWED, [hl]
	jp z, .loop
	ld a, SURFBOARD
	ld [wCurItem], a
	ld [wPseudoItemID], a
	call UseItem
	ld a, [wActionResultOrTookBattleTurn]
	and a
	jp z, .loop
	call GBPalWhiteOutWithDelay3
	jp .goBackToMap
.strength
	bit BIT_RAINBOWBADGE, a
	jp z, .newBadgeRequired
	predef PrintStrengthText
	call GBPalWhiteOutWithDelay3
	jp .goBackToMap
.flash
	bit BIT_BOULDERBADGE, a
	jp z, .newBadgeRequired
	xor a
	ld [wMapPalOffset], a
	ld hl, .flashLightsAreaText
	rst _PrintText
	call GBPalWhiteOutWithDelay3
	jp .goBackToMap
.flashLightsAreaText
	text_far _FlashLightsAreaText
	text_end
.dig
	ld a, ESCAPE_ROPE
	ld [wCurItem], a
	ld [wPseudoItemID], a
	call UseItem
	ld a, [wActionResultOrTookBattleTurn]
	and a
	jp z, .loop
	call GBPalWhiteOutWithDelay3
	jp .goBackToMap
.teleport
	call CheckIfInOutsideMap
	jr z, .canTeleport
	ld a, [wWhichPokemon]
	ld hl, wPartyMonNicks
	call GetPartyMonName
	ld hl, .cannotUseTeleportNowText
	rst _PrintText
	jp .loop
.canTeleport
	ld hl, .warpToLastPokemonCenterText
	rst _PrintText
	ld hl, wStatusFlags6
	set BIT_FLY_WARP, [hl]
	set BIT_ESCAPE_WARP, [hl]
	ld hl, wStatusFlags4
	set BIT_UNKNOWN_4_1, [hl]
	res BIT_NO_BATTLES, [hl]
	ld c, 60
	rst _DelayFrames
	call GBPalWhiteOutWithDelay3
	jp .goBackToMap
.warpToLastPokemonCenterText
	text_far _WarpToLastPokemonCenterText
	text_end
.cannotUseTeleportNowText
	text_far _CannotUseTeleportNowText
	text_end
.cannotFlyHereText
	text_far _CannotFlyHereText
	text_end
.softboiled
	ld hl, wPartyMon1MaxHP
	ld a, [wWhichPokemon]
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld a, [hli]
	ldh [hDividend], a
	ld a, [hl]
	ldh [hDividend + 1], a
	ld a, 5
	ldh [hDivisor], a
	ld b, 2
	call Divide
	ld bc, MON_HP - MON_MAXHP
	add hl, bc
	ld a, [hld]
	ld b, a
	ldh a, [hQuotient + 3]
	sub b
	ld b, [hl]
	ldh a, [hQuotient + 2]
	sbc b
	jp nc, .notHealthyEnough
	ld a, [wPartyAndBillsPCSavedMenuItem]
	push af
	ld a, POTION
	ld [wCurItem], a
	ld [wPseudoItemID], a
	call UseItem
	pop af
	ld [wPartyAndBillsPCSavedMenuItem], a
	jp .loop
.notHealthyEnough
	ld hl, .notHealthyEnoughText
	rst _PrintText
	jp .loop
.notHealthyEnoughText
	text_far _NotHealthyEnoughText
	text_end
.goBackToMap
	call RestoreScreenTilesAndReloadTilePatterns
	call ReloadMapData
	jp CloseTextDisplay
.newBadgeRequired
	ld hl, .newBadgeRequiredText
	rst _PrintText
	jp .loop
.newBadgeRequiredText
	text_far _NewBadgeRequiredText
	text_end

ErasePartyMenuCursors::
	hlcoord 0, 1
	ld bc, 2 * SCREEN_WIDTH
	ld a, 6
.loop
	ld [hl], ' '
	add hl, bc
	dec a
	jr nz, .loop
	ret

ItemMenuLoop:
	call LoadScreenTilesFromBuffer2DisableBGTransfer
	call ReloadMapData
	call RunDefaultPaletteCommand

StartMenu_Item::
	ld a, [wLinkState]
	dec a
	jr nz, .notInCableClubRoom
	ld hl, CannotUseItemsHereText
	rst _PrintText
	jr .exitMenu
.notInCableClubRoom
	ld bc, wNumBagItems
	ld hl, wListPointer
	ld a, c
	ld [hli], a
	ld [hl], b
	xor a
	ld [wPrintItemPrices], a
	ld a, ITEMLISTMENU
	ld [wListMenuID], a
	ld a, [wBagSavedMenuItem]
	ld [wCurrentMenuItem], a
	call DisplayListMenuID
	ld a, [wCurrentMenuItem]
	ld [wBagSavedMenuItem], a
	jr nc, .choseItem
.exitMenu
	call LoadScreenTilesFromBuffer2
	call LoadTextBoxTilePatterns
	call UpdateSprites
	call ReloadMapData
	jp RedisplayStartMenu
.choseItem
	ld a, ' '
	ldcoord_a 5, 4
	ldcoord_a 5, 6
	ldcoord_a 5, 8
	ldcoord_a 5, 10
	call PlaceUnfilledArrowMenuCursor
	xor a
	ld [wMenuItemToSwap], a
	ld a, [wCurItem]
	cp BICYCLE
	jp z, .useOrTossItem
	ld a, USE_TOSS_MENU_TEMPLATE
	ld [wTextBoxID], a
	call DisplayTextBoxID
	ld hl, wTopMenuItemY
	ld a, 11
	ld [hli], a
	ld a, 14
	ld [hli], a
	xor a
	ld [hli], a
	inc hl
	inc a
	ld [hli], a
	ld a, PAD_A | PAD_B
	ld [hli], a
	xor a
	ld [hl], a
	call HandleMenuInput
	call PlaceUnfilledArrowMenuCursor
	bit B_PAD_B, a
	jr z, .useOrTossItem
	jp ItemMenuLoop
.useOrTossItem
	ld a, [wCurItem]
	ld [wNamedObjectIndex], a
	call GetItemName
	call CopyToStringBuffer
	ld a, [wCurItem]
	cp BICYCLE
	jr nz, .notBicycle
	ld a, [wStatusFlags6]
	bit BIT_ALWAYS_ON_BIKE, a
	jr z, .useItem_closeMenu
	ld hl, CannotGetOffHereText
	rst _PrintText
	jp ItemMenuLoop
.notBicycle
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .tossItem
	ld [wPseudoItemID], a
	ld a, [wCurItem]
	cp HM01
	jr nc, .useItem_partyMenu
	ld hl, UsableItems_CloseMenu
	ld de, 1
	call IsInArray
	jr c, .useItem_closeMenu
	ld a, [wCurItem]
	ld hl, UsableItems_PartyMenu
	ld de, 1
	call IsInArray
	jr c, .useItem_partyMenu
	call UseItem
	jp ItemMenuLoop
.useItem_closeMenu
	xor a
	ld [wPseudoItemID], a
	call UseItem
	ld a, [wActionResultOrTookBattleTurn]
	and a
	jp z, ItemMenuLoop
	jp CloseStartMenu
.useItem_partyMenu
	ld a, [wUpdateSpritesEnabled]
	push af
	call UseItem
	ld a, [wActionResultOrTookBattleTurn]
	cp 2
	jp z, .partyMenuNotDisplayed
	call GBPalWhiteOutWithDelay3
	call RestoreScreenTilesAndReloadTilePatterns
	call ReloadMapData
	pop af
	ld [wUpdateSpritesEnabled], a
	jp StartMenu_Item
.partyMenuNotDisplayed
	pop af
	ld [wUpdateSpritesEnabled], a
	jp ItemMenuLoop
.tossItem
	call IsKeyItem
	ld a, [wIsKeyItem]
	and a
	jr nz, .skipAskingQuantity
	ld a, [wCurItem]
	call IsItemHM
	jr c, .skipAskingQuantity
	call DisplayChooseQuantityMenu
	inc a
	jr z, .tossZeroItems
.skipAskingQuantity
	ld hl, wNumBagItems
	call TossItem
.tossZeroItems
	jp ItemMenuLoop

CannotUseItemsHereText: text_far _CannotUseItemsHereText
	text_end
CannotGetOffHereText:   text_far _CannotGetOffHereText
	text_end

INCLUDE "data/items/use_party.asm"
INCLUDE "data/items/use_overworld.asm"

StartMenu_TownMap::
	call GBPalWhiteOut
	call ClearScreen
	call UpdateSprites
	ldh a, [hTileAnimations]
	push af
	xor a
	ldh [hTileAnimations], a
	farcall ItemUseTownMap
	call GBPalWhiteOut
	call LoadFontTilePatterns
	call LoadScreenTilesFromBuffer2
	call RunDefaultPaletteCommand
	call ReloadMapData
	call LoadGBPal
	pop af
	ldh [hTileAnimations], a
	call DrawStartMenu
	jp RedisplayStartMenu

StartMenu_TrainerInfo::
	call GBPalWhiteOut
	call ClearScreen
	call UpdateSprites
	ldh a, [hTileAnimations]
	push af
	xor a
	ldh [hTileAnimations], a
	call DrawTrainerInfo
	predef DrawBadges
	ld b, SET_PAL_TRAINER_CARD
	call RunPaletteCommand
	call GBPalNormal
	call WaitForTextScrollButtonPress
	call GBPalWhiteOut
	call LoadFontTilePatterns
	call LoadScreenTilesFromBuffer2
	call RunDefaultPaletteCommand
	call ReloadMapData
	call LoadGBPal
	pop af
	ldh [hTileAnimations], a
	jp RedisplayStartMenu

DrawTrainerInfo:
	ld de, RedPicFront
	lb bc, BANK(RedPicFront), 1
	ld a, [wPlayerGender]
	and a
	jr z, .AreBoy
	ld de, GreenPicFront
	lb bc, BANK(GreenPicFront), 1
.AreBoy
	predef DisplayPicCenteredOrUpperRight
	call DisableLCD
	hlcoord 0, 2
	ld a, ' '
	call TrainerInfo_DrawVerticalLine
	hlcoord 1, 2
	call TrainerInfo_DrawVerticalLine
	ld hl, vChars2 tile 7
	ld de, vChars2 tile 0
	ld bc, $1c tiles
	rst _CopyData
	ld hl, TrainerInfoTextBoxTileGraphics
	ld de, vChars2 tile $77
	ld bc, 8 tiles
	push bc
	call TrainerInfo_FarCopyData
	ld hl, BlankLeaderNames
	ld de, vChars2 tile $60
	ld bc, $17 tiles
	call TrainerInfo_FarCopyData
	pop bc
	ld hl, BadgeNumbersTileGraphics
	ld de, vChars1 tile $58
	call TrainerInfo_FarCopyData
	ld hl, GymLeaderFaceAndBadgeTileGraphics
	ld de, vChars2 tile $20
	ld bc, 8 * 8 tiles
	ld a, BANK(GymLeaderFaceAndBadgeTileGraphics)
	call FarCopyData2
	ld hl, TextBoxGraphics
	ld de, 13 tiles
	add hl, de
	ld de, vChars1 tile $56
	ld bc, TILE_SIZE
	ld a, BANK(TextBoxGraphics)
	push bc
	call FarCopyData2
	pop bc
	ld hl, TrainerInfoTextBoxTileGraphics tile 8
	ld de, vChars1 tile $57
	call TrainerInfo_FarCopyData
	call EnableLCD
	ld hl, wTrainerInfoTextBoxWidthPlus1
	ld a, 18 + 1
	ld [hli], a
	dec a
	ld [hli], a
	ld [hl], 1
	hlcoord 0, 0
	call TrainerInfo_DrawTextBox
	ld hl, wTrainerInfoTextBoxWidthPlus1
	ld a, 16 + 1
	ld [hli], a
	dec a
	ld [hli], a
	ld [hl], 3
	hlcoord 1, 10
	call TrainerInfo_DrawTextBox
	hlcoord 0, 10
	ld a, $d7
	call TrainerInfo_DrawVerticalLine
	hlcoord 19, 10
	call TrainerInfo_DrawVerticalLine
	hlcoord 6, 9
	ld de, TrainerInfo_BadgesText
	call PlaceString
	hlcoord 2, 2
	ld de, TrainerInfo_NameMoneyTimeText
	call PlaceString
	hlcoord 7, 2
	ld de, wPlayerName
	call PlaceString
	hlcoord 8, 4
	ld de, wPlayerMoney
	ld c, 3 | LEADING_ZEROES | LEFT_ALIGN | MONEY_SIGN
	call PrintBCDNumber
	hlcoord 9, 6
	ld de, wPlayTimeHours
	lb bc, LEFT_ALIGN | 1, 3
	call PrintNumber
	ld [hl], $d6
	inc hl
	ld de, wPlayTimeMinutes
	lb bc, LEADING_ZEROES | 1, 2
	jp PrintNumber

TrainerInfo_FarCopyData:
	ld a, BANK(TrainerInfoTextBoxTileGraphics)
	jp FarCopyData2

TrainerInfo_NameMoneyTimeText:
	db   "NAME/"
	next "MONEY/"
	next "TIME/@"

TrainerInfo_BadgesText:
	db $76, "BADGES", $76, "@"

TrainerInfo_DrawTextBox:
	ld a, $79
	lb de, $7a, $7b
	call TrainerInfo_DrawHorizontalEdge
	call TrainerInfo_NextTextBoxRow
	ld a, [wTrainerInfoTextBoxWidthPlus1]
	ld e, a
	ld d, 0
	ld c, 6
.loop
	ld [hl], $7c
	add hl, de
	ld [hl], $78
	call TrainerInfo_NextTextBoxRow
	dec c
	jr nz, .loop
	ld a, $7d
	lb de, $77, $7e

TrainerInfo_DrawHorizontalEdge:
	ld [hli], a
	ld a, [wTrainerInfoTextBoxWidth]
	ld c, a
	ld a, d
.loop
	ld [hli], a
	dec c
	jr nz, .loop
	ld a, e
	ld [hl], a
	ret

TrainerInfo_NextTextBoxRow:
	ld a, [wTrainerInfoTextBoxNextRowOffset]
.loop
	inc hl
	dec a
	jr nz, .loop
	ret

TrainerInfo_DrawVerticalLine:
	ld de, SCREEN_WIDTH
	ld c, 8
.loop
	ld [hl], a
	add hl, de
	dec c
	jr nz, .loop
	ret

StartMenu_SaveReset::
	ld a, [wStatusFlags4]
	bit BIT_LINK_CONNECTED, a
	jp nz, SoftReset
	predef SaveMenu
	call LoadScreenTilesFromBuffer2
	jp HoldTextDisplayOpen

StartMenu_Option::
	xor a
	ldh [hAutoBGTransferEnabled], a
	call ClearScreen
	call UpdateSprites
	callfar DisplayOptionMenu
	call LoadScreenTilesFromBuffer2
	call LoadTextBoxTilePatterns
	call UpdateSprites
	jp RedisplayStartMenu

SwitchPartyMon::
	call SwitchPartyMon_InitVarOrSwapData
	ld a, [wSwappedMenuItem]
	call SwitchPartyMon_ClearGfx
	ld a, [wCurrentMenuItem]
	call SwitchPartyMon_ClearGfx
	jp RedrawPartyMenu_

SwitchPartyMon_ClearGfx:
	push af
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH * 2
	call AddNTimes
	ld c, SCREEN_WIDTH * 2
	ld a, ' '
.clearMonBGLoop
	ld [hli], a
	dec c
	jr nz, .clearMonBGLoop
	pop af
	ld hl, wShadowOAMSprite00YCoord
	ld bc, OBJ_SIZE * 4
	call AddNTimes
	ld de, OBJ_SIZE
	ld c, e
.clearMonOAMLoop
	ld [hl], SCREEN_HEIGHT_PX + OAM_Y_OFS
	add hl, de
	dec c
	jr nz, .clearMonOAMLoop
	call WaitForSoundToFinish
	ld a, SFX_SWAP
	jp PlaySound

SwitchPartyMon_InitVarOrSwapData:
	ld a, [wMenuItemToSwap]
	and a
	jr nz, .pickedMonsToSwap
	ld a, [wWhichPokemon]
	inc a
	ld [wMenuItemToSwap], a
	ret
.pickedMonsToSwap
	xor a
	ld [wPartyMenuTypeOrMessageID], a
	ld a, [wMenuItemToSwap]
	dec a
	ld b, a
	ld a, [wCurrentMenuItem]
	ld [wSwappedMenuItem], a
	cp b
	jr nz, .swappingDifferentMons
	xor a
	ld [wMenuItemToSwap], a
	ld [wPartyMenuTypeOrMessageID], a
	ret
.swappingDifferentMons
	ld a, b
	ld [wMenuItemToSwap], a
	push hl
	push de
	ld hl, wPartySpecies
	ld d, h
	ld e, l
	ld a, [wCurrentMenuItem]
	add l
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	ld a, [wMenuItemToSwap]
	add e
	ld e, a
	jr nc, .noCarry2
	inc d
.noCarry2
	ld a, [hl]
	ldh [hSwapTemp], a
	ld a, [de]
	ld [hl], a
	ldh a, [hSwapTemp]
	ld [de], a
	ld hl, wPartyMons
	ld bc, PARTYMON_STRUCT_LENGTH
	ld a, [wCurrentMenuItem]
	call AddNTimes
	push hl
	ld de, wSwitchPartyMonTempBuffer
	ld bc, PARTYMON_STRUCT_LENGTH
	rst _CopyData
	ld hl, wPartyMons
	ld bc, PARTYMON_STRUCT_LENGTH
	ld a, [wMenuItemToSwap]
	call AddNTimes
	pop de
	push hl
	ld bc, PARTYMON_STRUCT_LENGTH
	rst _CopyData
	pop de
	ld hl, wSwitchPartyMonTempBuffer
	ld bc, PARTYMON_STRUCT_LENGTH
	rst _CopyData
	ld hl, wPartyMonOT
	ld a, [wCurrentMenuItem]
	call SkipFixedLengthTextEntries
	push hl
	ld de, wSwitchPartyMonTempBuffer
	ld bc, NAME_LENGTH
	rst _CopyData
	ld hl, wPartyMonOT
	ld a, [wMenuItemToSwap]
	call SkipFixedLengthTextEntries
	pop de
	push hl
	ld bc, NAME_LENGTH
	rst _CopyData
	pop de
	ld hl, wSwitchPartyMonTempBuffer
	ld bc, NAME_LENGTH
	rst _CopyData
	ld hl, wPartyMonNicks
	ld a, [wCurrentMenuItem]
	call SkipFixedLengthTextEntries
	push hl
	ld de, wSwitchPartyMonTempBuffer
	ld bc, NAME_LENGTH
	rst _CopyData
	ld hl, wPartyMonNicks
	ld a, [wMenuItemToSwap]
	call SkipFixedLengthTextEntries
	pop de
	push hl
	ld bc, NAME_LENGTH
	rst _CopyData
	pop de
	ld hl, wSwitchPartyMonTempBuffer
	ld bc, NAME_LENGTH
	rst _CopyData
	ld a, [wMenuItemToSwap]
	ld [wSwappedMenuItem], a
	xor a
	ld [wMenuItemToSwap], a
	ld [wPartyMenuTypeOrMessageID], a
	pop de
	pop hl
	ret
