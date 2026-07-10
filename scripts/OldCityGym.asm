OldCityGym_Script:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_2, [hl]
	res BIT_CUR_MAP_LOADED_2, [hl]
	call nz, .LoadNames
	call EnableAutoTextBoxDrawing
	ld hl, OldCityGymTrainerHeaders
	ld de, OldCityGym_ScriptPointers
	ld a, [wOldCityGymCurScript]
	call ExecuteCurMapScriptInTable
	ld [wOldCityGymCurScript], a
	ret

.LoadNames:
	ld hl, .CityName
	ld de, .LeaderName
	jp LoadGymLeaderAndCityName

.CityName:
	db "OLD CITY@"

.LeaderName:
	db "MIKON@"

OldCityGymResetScripts:
	xor a
	ld [wJoyIgnore], a
	ld [wOldCityGymCurScript], a
	ld [wCurMapScript], a
	ret

OldCityGym_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_OLDCITYGYM_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_OLDCITYGYM_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_OLDCITYGYM_END_BATTLE
	dw_const OldCityGymMikonPostBattle,             SCRIPT_OLDCITYGYM_MIKON_POST_BATTLE

OldCityGymMikonPostBattle:
	ld a, [wIsInBattle]
	cp $ff
	jp z, OldCityGymResetScripts
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
; fallthrough
OldCityGymScriptReceiveTM34:
	ld a, TEXT_OLDCITYGYM_MIKON_WAIT_TAKE_THIS
	ldh [hTextID], a
	call DisplayTextID
	SetEvent EVENT_BEAT_MIKON
	lb bc, TM_BIDE, 1
	call GiveItem
	jr nc, .BagFull
	ld a, TEXT_OLDCITYGYM_RECEIVED_TM34
	ldh [hTextID], a
	call DisplayTextID
	SetEvent EVENT_GOT_TM34
	jr .gymVictory
.BagFull
	ld a, TEXT_OLDCITYGYM_TM34_NO_ROOM
	ldh [hTextID], a
	call DisplayTextID
.gymVictory
	ld hl, wObtainedBadges
	set BIT_BOULDERBADGE, [hl]
	ld hl, wBeatGymFlags
	set BIT_BOULDERBADGE, [hl]

	ld a, TOGGLE_GYM_GUY
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld a, TOGGLE_ROUTE_22_RIVAL_1
	ld [wToggleableObjectIndex], a
	predef HideObject

	ResetEvents EVENT_1ST_ROUTE22_RIVAL_BATTLE, EVENT_ROUTE22_RIVAL_WANTS_BATTLE

	; deactivate gym trainers
	SetEvent EVENT_BEAT_OLD_GYM_TRAINER_0

	jp OldCityGymResetScripts

OldCityGym_TextPointers:
	def_text_pointers
	dw_const OldCityGymMikonText,             TEXT_OLDCITYGYM_MIKON
	dw_const OldCityGymCooltrainerMText,      TEXT_OLDCITYGYM_COOLTRAINER_M
	dw_const OldCityGymGuideText,             TEXT_OLDCITYGYM_GYM_GUIDE
	dw_const OldCityGymMikonWaitTakeThisText, TEXT_OLDCITYGYM_MIKON_WAIT_TAKE_THIS
	dw_const OldCityGymReceivedTM34Text,      TEXT_OLDCITYGYM_RECEIVED_TM34
	dw_const OldCityGymTM34NoRoomText,        TEXT_OLDCITYGYM_TM34_NO_ROOM

OldCityGymTrainerHeaders:
	def_trainers 1
OldCityGymTrainerHeader0:
	trainer EVENT_BEAT_OLD_GYM_TRAINER_0, 5, OldCityGymCooltrainerMBattleText, OldCityGymCooltrainerMEndBattleText, OldCityGymCooltrainerMAfterBattleText
	db -1 ; end

OldCityGymMikonText:
	text_asm
	CheckEvent EVENT_BEAT_MIKON
	jr z, .beforeBeat
	CheckEventReuseA EVENT_GOT_TM34
	jr nz, .afterBeat
	call z, OldCityGymScriptReceiveTM34
	call DisableWaitingAfterTextDisplay
	jr .done
.afterBeat
	ld hl, .PostBattleAdviceText
	call PrintText
	jr .done
.beforeBeat
	ld hl, .PreBattleText
	call PrintText
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, OldCityGymMikonReceivedBoulderBadgeText
	ld de, OldCityGymMikonReceivedBoulderBadgeText
	call SaveEndBattleTextPointers
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, $1
	ld [wGymLeaderNo], a
	xor a
	ldh [hJoyHeld], a
	ld a, SCRIPT_OLDCITYGYM_MIKON_POST_BATTLE
	ld [wOldCityGymCurScript], a
	ld [wCurMapScript], a
.done
	jp TextScriptEnd

.PreBattleText:
	text_far _OldCityGymMikonPreBattleText
	text_end

.PostBattleAdviceText:
	text_far _OldCityGymMikonPostBattleAdviceText
	text_end

OldCityGymMikonWaitTakeThisText:
	text_far _OldCityGymMikonWaitTakeThisText
	text_end

OldCityGymReceivedTM34Text:
	text_far _OldCityGymReceivedTM34Text
	sound_get_item_1
	text_far _OldCityTM34ExplanationText
	text_end

OldCityGymTM34NoRoomText:
	text_far _OldCityGymTM34NoRoomText
	text_end

OldCityGymMikonReceivedBoulderBadgeText:
	text_far _OldCityGymMikonReceivedBoulderBadgeText
	sound_level_up ; probably supposed to play SFX_GET_ITEM_1 but the wrong music bank is loaded
	text_far _OldCityGymMikonBoulderBadgeInfoText ; Text to tell that the flash technique can be used
	text_end

OldCityGymCooltrainerMText:
	text_asm
	ld hl, OldCityGymTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

OldCityGymCooltrainerMBattleText:
	text_far _OldCityGymCooltrainerMBattleText
	text_end

OldCityGymCooltrainerMEndBattleText:
	text_far _OldCityGymCooltrainerMEndBattleText
	text_end

OldCityGymCooltrainerMAfterBattleText:
	text_far _OldCityGymCooltrainerMAfterBattleText
	text_end

OldCityGymGuideText:
	text_asm
	ld a, [wBeatGymFlags]
	bit BIT_BOULDERBADGE, a
	jr nz, .afterBeat
	ld hl, OldCityGymGuidePreAdviceText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .OldCityGymGuideBeginAdviceText
	ld hl, OldCityGymGuideBeginAdviceText
	call PrintText
	jr .OldCityGymGuideAdviceText
.OldCityGymGuideBeginAdviceText
	ld hl, OldCityGymGuideFreeServiceText
	call PrintText
.OldCityGymGuideAdviceText
	ld hl, OldCityGymGuideAdviceText
	call PrintText
	jr .done
.afterBeat
	ld hl, OldCityGymGuidePostBattleText
	call PrintText
.done
	jp TextScriptEnd

OldCityGymGuidePreAdviceText:
	text_far _OldCityGymGuidePreAdviceText
	text_end

OldCityGymGuideBeginAdviceText:
	text_far _OldCityGymGuideBeginAdviceText
	text_end

OldCityGymGuideAdviceText:
	text_far _OldCityGymGuideAdviceText
	text_end

OldCityGymGuideFreeServiceText:
	text_far _OldCityGymGuideFreeServiceText
	text_end

OldCityGymGuidePostBattleText:
	text_far _OldCityGymGuidePostBattleText
	text_end
