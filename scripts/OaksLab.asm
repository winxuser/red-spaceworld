OaksLab_Script:
	CheckEvent EVENT_SILENT_AFTER_GETTING_POKEBALLS_2
	call nz, OaksLabLoadTextPointers2Script
	ld a, 1 << BIT_NO_AUTO_TEXT_BOX
	ld [wAutoTextBoxDrawingControl], a
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, OaksLab_ScriptPointers
	ld a, [wOaksLabCurScript]
	jp CallFunctionInTable

OaksLab_ScriptPointers:
	def_script_pointers
	dw_const OaksLabDefaultScript,         SCRIPT_OAKSLAB_DEFAULT
	dw_const OaksLabOakEntersLabScript,         SCRIPT_OAKSLAB_OAK_ENTERS_LAB
	dw_const OaksLabToggleOaksScript,            SCRIPT_OAKSLAB_TOGGLE_OAKS
	dw_const OaksLabPlayerEntersLabScript,      SCRIPT_OAKSLAB_PLAYER_ENTERS_LAB
	dw_const OaksLabFollowedOakScript,          SCRIPT_OAKSLAB_FOLLOWED_OAK
	dw_const OaksLabOakChooseMonSpeechScript,   SCRIPT_OAKSLAB_OAK_CHOOSE_MON_SPEECH
	dw_const OaksLabPlayerDontGoAwayScript,     SCRIPT_OAKSLAB_PLAYER_DONT_GO_AWAY_SCRIPT
	dw_const OaksLabPlayerForcedToWalkBackScript, SCRIPT_OAKSLAB_PLAYER_FORCED_TO_WALK_BACK_SCRIPT
	dw_const OaksLabChoseStarterScript,         SCRIPT_OAKSLAB_CHOSE_STARTER_SCRIPT
	dw_const OaksLabRivalChoosesStarterScript,  SCRIPT_OAKSLAB_RIVAL_CHOOSES_STARTER
	dw_const OaksLabRivalChallengesPlayerScript, SCRIPT_OAKSLAB_RIVAL_CHALLENGES_PLAYER
	dw_const OaksLabRivalStartBattleScript,     SCRIPT_OAKSLAB_RIVAL_START_BATTLE
	dw_const OaksLabRivalEndBattleScript,       SCRIPT_OAKSLAB_RIVAL_END_BATTLE
	dw_const OaksLabRivalStartsExitScript,      SCRIPT_OAKSLAB_RIVAL_STARTS_EXIT
	dw_const OaksLabPlayerWatchRivalExitScript, SCRIPT_OAKSLAB_PLAYER_WATCH_RIVAL_EXIT
	dw_const OaksLabGirlTriggersScript,         SCRIPT_OAKSLAB_GIRL_TRIGGERS
	dw_const OaksLabGirlGivesItemsScript,       SCRIPT_OAKSLAB_GIRL_GIVES_ITEMS
	dw_const OaksLabWaitForKeyItemTriggerScript, SCRIPT_OAKSLAB_WAIT_FOR_KEY_ITEM
	dw_const OaksLabNoopScript,                 SCRIPT_OAKSLAB_NOOP

OaksLabDefaultScript:
	CheckEvent EVENT_GOT_STARTER
	jr z, .skip_girl_trigger
	CheckEvent EVENT_GOT_POKEDEX
	jr nz, .skip_girl_trigger

	ld a, [wYCoord]
	cp 11
	jr nz, .skip_girl_trigger

	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a

	ld a, SCRIPT_OAKSLAB_GIRL_TRIGGERS
	ld [wOaksLabCurScript], a
	ret

.skip_girl_trigger
	CheckEvent EVENT_OAK_APPEARED_IN_SILENT
	ret z
	ld a, [wNPCMovementScriptFunctionNum]
	and a
	ret nz
	ld a, TOGGLE_OAKS_LAB_OAK_2
	ld [wToggleableObjectIndex], a
	predef ShowObject
	ld hl, wStatusFlags4
	res BIT_NO_BATTLES, [hl]

	ld a, SCRIPT_OAKSLAB_OAK_ENTERS_LAB
	ld [wOaksLabCurScript], a
	ret

OaksLabOakEntersLabScript:
	ld a, OAKSLAB_OAK2
	ldh [hSpriteIndex], a
	ld de, OakEntryMovement
	call MoveSprite

	ld a, SCRIPT_OAKSLAB_TOGGLE_OAKS
	ld [wOaksLabCurScript], a
	ret

OakEntryMovement:
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db -1 ; end

OaksLabToggleOaksScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	ld a, TOGGLE_OAKS_LAB_OAK_2
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld a, TOGGLE_OAKS_LAB_OAK_1
	ld [wToggleableObjectIndex], a
	predef ShowObject

	ld a, SCRIPT_OAKSLAB_PLAYER_ENTERS_LAB
	ld [wOaksLabCurScript], a
	ret

OaksLabPlayerEntersLabScript:
	call Delay3
	ld hl, wSimulatedJoypadStatesEnd
	ld de, PlayerEntryMovementRLE
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	xor a
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, OAKSLAB_OAK1
	ldh [hSpriteIndex], a
	xor a
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay

	ld a, SCRIPT_OAKSLAB_FOLLOWED_OAK
	ld [wOaksLabCurScript], a
	ret

PlayerEntryMovementRLE:
	db PAD_UP, 1
	db PAD_RIGHT, 2
	db PAD_UP, 11
	db -1 ; end

OaksLabFollowedOakScript:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	SetEvent EVENT_FOLLOWED_OAK_INTO_LAB
	SetEvent EVENT_FOLLOWED_OAK_INTO_LAB_2
	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_UP
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	call UpdateSprites
	ld hl, wStatusFlags7
	res BIT_NO_MAP_MUSIC, [hl]
	call PlayDefaultMusic

	ld a, SCRIPT_OAKSLAB_OAK_CHOOSE_MON_SPEECH
	ld [wOaksLabCurScript], a
	ret

OaksLabOakChooseMonSpeechScript:
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, TEXT_OAKSLAB_RIVAL_FED_UP_WITH_WAITING
	ldh [hTextID], a
	call DisplayTextID
	call Delay3
	ld a, TEXT_OAKSLAB_OAK_CHOOSE_MON
	ldh [hTextID], a
	call DisplayTextID
	call Delay3
	ld a, TEXT_OAKSLAB_RIVAL_WHAT_ABOUT_ME
	ldh [hTextID], a
	call DisplayTextID
	call Delay3
	ld a, TEXT_OAKSLAB_OAK_BE_PATIENT
	ldh [hTextID], a
	call DisplayTextID
	SetEvent EVENT_OAK_ASKED_TO_CHOOSE_MON
	xor a
	ld [wJoyIgnore], a

	ld a, SCRIPT_OAKSLAB_PLAYER_DONT_GO_AWAY_SCRIPT
	ld [wOaksLabCurScript], a
	ret

OaksLabPlayerDontGoAwayScript:
	ld a, [wYCoord]
	cp 6
	ret nz
	ld a, OAKSLAB_OAK1
	ldh [hSpriteIndex], a
	xor a ; SPRITE_FACING_DOWN
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	xor a ; SPRITE_FACING_DOWN
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	call UpdateSprites
	ld a, TEXT_OAKSLAB_OAK_DONT_GO_AWAY_YET
	ldh [hTextID], a
	call DisplayTextID
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, PAD_UP
	ld [wSimulatedJoypadStatesEnd], a
	call StartSimulatingJoypadStates
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a

	ld a, SCRIPT_OAKSLAB_PLAYER_FORCED_TO_WALK_BACK_SCRIPT
	ld [wOaksLabCurScript], a
	ret

OaksLabPlayerForcedToWalkBackScript:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3

	ld a, SCRIPT_OAKSLAB_PLAYER_DONT_GO_AWAY_SCRIPT
	ld [wOaksLabCurScript], a
	ret

OaksLabChoseStarterScript:
	ld a, [wPlayerStarter]
	cp STARTER1
	jr z, .Honoguma
	cp STARTER2
	jr z, .Kurusu
	jr .Happa
.Honoguma
	ld de, .MiddleBallMovement1
	ld a, [wYCoord]
	cp 4
	jr z, .moveBlue
	ld de, .MiddleBallMovement2
	jr .moveBlue

.MiddleBallMovement1
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_UP
	db -1 ; end

.MiddleBallMovement2
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_UP
	db -1 ; end

.Kurusu
	ld de, .RightBallMovement1
	ld a, [wYCoord]
	cp 4
	jr z, .moveBlue
	ld de, .RightBallMovement2
	jr .moveBlue

.RightBallMovement1
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_UP
	db -1 ; end

.RightBallMovement2
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_UP
	db -1 ; end

.Happa
	ld de, .LeftBallMovement1
	ld a, [wXCoord]
	cp 9
	jr nz, .moveBlue
	push hl
	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	ld a, SPRITESTATEDATA1_YPIXELS
	ldh [hSpriteDataOffset], a
	call GetPointerWithinSpriteStateData1
	push hl
	ld [hl], $4c
	inc hl
	inc hl
	ld [hl], $0
	pop hl
	inc h
	ld [hl], 8
	inc hl
	ld [hl], 9
	ld de, .LeftBallMovement2
	pop hl
	jr .moveBlue

.LeftBallMovement1
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_UP
	db -1 ; end

.LeftBallMovement2
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_UP
	db -1 ; end

.moveBlue
	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	call MoveSprite

	ld a, SCRIPT_OAKSLAB_RIVAL_CHOOSES_STARTER
	ld [wOaksLabCurScript], a
	ret

OaksLabRivalChoosesStarterScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_UP
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, TEXT_OAKSLAB_RIVAL_ILL_TAKE_THIS_ONE
	ldh [hTextID], a
	call DisplayTextID
	ld a, [wRivalStarterBallSpriteIndex]
	cp OAKSLAB_HONOGUMA_POKE_BALL
	jr nz, .not_honoguma
	ld a, TOGGLE_STARTER_BALL_1
	jr .hideBallAndContinue
.not_honoguma
	cp OAKSLAB_KURUSU_POKE_BALL
	jr nz, .not_kurusu
	ld a, TOGGLE_STARTER_BALL_2
	jr .hideBallAndContinue
.not_kurusu
	ld a, TOGGLE_STARTER_BALL_3
.hideBallAndContinue
	ld [wToggleableObjectIndex], a
	predef HideObject
	call Delay3
	ld a, [wRivalStarterTemp]
	ld [wRivalStarter], a
	ld [wCurPartySpecies], a
	ld [wNamedObjectIndex], a
	call GetMonName
	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_UP
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, TEXT_OAKSLAB_RIVAL_RECEIVED_MON
	ldh [hTextID], a
	call DisplayTextID
	SetEvent EVENT_GOT_STARTER
	xor a
	ld [wJoyIgnore], a

	ld a, SCRIPT_OAKSLAB_RIVAL_CHALLENGES_PLAYER
	ld [wOaksLabCurScript], a
	ret

OaksLabRivalChallengesPlayerScript:
	ld a, [wYCoord]
	cp 6
	ret nz
	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	xor a ; SPRITE_FACING_DOWN
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	ld c, 0
	ld a, MUSIC_MEET_RIVAL
	call PlayMusic
	ld a, TEXT_OAKSLAB_RIVAL_ILL_TAKE_YOU_ON
	ldh [hTextID], a
	call DisplayTextID
	ld a, $1
	ldh [hNPCPlayerRelativePosPerspective], a
	ld a, $1
	swap a
	ldh [hNPCSpriteOffset], a
	predef CalcPositionOfPlayerRelativeToNPC
	ldh a, [hNPCPlayerYDistance]
	dec a
	ldh [hNPCPlayerYDistance], a
	predef FindPathToPlayer
	ld de, wNPCMovementDirections2
	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	call MoveSprite

	ld a, SCRIPT_OAKSLAB_RIVAL_START_BATTLE
	ld [wOaksLabCurScript], a
	ret

OaksLabRivalStartBattleScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz

	ld a, 1
	ld [wIsTrainerBattle], a
	ld a, OPP_RIVAL1
	ld [wCurOpponent], a
	ld a, [wRivalStarter]
	cp STARTER2
	jr nz, .not_kurusu
	ld a, $1
	jr .done
.not_kurusu
	cp STARTER3
	jr nz, .not_happa
	ld a, $2
	jr .done
.not_happa
	ld a, $3
.done
	ld [wTrainerNo], a
	ld a, OAKSLAB_RIVAL
	ld [wSpriteIndex], a
	call GetSpritePosition1
	ld hl, OaksLabRivalIPickedTheWrongPokemonText
	ld de, OaksLabRivalAmIGreatOrWhatText
	call SaveEndBattleTextPointers
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	xor a
	ld [wJoyIgnore], a
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	ld a, SCRIPT_OAKSLAB_RIVAL_END_BATTLE
	ld [wOaksLabCurScript], a
	ret

OaksLabRivalEndBattleScript:
	xor a
	ld [wIsTrainerBattle], a
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	call UpdateSprites
	ld a, OAKSLAB_RIVAL
	ld [wSpriteIndex], a
	call SetSpritePosition1
	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	xor a ; SPRITE_FACING_DOWN
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	predef HealParty
	SetEvent EVENT_BATTLED_RIVAL_IN_OAKS_LAB

	ld a, SCRIPT_OAKSLAB_RIVAL_STARTS_EXIT
	ld [wOaksLabCurScript], a
	ret

OaksLabRivalStartsExitScript:
	ld c, 20
	call DelayFrames
	ld a, TEXT_OAKSLAB_RIVAL_SMELL_YOU_LATER
	ldh [hTextID], a
	call DisplayTextID
	farcall Music_RivalAlternateStart

	ld a, [wXCoord]
	cp 4
	jr nz, .moveLeft
	ld a, NPC_MOVEMENT_RIGHT
	jr .next
.moveLeft
	ld a, NPC_MOVEMENT_LEFT
.next
	ld [wNPCMovementDirections2], a

	ld hl, wNPCMovementDirections2 + 1
	ld a, NPC_MOVEMENT_DOWN
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], $ff

	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	ld de, wNPCMovementDirections2
	call MoveSprite

	ld a, SCRIPT_OAKSLAB_PLAYER_WATCH_RIVAL_EXIT
	ld [wOaksLabCurScript], a
	ret

OaksLabPlayerWatchRivalExitScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	jr nz, .checkRivalPosition

	ld a, TOGGLE_OAKS_LAB_RIVAL
	ld [wToggleableObjectIndex], a
	predef HideObject

	xor a
	ld [wJoyIgnore], a
	ld [wSimulatedJoypadStatesIndex], a
	ld hl, wStatusFlags5
	res BIT_SCRIPTED_NPC_MOVEMENT, [hl]

	SetEvent EVENT_ROUTE22_RIVAL_WANTS_BATTLE
	call PlayDefaultMusic
	ld a, SCRIPT_OAKSLAB_WAIT_FOR_KEY_ITEM
	ld [wOaksLabCurScript], a
	jr .done

.checkRivalPosition
	ld a, [wNPCNumScriptedSteps]
	cp $5
	jr nz, .turnPlayerDown
	ld a, [wXCoord]
	cp 4
	jr nz, .turnPlayerLeft
	ld a, SPRITE_FACING_RIGHT
	ld [wSpritePlayerStateData1FacingDirection], a
	jr .done
.turnPlayerLeft
	ld a, SPRITE_FACING_LEFT
	ld [wSpritePlayerStateData1FacingDirection], a
	jr .done
.turnPlayerDown
	cp $4
	ret nz
	xor a
	ld [wSpritePlayerStateData1FacingDirection], a
.done
	ret

OaksLabGirlTriggersScript:
	ld a, OAKSLAB_GIRL
	ldh [hSpriteIndex], a
	ld de, GirlWalkToPlayerMovement
	call MoveSprite

	ld a, SCRIPT_OAKSLAB_GIRL_GIVES_ITEMS
	ld [wOaksLabCurScript], a
	ret

GirlWalkToPlayerMovement:
	db NPC_MOVEMENT_RIGHT
	db -1 ; end

OaksLabGirlGivesItemsScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz

	call EnableAutoTextBoxDrawing
	xor a
	ld [wJoyIgnore], a
	ld a, TEXT_OAKSLAB_GIRL
	ldh [hTextID], a
	call DisplayTextID

	ld a, OAKSLAB_GIRL
	ldh [hSpriteIndex], a
	ld de, GirlWalkBackMovement
	call MoveSprite

	xor a
	ld [wJoyIgnore], a
	ld a, SCRIPT_OAKSLAB_NOOP
	ld [wOaksLabCurScript], a
	ret

GirlWalkBackMovement:
	db NPC_MOVEMENT_LEFT
	db -1 ; end

OaksLabNoopScript:
	ret

OaksLabLoadTextPointers2Script:
	ld hl, OaksLab_TextPointers2
	ld a, l
	ld [wCurMapTextPtr], a
	ld a, h
	ld [wCurMapTextPtr + 1], a
	ret

OaksLab_TextPointers:
	def_text_pointers
	dw_const OaksLabRivalText,                 TEXT_OAKSLAB_RIVAL
	dw_const OaksLabHonogumaPokeBallText,        TEXT_OAKSLAB_HONOGUMA_POKE_BALL
	dw_const OaksLabKurusuPokeBallText,          TEXT_OAKSLAB_KURUSU_POKE_BALL
	dw_const OaksLabHappaPokeBallText,         TEXT_OAKSLAB_HAPPA_POKE_BALL
	dw_const OaksLabOak1Text,                    TEXT_OAKSLAB_OAK1
	dw_const OaksLabPokedexText,                 TEXT_OAKSLAB_POKEDEX1
	dw_const OaksLabPokedexText,                 TEXT_OAKSLAB_POKEDEX2
	dw_const OaksLabOak2Text,                    TEXT_OAKSLAB_OAK2
	dw_const OaksLabGirlText,                    TEXT_OAKSLAB_GIRL
	dw_const OaksLabScientistText,               TEXT_OAKSLAB_SCIENTIST1
	dw_const OaksLabScientistText,               TEXT_OAKSLAB_SCIENTIST2
	dw_const OaksLabOakDontGoAwayYetText,        TEXT_OAKSLAB_OAK_DONT_GO_AWAY_YET
	dw_const OaksLabRivalIllTakeThisOneText,     TEXT_OAKSLAB_RIVAL_ILL_TAKE_THIS_ONE
	dw_const OaksLabRivalReceivedMonText,        TEXT_OAKSLAB_RIVAL_RECEIVED_MON
	dw_const OaksLabRivalIllTakeYouOnText,      TEXT_OAKSLAB_RIVAL_ILL_TAKE_YOU_ON
	dw_const OaksLabRivalSmellYouLaterText,      TEXT_OAKSLAB_RIVAL_SMELL_YOU_LATER
	dw_const OaksLabRivalFedUpWithWaitingText,  TEXT_OAKSLAB_RIVAL_FED_UP_WITH_WAITING
	dw_const OaksLabOakChooseMonText,            TEXT_OAKSLAB_OAK_CHOOSE_MON
	dw_const OaksLabRivalWhatAboutMeText,        TEXT_OAKSLAB_RIVAL_WHAT_ABOUT_ME
	dw_const OaksLabOakBePatientText,            TEXT_OAKSLAB_OAK_BE_PATIENT

OaksLab_TextPointers2:
	dw OaksLabRivalText
	dw OaksLabHonogumaPokeBallText
	dw OaksLabKurusuPokeBallText
	dw OaksLabHappaPokeBallText
	dw OaksLabOak1Text
	dw OaksLabPokedexText
	dw OaksLabPokedexText
	dw OaksLabOak2Text
	dw OaksLabGirlText
	dw OaksLabScientistText
	dw OaksLabScientistText

OaksLabRivalText:
	text_asm
	CheckEvent EVENT_FOLLOWED_OAK_INTO_LAB_2
	jr nz, .beforeChooseMon
	ld hl, .GrampsIsntAroundText
	call PrintText
	jr .done
.beforeChooseMon
	CheckEventReuseA EVENT_GOT_STARTER
	jr nz, .afterChooseMon
	ld hl, .GoAheadAndChooseText
	call PrintText
	jr .done
.afterChooseMon
	ld hl, .MyPokemonLooksStrongerText
	call PrintText
.done
	jp TextScriptEnd

.GrampsIsntAroundText:
	text_far _OaksLabRivalGrampsIsntAroundText
	text_end

.GoAheadAndChooseText:
	text_far _OaksLabRivalGoAheadAndChooseText
	text_end

.MyPokemonLooksStrongerText:
	text_far _OaksLabRivalMyPokemonLooksStrongerText
	text_end

OaksLabHonogumaPokeBallText:
	text_asm
	ld a, STARTER2
	ld [wRivalStarterTemp], a
	ld a, OAKSLAB_KURUSU_POKE_BALL
	ld [wRivalStarterBallSpriteIndex], a
	ld a, STARTER1
	ld b, OAKSLAB_HONOGUMA_POKE_BALL
	jr OaksLabSelectedPokeBallScript

OaksLabKurusuPokeBallText:
	text_asm
	ld a, STARTER3
	ld [wRivalStarterTemp], a
	ld a, OAKSLAB_HAPPA_POKE_BALL
	ld [wRivalStarterBallSpriteIndex], a
	ld a, STARTER2
	ld b, OAKSLAB_KURUSU_POKE_BALL
	jr OaksLabSelectedPokeBallScript

OaksLabHappaPokeBallText:
	text_asm
	ld a, STARTER1
	ld [wRivalStarterTemp], a
	ld a, OAKSLAB_HONOGUMA_POKE_BALL
	ld [wRivalStarterBallSpriteIndex], a
	ld a, STARTER3
	ld b, OAKSLAB_HAPPA_POKE_BALL

OaksLabSelectedPokeBallScript:
	ld [wCurPartySpecies], a
	ld [wPokedexNum], a
	ld a, b
	ld [wSpriteIndex], a
	CheckEvent EVENT_GOT_STARTER
	jp nz, OaksLabLastMonScript
	CheckEventReuseA EVENT_OAK_ASKED_TO_CHOOSE_MON
	jr nz, OaksLabShowPokeBallPokemonScript
	ld hl, OaksLabThoseArePokeBallsText
	call PrintText
	jp TextScriptEnd

OaksLabThoseArePokeBallsText:
	text_far _OaksLabThoseArePokeBallsText
	text_end

OaksLabShowPokeBallPokemonScript:
	ld a, OAKSLAB_OAK1
	ldh [hSpriteIndex], a
	ld a, SPRITESTATEDATA1_FACINGDIRECTION
	ldh [hSpriteDataOffset], a
	call GetPointerWithinSpriteStateData1
	ld [hl], SPRITE_FACING_DOWN
	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	ld a, SPRITESTATEDATA1_FACINGDIRECTION
	ldh [hSpriteDataOffset], a
	call GetPointerWithinSpriteStateData1
	ld [hl], SPRITE_FACING_RIGHT
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, [hl]
	predef StarterDex
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	call ReloadMapData
	ld c, 10
	call DelayFrames
	ld a, [wSpriteIndex]
	cp OAKSLAB_HONOGUMA_POKE_BALL
	jr z, OaksLabYouWantHonogumaText
	cp OAKSLAB_KURUSU_POKE_BALL
	jr z, OaksLabYouWantKurusuText
	jr OaksLabYouWantHappaText

OaksLabYouWantHonogumaText:
	ld hl, .Text
	jr OaksLabMonChoiceMenu
.Text:
	text_far _OaksLabYouWantHonogumaText
	text_end

OaksLabYouWantKurusuText:
	ld hl, .Text
	jr OaksLabMonChoiceMenu
.Text:
	text_far _OaksLabYouWantKurusuText
	text_end

OaksLabYouWantHappaText:
	ld hl, .Text
	jr OaksLabMonChoiceMenu
.Text:
	text_far _OaksLabYouWantHappaText
	text_end

OaksLabMonChoiceMenu:
	call PrintText
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, OaksLabMonChoiceEnd
	ld a, [wCurPartySpecies]
	ld [wPlayerStarter], a
	ld [wNamedObjectIndex], a
	call GetMonName
	ld a, [wSpriteIndex]
	cp OAKSLAB_HONOGUMA_POKE_BALL
	jr nz, .not_honoguma
	ld a, TOGGLE_STARTER_BALL_1
	jr .continue
.not_honoguma
	cp OAKSLAB_KURUSU_POKE_BALL
	jr nz, .not_kurusu
	ld a, TOGGLE_STARTER_BALL_2
	jr .continue
.not_kurusu
	ld a, TOGGLE_STARTER_BALL_3
.continue
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, OaksLabMonEnergeticText
	call PrintText
	ld hl, OaksLabReceivedMonText
	call PrintText
	xor a
	ld [wMonDataLocation], a
	ld a, 5
	ld [wCurEnemyLevel], a
	ld a, [wCurPartySpecies]
	ld [wPokedexNum], a
	call AddPartyMon
	ld hl, wStatusFlags4
	set BIT_GOT_STARTER, [hl]
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, SCRIPT_OAKSLAB_CHOSE_STARTER_SCRIPT
	ld [wOaksLabCurScript], a
OaksLabMonChoiceEnd:
	jp TextScriptEnd

OaksLabMonEnergeticText:
	text_far _OaksLabMonEnergeticText
	text_end

OaksLabReceivedMonText:
	text_far _OaksLabReceivedMonText
	sound_get_key_item
	text_end

OaksLabLastMonScript:
	ld a, OAKSLAB_OAK1
	ldh [hSpriteIndex], a
	ld a, SPRITESTATEDATA1_FACINGDIRECTION
	ldh [hSpriteDataOffset], a
	call GetPointerWithinSpriteStateData1
	ld [hl], SPRITE_FACING_DOWN
	ld hl, OaksLabLastMonText
	call PrintText
	jp TextScriptEnd

OaksLabLastMonText:
	text_far _OaksLabLastMonText
	text_end

OaksLabOak1Text:
	text_asm
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld a, [wNumSetBits]
	cp 2
	jr c, .check_starter_status
	ld hl, .HowIsYourPokedexComingText
	call PrintText
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	predef DisplayDexRating
	jp .done
.check_starter_status
	ld a, [wStatusFlags4]
	bit BIT_GOT_STARTER, a
	jr nz, .already_got_pokemon
	ld hl, .WhichPokemonDoYouWantText
	call PrintText
	jr .done
.already_got_pokemon
	ld hl, .YourPokemonCanFightText
	call PrintText
.done
	jp TextScriptEnd

.WhichPokemonDoYouWantText:
	text_far _OaksLabOak1WhichPokemonDoYouWantText
	text_end

.YourPokemonCanFightText:
	text_far _OaksLabOak1YourPokemonCanFightText
	text_end

.HowIsYourPokedexComingText:
	text_far _OaksLabOak1HowIsYourPokedexComingText
	text_end

OaksLabPokedexText:
	text_asm
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_far _OaksLabPokedexText
	text_end

OaksLabOak2Text:
	text_far _OaksLabOak2Text
	text_end

OaksLabGirlText:
	text_asm
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	CheckEvent EVENT_GOT_POKEDEX
	jr nz, .already_got_items
	CheckEvent EVENT_GOT_STARTER
	jr z, .need_starter_first

	ld hl, .GirlGivingItemsText
	call PrintText
	SetEvent EVENT_GOT_POKEDEX

	ld a, TOGGLE_POKEDEX_1   ; (Use your map's exact toggle constant for the Pokédex object)
	ld [wToggleableObjectIndex], a
	predef HideObject

	ld b, POKE_BALL
	ld c, 5
	call GiveItem

	ld hl, .GotItemsNotificationText
	call PrintText
	jr .done

.need_starter_first
	ld hl, .GirlAskToChooseStarterText
	call PrintText
	jr .done

.already_got_items
	ld hl, .GirlAlreadyGaveItemsText
	call PrintText
.done
	jp TextScriptEnd

.GirlAskToChooseStarterText:
	text_far _OaksLabGirlAskToChooseStarterText
	text_end

.GirlGivingItemsText:
	text_far _OaksLabGirlGivingItemsText
	text_end

.GotItemsNotificationText:
	text_far _OaksLabGirlGotItemsNotificationText
	sound_get_key_item
	text_end

.GirlAlreadyGaveItemsText:
	text_far _OaksLabGirlAlreadyGaveItemsText
	text_end

OaksLabWaitForKeyItemTriggerScript:
	CheckEvent EVENT_GOT_STARTER
	ret z
	CheckEvent EVENT_GOT_POKEDEX
	ret nz

	ld a, [wYCoord]
	cp 11
	ret nz

	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, SCRIPT_OAKSLAB_GIRL_TRIGGERS
	ld [wOaksLabCurScript], a
	ret

OaksLabRivalFedUpWithWaitingText:
	text_asm
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_far _OaksLabRivalFedUpWithWaitingText
	text_end

OaksLabOakChooseMonText:
	text_asm
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_far _OaksLabOakChooseMonText
	text_end

OaksLabRivalWhatAboutMeText:
	text_asm
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_far _OaksLabRivalWhatAboutMeText
	text_end

OaksLabOakBePatientText:
	text_asm
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_far _OaksLabOakBePatientText
	text_end

OaksLabOakDontGoAwayYetText:
	text_asm
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_far _OaksLabOakDontGoAwayYetText
	text_end

OaksLabRivalIllTakeThisOneText:
	text_asm
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_far _OaksLabRivalIllTakeThisOneText
	text_end

OaksLabRivalReceivedMonText:
	text_asm
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_far _OaksLabRivalReceivedMonText
	sound_get_key_item
	text_end

OaksLabRivalIllTakeYouOnText:
	text_asm
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_far _OaksLabRivalIllTakeYouOnText
	text_end

OaksLabRivalIPickedTheWrongPokemonText:
	text_far _OaksLabRivalIPickedTheWrongPokemonText
	text_end

OaksLabRivalAmIGreatOrWhatText:
	text_far _OaksLabRivalAmIGreatOrWhatText
	text_end

OaksLabRivalSmellYouLaterText:
	text_asm
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_far _OaksLabRivalSmellYouLaterText
	text_end

OaksLabScientistText:
	text_asm
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_far _OaksLabScientistText
	text_end
