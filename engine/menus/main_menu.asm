MainMenu:
	call InitOptions
	xor a
	ld [wOptionsInitialized], a
	inc a
	ld [wSaveFileStatus], a
	call CheckForPlayerNameInSRAM
	jr nc, .mainMenuLoop
	predef TryLoadSaveFile

.mainMenuLoop
	ld c, 20
	rst _DelayFrames
	xor a
	ld [wLinkState], a
	ld hl, wPartyAndBillsPCSavedMenuItem
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld [wDefaultMap], a
	ld hl, wStatusFlags4
	res BIT_LINK_CONNECTED, [hl]
	call ClearScreen
	call RunDefaultPaletteCommand
	call LoadTextBoxTilePatterns
	call LoadFontTilePatterns
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, [hl]

	ld a, [wSaveFileStatus]
	cp 1
	jr z, .noSaveFile

	hlcoord 0, 0
	ld b, 6
	ld c, 13
	call TextBoxBorder
	hlcoord 2, 2
	ld de, ContinueText
	call PlaceString
	jr .next2

.noSaveFile
	hlcoord 0, 0
	ld b, 4
	ld c, 13
	call TextBoxBorder
	hlcoord 2, 2
	ld de, NewGameText
	call PlaceString

.next2
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	call UpdateSprites
	xor a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	ld [wMenuJoypadPollCount], a
	inc a
	ld [wTopMenuItemX], a
	inc a
	ld [wTopMenuItemY], a
	ld a, PAD_A | PAD_B | PAD_START
	ld [wMenuWatchedKeys], a
	ld a, [wSaveFileStatus]
	ld [wMaxMenuItem], a
	call HandleMenuInput
	bit B_PAD_B, a
	jp nz, DisplayTitleScreen

	ld c, 20
	rst _DelayFrames
	ld a, [wCurrentMenuItem]
	ld b, a
	ld a, [wSaveFileStatus]
	cp 2
	jr z, .skipInc
	inc b

.skipInc
	ld a, b
	and a
	jr z, .choseContinue
	cp 1
	jp z, StartNewGame
	call DisplayOptionMenu
	ld a, TRUE
	ld [wOptionsInitialized], a
	jp .mainMenuLoop

.choseContinue
	call DisplayContinueGameInfo
	ld hl, wCurrentMapScriptFlags
	set BIT_CUR_MAP_LOADED_1, [hl]

.inputLoop
	xor a
	ldh [hJoyPressed], a
	ldh [hJoyReleased], a
	ldh [hJoyHeld], a
	call Joypad
	ldh a, [hJoyHeld]
	bit B_PAD_A, a
	jr nz, .pressedA
	bit B_PAD_B, a
	jp nz, .mainMenuLoop
	jr .inputLoop

.pressedA
	call GBPalWhiteOutWithDelay3
	call ClearScreen
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerDirection], a
	ld c, 10
	rst _DelayFrames
	ld a, [wNumHoFTeams]
	and a
	jp z, SpecialEnterMap
	ld a, [wCurMap]
	cp HALL_OF_FAME
	jp nz, SpecialEnterMap
	xor a
	ld [wDestinationMap], a
	ld hl, wStatusFlags6
	set BIT_FLY_OR_DUNGEON_WARP, [hl]
	call PrepareForSpecialWarp
	jp SpecialEnterMap

InitOptions:
	ld a, 1 << BIT_FAST_TEXT_DELAY
	ld [wLetterPrintingDelayFlags], a
	ld a, TEXT_DELAY_MEDIUM
	ld [wOptions], a
	ret

LinkMenu:
	xor a
	ld [wLetterPrintingDelayFlags], a
	ld hl, wStatusFlags4
	set BIT_LINK_CONNECTED, [hl]
	ld hl, LinkMenuEmptyText
	rst _PrintText
	call SaveScreenTilesToBuffer1
	ld hl, WhereWouldYouLikeText
	rst _PrintText
	hlcoord 5, 5
	ld b, $6
	ld c, $d
	call TextBoxBorder
	call UpdateSprites
	hlcoord 7, 7
	ld de, CableClubOptionsText
	call PlaceString
	xor a
	ld [wUnusedLinkMenuByte], a
	ld [wCableClubDestinationMap], a
	ld hl, wTopMenuItemY
	ld a, 7
	ld [hli], a
	ASSERT wTopMenuItemY + 1 == wTopMenuItemX
	ld a, 6
	ld [hli], a
	ASSERT wTopMenuItemX + 1 == wCurrentMenuItem
	xor a
	ld [hli], a
	inc hl
	ASSERT wCurrentMenuItem + 2 == wMaxMenuItem
	ld a, 2
	ld [hli], a
	ASSERT wMaxMenuItem + 1 == wMenuWatchedKeys
	ASSERT 2 + 1 == PAD_A | PAD_B
	inc a
	ld [hli], a
	ASSERT wMenuWatchedKeys + 1 == wLastMenuItem
	xor a
	ld [hl], a

.waitForInputLoop
	call HandleMenuInput
	and PAD_A | PAD_B
	add a
	add a
	ld b, a
	ld a, [wCurrentMenuItem]
	add b
	add $d0
	ld [wLinkMenuSelectionSendBuffer], a
	ld [wLinkMenuSelectionSendBuffer + 1], a

.exchangeMenuSelectionLoop
	call Serial_ExchangeLinkMenuSelection
	ld a, [wLinkMenuSelectionReceiveBuffer]
	ld b, a
	and $f0
	cp $d0
	jr z, .checkEnemyMenuSelection
	ld a, [wLinkMenuSelectionReceiveBuffer + 1]
	ld b, a
	and $f0
	cp $d0
	jr nz, .exchangeMenuSelectionLoop

.checkEnemyMenuSelection
	ld a, b
	and $c
	jr nz, .enemyPressedAOrB
	ld a, [wLinkMenuSelectionSendBuffer]
	and $c
	jr z, .waitForInputLoop
	jr .doneChoosingMenuSelection

.enemyPressedAOrB
	ld a, [wLinkMenuSelectionSendBuffer]
	and $c
	jr z, .useEnemyMenuSelection
	ldh a, [hSerialConnectionStatus]
	cp USING_INTERNAL_CLOCK
	jr z, .doneChoosingMenuSelection

.useEnemyMenuSelection
	ld a, b
	ld [wLinkMenuSelectionSendBuffer], a
	and $3
	ld [wCurrentMenuItem], a

.doneChoosingMenuSelection
	ldh a, [hSerialConnectionStatus]
	cp USING_INTERNAL_CLOCK
	jr nz, .skipStartingTransfer
	call DelayFrame
	call DelayFrame
	ld a, SC_START | SC_INTERNAL
	ldh [rSC], a

.skipStartingTransfer
	ld b, ' '
	ld c, ' '
	ld d, '▷'
	ld a, [wLinkMenuSelectionSendBuffer]
	and PAD_B << 2
	jr nz, .updateCursorPosition
	ld a, [wCurrentMenuItem]
	cp $2
	jr z, .updateCursorPosition
	ld c, d
	ld d, b
	dec a
	jr z, .updateCursorPosition
	ld b, c
	ld c, d

.updateCursorPosition
	ld a, b
	ldcoord_a 6, 7
	ld a, c
	ldcoord_a 6, 9
	ld a, d
	ldcoord_a 6, 11
	ld c, 40
	rst _DelayFrames
	call LoadScreenTilesFromBuffer1
	ld a, [wLinkMenuSelectionSendBuffer]
	and PAD_B << 2
	jr nz, .choseCancel
	ld a, [wCurrentMenuItem]
	cp $2
	jr z, .choseCancel
	xor a
	ld [wWalkBikeSurfState], a
	ld a, [wCurrentMenuItem]
	and a
	ld a, COLOSSEUM
	jr nz, .next
	ld a, TRADE_CENTER

.next
	ld [wCableClubDestinationMap], a
	ld hl, PleaseWaitText
	rst _PrintText
	ld c, 50
	rst _DelayFrames
	ld hl, wStatusFlags6
	res BIT_DEBUG_MODE, [hl]
	ld a, [wDefaultMap]
	ld [wDestinationMap], a
	call PrepareForSpecialWarp
	ld c, 20
	rst _DelayFrames
	xor a
	ld [wMenuJoypadPollCount], a
	ld [wSerialExchangeNybbleSendData], a
	inc a
	ld [wLinkState], a
	ld [wEnteringCableClub], a
	jr SpecialEnterMap

.choseCancel
	xor a
	ld [wMenuJoypadPollCount], a
	vc_hook Wireless_net_stop
	call Delay3
	call CloseLinkConnection
	ld hl, LinkCanceledText
	vc_hook Wireless_net_end
	rst _PrintText
	ld hl, wStatusFlags4
	res BIT_LINK_CONNECTED, [hl]
	ret

WhereWouldYouLikeText: text_far _WhereWouldYouLikeText
	text_end
PleaseWaitText:         text_far _PleaseWaitText
	text_end
LinkCanceledText:       text_far _LinkCanceledText
	text_end

StartNewGame:
	ld hl, wStatusFlags6
	res BIT_DEBUG_MODE, [hl]

StartNewGameDebug:
	call OakSpeech
	ld c, 20
	rst _DelayFrames

SpecialEnterMap::
	xor a
	ldh [hJoyPressed], a
	ldh [hJoyHeld], a
	ldh [hJoy5], a
	ld [wCableClubDestinationMap], a
	ld hl, wStatusFlags6
	set BIT_GAME_TIMER_COUNTING, [hl]
	call ResetPlayerSpriteData
	ld c, 20
	rst _DelayFrames
	ld a, [wEnteringCableClub]
	and a
	ret nz
	jp EnterMap

ContinueText:
	db "CONTINUE"
	next ""

NewGameText:
	db   "NEW GAME"
	next "OPTION@"

CableClubOptionsText:
	db   "TRADE CENTER"
	next "COLOSSEUM"
	next "CANCEL@"

DisplayContinueGameInfo:
	xor a
	ldh [hAutoBGTransferEnabled], a
	hlcoord 4, 7
	ld b, 8
	ld c, 14
	call TextBoxBorder
	hlcoord 5, 9
	ld de, SaveScreenInfoText
	call PlaceString
	hlcoord 12, 9
	ld de, wPlayerName
	call PlaceString
	hlcoord 17, 11
	call PrintNumBadges
	hlcoord 16, 13
	call PrintNumOwnedMons
	hlcoord 13, 15
	call PrintPlayTime
	ld a, 1
	ldh [hAutoBGTransferEnabled], a
	ld c, 30
	jp DelayFrames

PrintSaveScreenText:
	xor a
	ldh [hAutoBGTransferEnabled], a
	hlcoord 4, 0
	ld b, $8
	ld c, $e
	call TextBoxBorder
	call LoadTextBoxTilePatterns
	call UpdateSprites
	hlcoord 5, 2
	ld de, SaveScreenInfoText
	call PlaceString
	hlcoord 12, 2
	ld de, wPlayerName
	call PlaceString
	hlcoord 17, 4
	call PrintNumBadges
	hlcoord 16, 6
	call PrintNumOwnedMons
	hlcoord 13, 8
	call PrintPlayTime
	ld a, $1
	ldh [hAutoBGTransferEnabled], a
	ld c, 30
	jp DelayFrames

PrintNumBadges:
	push hl
	ld hl, wObtainedBadges
	ld b, $1
	call CountSetBits
	pop hl
	ld de, wNumSetBits
	lb bc, 1, 2
	jp PrintNumber

PrintNumOwnedMons:
	push hl
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	pop hl
	ld de, wNumSetBits
	lb bc, 1, 3
	jp PrintNumber

PrintPlayTime:
	ld de, wPlayTimeHours
	lb bc, 1, 3
	call PrintNumber
	ld [hl], $6d
	inc hl
	ld de, wPlayTimeMinutes
	lb bc, LEADING_ZEROES | 1, 2
	jp PrintNumber

SaveScreenInfoText:
	db   "PLAYER"
	next "BADGES    "
	next "#DEX    "
	next "TIME@"

DisplayOptionMenu:
	hlcoord 0, 0
	ld b, 3
	ld c, 18
	call TextBoxBorder
	hlcoord 0, 5
	ld b, 3
	ld c, 18
	call TextBoxBorder
	hlcoord 0, 10
	ld b, 3
	ld c, 18
	call TextBoxBorder

	hlcoord 1, 1
	ld de, TextSpeedOptionText
	call PlaceString
	hlcoord 1, 6
	ld de, BattleAnimationOptionText
	call PlaceString
	hlcoord 1, 11
	ld de, BattleStyleOptionText
	call PlaceString
	hlcoord 2, 16
	ld de, OptionMenuCancelText
	call PlaceString

	xor a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	inc a
	ld [wLetterPrintingDelayFlags], a
	ld [wOptionsCancelCursorX], a
	ld a, 3
	ld [wTopMenuItemY], a
	call SetCursorPositionsFromOptions
	ld a, [wOptionsTextSpeedCursorX]
	ld [wTopMenuItemX], a
	ld a, 1
	ldh [hAutoBGTransferEnabled], a
	call Delay3

.loop
	call PlaceMenuCursor
	call SetOptionsFromCursorPositions

.getJoypadStateLoop
	call JoypadLowSensitivity
	ldh a, [hJoy5]
	ld b, a
	and ~PAD_SELECT
	jr z, .getJoypadStateLoop
	bit B_PAD_B, b
	jr nz, .exitMenu
	bit B_PAD_START, b
	jr nz, .exitMenu
	bit B_PAD_A, b
	jr z, .checkDirectionKeys
	ld a, [wTopMenuItemY]
	cp 16
	jr nz, .loop

.exitMenu
	ld a, SFX_SAVE
	rst _PlaySound
	ret

.eraseOldMenuCursor
	ld [wTopMenuItemX], a
	call EraseMenuCursor
	jr .loop

.checkDirectionKeys
	ld a, [wTopMenuItemY]
	bit B_PAD_DOWN, b
	jr nz, .downPressed
	bit B_PAD_UP, b
	jr nz, .upPressed
	cp 8
	jr z, .cursorInBattleAnimation
	cp 13
	jr z, .cursorInBattleStyle
	cp 16
	jr z, .loop

	; Cursor is in Text Speed section (Y = 3)
	bit B_PAD_LEFT, b
	jr nz, .pressedLeftInTextSpeed
	bit B_PAD_RIGHT, b
	jr nz, .pressedRightInTextSpeed
	jr .loop

.pressedLeftInTextSpeed
	ld a, [wOptionsTextSpeedCursorX]
	cp 1
	jr z, .updateTextSpeedXCoordMax
	cp 7
	jr nz, .fromMediumToFast
	sub 6 ; 7 -> 1
	jr .updateTextSpeedXCoord
.fromMediumToFast
	sub 7 ; 14 -> 7
	jr .updateTextSpeedXCoord
.updateTextSpeedXCoordMax
	ld a, 14
	jr .updateTextSpeedXCoord

.pressedRightInTextSpeed
	ld a, [wOptionsTextSpeedCursorX]
	cp 14
	jr z, .updateTextSpeedXCoordMin
	cp 7
	jr nz, .fromMediumToSlow
	add 7 ; 7 -> 14
	jr .updateTextSpeedXCoord
.fromMediumToSlow
	add 6 ; 1 -> 7
	jr .updateTextSpeedXCoord
.updateTextSpeedXCoordMin
	ld a, 1

.updateTextSpeedXCoord
	ld [wOptionsTextSpeedCursorX], a
	jr .eraseOldMenuCursor

.cursorInBattleAnimation
	ld a, [wOptionsBattleAnimCursorX]
	xor 1 ^ 10
	ld [wOptionsBattleAnimCursorX], a
	jr .eraseOldMenuCursor

.cursorInBattleStyle
	ld a, [wOptionsBattleStyleCursorX]
	xor 1 ^ 10
	ld [wOptionsBattleStyleCursorX], a
	jr .eraseOldMenuCursor

.downPressed
	cp 16
	ld b, -13
	ld hl, wOptionsTextSpeedCursorX
	jr z, .updateMenuVariables
	ld b, 5
	cp 3
	inc hl
	jr z, .updateMenuVariables
	cp 8
	inc hl
	jr z, .updateMenuVariables
	ld b, 3
	inc hl
	jr .updateMenuVariables

.upPressed
	cp 8
	ld b, -5
	ld hl, wOptionsTextSpeedCursorX
	jr z, .updateMenuVariables
	cp 13
	inc hl
	jr z, .updateMenuVariables
	cp 16
	ld b, -3
	inc hl
	jr z, .updateMenuVariables
	ld b, 13
	inc hl

.updateMenuVariables
	add b
	ld [wTopMenuItemY], a
	ld a, [hl]
	ld [wTopMenuItemX], a
	call PlaceUnfilledArrowMenuCursor
	jp .loop

TextSpeedOptionText:
	db   "TEXT SPEED"
	next " FAST  MEDIUM SLOW@"

BattleAnimationOptionText:
	db   "BATTLE ANIMATION"
	next " ON       OFF@"

BattleStyleOptionText:
	db   "BATTLE STYLE"
	next " SHIFT    SET@"

OptionMenuCancelText:
	db "CANCEL@"

SetOptionsFromCursorPositions:
	ld hl, TextSpeedOptionData
	ld a, [wOptionsTextSpeedCursorX]
	ld c, a

.loop
	ld a, [hli]
	cp c
	jr z, .textSpeedMatchFound
	inc hl
	jr .loop

.textSpeedMatchFound
	ld a, [hl]
	ld d, a
	ld a, [wOptionsBattleAnimCursorX]
	dec a
	jr z, .battleAnimationOn
	set BIT_BATTLE_ANIMATION, d

.battleAnimationOn
	ld a, [wOptionsBattleStyleCursorX]
	dec a
	jr z, .battleStyleShift
	set BIT_BATTLE_SHIFT, d

.battleStyleShift
	ld a, d
	ld [wOptions], a
	ret

SetCursorPositionsFromOptions:
	ld hl, TextSpeedOptionData + 1
	ld a, [wOptions]
	ld c, a
	and $3f
	push bc
	ld de, 2
	call IsInArray
	pop bc
	dec hl
	ld a, [hl]
	ld [wOptionsTextSpeedCursorX], a
	hlcoord 0, 3
	call .placeUnfilledRightArrow
	sla c
	ld a, 1
	jr nc, .storeBattleAnimationCursorX
	ld a, 10

.storeBattleAnimationCursorX
	ld [wOptionsBattleAnimCursorX], a
	hlcoord 0, 8
	call .placeUnfilledRightArrow
	sla c
	ld a, 1
	jr nc, .storeBattleStyleCursorX
	ld a, 10

.storeBattleStyleCursorX
	ld [wOptionsBattleStyleCursorX], a
	hlcoord 0, 13
	call .placeUnfilledRightArrow
	hlcoord 0, 16
	ld a, 1

.placeUnfilledRightArrow
	ld e, a
	ld d, 0
	add hl, de
	ld [hl], '▷'
	ret

TextSpeedOptionData:
	db 14, TEXT_DELAY_SLOW
	db  7, TEXT_DELAY_MEDIUM
	db  1, TEXT_DELAY_FAST
	db  7, -1

CheckForPlayerNameInSRAM:
	ld a, RAMG_SRAM_ENABLE
	ld [rRAMG], a
	ld a, BMODE_ADVANCED
	ld [rBMODE], a
	ASSERT BANK(sPlayerName) == BMODE_ADVANCED
	ld [rRAMB], a
	ld b, NAME_LENGTH
	ld hl, sPlayerName

.loop
	ld a, [hli]
	cp '@'
	jr z, .found
	dec b
	jr nz, .loop
	xor a
	ld [rRAMG], a
	ld [rBMODE], a
	and a
	ret

.found
	xor a
	ld [rRAMG], a
	ld [rBMODE], a
	scf
	ret
