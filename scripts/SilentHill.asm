SilentHill_Script:
	CheckEvent EVENT_GOT_POKEBALLS_FROM_OAK
	jr z, .next
	SetEvent EVENT_SILENT_AFTER_GETTING_POKEBALLS
.next
	call EnableAutoTextBoxDrawing
	ld hl, SilentHill_ScriptPointers
	ld a, [wSilentHillCurScript]
	jp CallFunctionInTable

SilentHill_ScriptPointers:
	def_script_pointers
	dw_const SilentHillDefaultScript,              SCRIPT_SILENTHILL_DEFAULT
	dw_const SilentHillOakHeyWaitScript,           SCRIPT_SILENTHILL_OAK_HEY_WAIT
	dw_const SilentHillOakWalksToPlayerScript,     SCRIPT_SILENTHILL_OAK_WALKS_TO_PLAYER
	dw_const SilentHillOakNotSafeComeWithMeScript, SCRIPT_SILENTHILL_OAK_NOT_SAFE_COME_WITH_ME
	dw_const SilentHillPlayerFollowsOakScript,     SCRIPT_SILENTHILL_PLAYER_FOLLOWS_OAK
	dw_const SilentHillDaisyScript,                SCRIPT_SILENTHILL_DAISY
	dw_const SilentHillNoopScript,                 SCRIPT_SILENTHILL_NOOP

SilentHillDefaultScript:
	CheckEvent EVENT_FOLLOWED_OAK_INTO_LAB
	ret nz
; Check Y-coordinates first
	ld a, [wYCoord]
	cp 8
	jr z, .checkXCoord
	cp 9
	ret nz

.checkXCoord
	; Narrow it down to column 3
	ld a, [wXCoord]
	cp 3
	ret nz
	xor a
	ldh [hJoyHeld], a
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	ld a, SFX_STOP_ALL_MUSIC
	call PlaySound
	ld a, 0 ; BANK(Music_MeetProfOak)
	ld c, a
	ld a, MUSIC_MEET_PROF_OAK ; "oak appears" music
	call PlayMusic
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	SetEvent EVENT_OAK_APPEARED_IN_SILENT

	; trigger the next script
	ld a, SCRIPT_SILENTHILL_OAK_HEY_WAIT
	ld [wSilentHillCurScript], a
	ret

SilentHillOakHeyWaitScript:
	xor a
	ld [wOakWalkedToPlayer], a
	ld a, TEXT_SILENTHILL_OAK
	ldh [hTextID], a
	call DisplayTextID
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, TOGGLE_SILENT_HILL_OAK
	ld [wToggleableObjectIndex], a
	predef ShowObject

	; trigger the next script
	ld a, SCRIPT_SILENTHILL_OAK_WALKS_TO_PLAYER
	ld [wSilentHillCurScript], a
	ret

SilentHillOakWalksToPlayerScript:
	ld a, SPRITE_FACING_RIGHT
	ld [wSpritePlayerStateData1FacingDirection], a

	ld a, SPRITE_FACING_RIGHT
	ld [wSpritePlayerStateData1 + 2], a

	ld a, SILENTHILL_OAK
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_LEFT
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	call Delay3

	; Set up the sprite index for the movement engine
	ld a, SILENTHILL_OAK
	ld [wSpriteIndex], a

	; Reset the function pointer index to 0 (PalletMovementScript_OakMoveLeft)
	xor a
	ld [wNPCMovementScriptFunctionNum], a
	ld [wNPCMovementScriptSpriteOffset], a

	; Directly call your custom movement function to write the steps
	; and trigger MoveSprite immediately on this frame!
	call PalletMovementScript_OakMoveLeft

	; Set the engine state flags so the map script engine takes over updating it
	ld hl, wStatusFlags4
	set BIT_INIT_SCRIPTED_MOVEMENT, [hl]

	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a

	; Advance to the script that waits for him to finish walking
	ld a, SCRIPT_SILENTHILL_OAK_NOT_SAFE_COME_WITH_ME
	ld [wSilentHillCurScript], a
	ret

SilentHillOakNotSafeComeWithMeScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz

	; Force player to face RIGHT towards Oak while talking
	ld a, SPRITE_FACING_RIGHT
	ld [wSpritePlayerStateData1FacingDirection], a

	; Force Oak to face LEFT towards the player while talking
	ld a, SPRITE_FACING_LEFT
	ld [wSpriteStateData1 + $12], a

	ld a, TRUE
	ld [wOakWalkedToPlayer], a
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, TEXT_SILENTHILL_OAK
	ldh [hTextID], a
	call DisplayTextID

; set up movement script that causes the player to follow Oak to his lab
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, SILENTHILL_OAK
	ld [wSpriteIndex], a

	ld a, 1
	ld [wNPCMovementScriptFunctionNum], a

	ld a, 1
	ld [wNPCMovementScriptPointerTableNum], a
	ldh a, [hLoadedROMBank]
	ld [wNPCMovementScriptBank], a

	; trigger the next script
	ld a, SCRIPT_SILENTHILL_PLAYER_FOLLOWS_OAK
	ld [wSilentHillCurScript], a
	ret

SilentHillPlayerFollowsOakScript:
	; Check if the simulated walking steps are finished
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz ; If not zero, they are still walking! Keep waiting.

	; Once walking is completely finished, clean up the script flags
	ld hl, wStatusFlags5
	res BIT_SCRIPTED_MOVEMENT_STATE, [hl]
	ld hl, wStatusFlags4
	res BIT_INIT_SCRIPTED_MOVEMENT, [hl]

	; trigger the next script
	ld a, SCRIPT_SILENTHILL_DAISY
	ld [wSilentHillCurScript], a
	ret

SilentHillDaisyScript:
	CheckEvent EVENT_DAISY_WALKING
	jr nz, .next
	CheckBothEventsSet EVENT_GOT_TOWN_MAP, EVENT_ENTERED_BLUES_HOUSE, 1
	jr nz, .next
	SetEvent EVENT_DAISY_WALKING
	ld a, TOGGLE_DAISY_SITTING
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld a, TOGGLE_DAISY_WALKING
	ld [wToggleableObjectIndex], a
	predef_jump ShowObject
.next
	CheckEvent EVENT_GOT_POKEBALLS_FROM_OAK
	ret z
	SetEvent EVENT_SILENT_AFTER_GETTING_POKEBALLS_2
SilentHillNoopScript:
	ret

SilentHill_TextPointers:
	def_text_pointers
	dw_const SilentHillOakText,              TEXT_SILENTHILL_OAK
	dw_const SilentHillGirlText,             TEXT_SILENTHILL_GIRL
	dw_const SilentHillFisherText,           TEXT_SILENTHILL_FISHER
	dw_const SilentHillOaksLabSignText,      TEXT_SILENTHILL_OAKSLAB_SIGN
	dw_const SilentHillSignText,             TEXT_SILENTHILL_SIGN
	dw_const SilentHillPlayersHouseSignText, TEXT_SILENTHILL_PLAYERSHOUSE_SIGN
	dw_const SilentHillRivalsHouseSignText,  TEXT_SILENTHILL_RIVALSHOUSE_SIGN

SilentHillOakText:
	text_asm
	ld a, [wOakWalkedToPlayer]
	and a
	jr nz, .next
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, .HeyWaitDontGoOutText
	jr .done
.next
	ld hl, .ItsUnsafeText
.done
	call PrintText
	jp TextScriptEnd

.HeyWaitDontGoOutText:
	text_far _SilentHillOakHeyWaitDontGoOutText
	text_asm
	ld c, 10
	call DelayFrames
	xor a
	ld [wEmotionBubbleSpriteIndex], a ; player's sprite
	ld [wWhichEmotionBubble], a ; EXCLAMATION_BUBBLE
	predef EmotionBubble
	jp TextScriptEnd

.ItsUnsafeText:
	text_far _SilentHillOakItsUnsafeText
	text_end

SilentHillGirlText:
	text_far _SilentHillGirlText
	text_end

SilentHillFisherText:
	text_far _SilentHillFisherText
	text_end

SilentHillOaksLabSignText:
	text_far _SilentHillOaksLabSignText
	text_end

SilentHillSignText:
	text_far _SilentHillSignText
	text_end

SilentHillPlayersHouseSignText:
	text_far _SilentHillPlayersHouseSignText
	text_end

SilentHillRivalsHouseSignText:
	text_far _SilentHillRivalsHouseSignText
	text_end
