PlayerStepOutFromDoor::
	ld hl, wStatusFlags5
	res BIT_UNKNOWN_5_1, [hl]
	call IsPlayerStandingOnDoorTile
	jr nc, .notStandingOnDoor
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld hl, wMovementFlags
	set BIT_EXITING_DOOR, [hl]
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, PAD_DOWN
	ld [wSimulatedJoypadStatesEnd], a
	xor a
	ld [wSpritePlayerStateData1ImageIndex], a
	call StartSimulatingJoypadStates
	ret
.notStandingOnDoor
	xor a
	ld [wUnusedOverrideSimulatedJoypadStatesIndex], a
	ld [wSimulatedJoypadStatesIndex], a
	ld [wSimulatedJoypadStatesEnd], a
	ld hl, wMovementFlags
	res BIT_STANDING_ON_DOOR, [hl]
	res BIT_EXITING_DOOR, [hl]
	ld hl, wStatusFlags5
	res BIT_SCRIPTED_MOVEMENT_STATE, [hl]
	ret

_EndNPCMovementScript::
	ld hl, wStatusFlags5
	res BIT_SCRIPTED_MOVEMENT_STATE, [hl]
	ld hl, wStatusFlags4
	res BIT_INIT_SCRIPTED_MOVEMENT, [hl]
	ld hl, wMovementFlags
	res BIT_STANDING_ON_DOOR, [hl]
	res BIT_EXITING_DOOR, [hl]
	xor a
	ld [wNPCMovementScriptSpriteOffset], a
	ld [wNPCMovementScriptPointerTableNum], a
	ld [wNPCMovementScriptFunctionNum], a
	ld [wUnusedOverrideSimulatedJoypadStatesIndex], a
	ld [wSimulatedJoypadStatesIndex], a
	ld [wSimulatedJoypadStatesEnd], a
	ret

PalletMovementScriptPointerTable::
	dw PalletMovementScript_OakMoveLeft     ; Index 0
	dw PalletMovementScript_PlayerMoveLeft   ; Index 1
	dw PalletMovementScript_WalkToLab        ; Index 2
	dw PalletMovementScript_Done             ; Index 3

PalletMovementScript_OakMoveLeft::
	; Force the sprite engine to process Oak horizontally/manually
	ld hl, wSpritePlayerStateData1 + 2
	ld a, NPC_MOVEMENT_LEFT
	ld [hl], a

	ld hl, wNPCMovementDirections2

	ld a, [wYCoord]
	cp 9
	jr nz, .buildLeftSteps

	ld a, NPC_MOVEMENT_DOWN
	ld [hli], a

.buildLeftSteps
	ld b, 4
.walkLeftLoop
	ld a, NPC_MOVEMENT_LEFT
	ld [hli], a
	dec b
	jr nz, .walkLeftLoop

	ld [hl], $ff            ; Terminator byte

	ld a, [wSpriteIndex]
	ldh [hSpriteIndex], a
	ld de, wNPCMovementDirections2
	call MoveSprite

	xor a
	ld [wNumStepsToTake], a

	ld a, $1                ; Move to index 1 (PlayerMoveLeft)
	ld [wNPCMovementScriptFunctionNum], a

	ld hl, wStatusFlags7
	set BIT_NO_MAP_MUSIC, [hl]
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ret

PalletMovementScript_PlayerMoveLeft:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz ; Wait here until Oak finishes his footsteps
	; Force Oak to look left
	ld a, [wSpriteIndex]
	swap a
	ld l, a
	ld h, HIGH(wSpriteStateData1)
	inc l
	inc l
	ld [hl], SPRITE_FACING_LEFT
	xor a
	ld [wSimulatedJoypadStatesIndex], a
	ld [wSimulatedJoypadStatesEnd], a
	ld [wOverrideSimulatedJoypadStatesMask], a

	ld a, [wSpriteIndex]
	swap a
	ld [wNPCMovementScriptSpriteOffset], a
	xor a
	ld [wSpritePlayerStateData2MovementByte1], a

	; Check which row the sequence started on
	ld a, [wYCoord]
	cp 9
	jr z, .adjustForRow9

	ld a, 4
	ld [RLEList_ProfOakWalkToLab + 3], a
	ld a, 4
	ld [RLEList_PlayerWalkToLab + 3], a
	jr .decodePaths

.adjustForRow9
	ld a, 3
	ld [RLEList_ProfOakWalkToLab + 3], a
	ld a, 3
	ld [RLEList_PlayerWalkToLab + 3], a

.decodePaths
	ld hl, wSimulatedJoypadStatesEnd
	ld de, RLEList_PlayerWalkToLab
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a

	ld hl, wNPCMovementDirections2
	ld de, RLEList_ProfOakWalkToLab
	call DecodeRLEList

	ld hl, wStatusFlags4
	res BIT_INIT_SCRIPTED_MOVEMENT, [hl]
	ld hl, wStatusFlags5
	set BIT_SCRIPTED_MOVEMENT_STATE, [hl]

	ld a, $2
	ld [wNPCMovementScriptFunctionNum], a
	ret

PalletMovementScript_WalkToLab:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz

	ld a, $3
	ld [wNPCMovementScriptFunctionNum], a
	ret

PalletMovementScript_Done:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	ld a, TOGGLE_SILENT_HILL_OAK
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld hl, wStatusFlags5
	res BIT_SCRIPTED_MOVEMENT_STATE, [hl]
	ld hl, wStatusFlags4
	res BIT_INIT_SCRIPTED_MOVEMENT, [hl]
	jp EndNPCMovementScript

RLEList_ProfOakWalkToLab:
	db NPC_MOVEMENT_RIGHT, 5
	db NPC_MOVEMENT_DOWN, 4
	db NPC_MOVEMENT_RIGHT, 5
	db NPC_MOVEMENT_UP, 1
	db -1 ; end

RLEList_PlayerWalkToLab:
	db PAD_UP, 3
	db PAD_RIGHT, 5
	db PAD_DOWN, 4
	db PAD_RIGHT, 6
	db -1 ; end

PewterMuseumGuyMovementScriptPointerTable::
	dw PewterMovementScript_WalkToMuseum
	dw PewterMovementScript_Done

PewterMovementScript_WalkToMuseum:
;	ld a, 0 ; BANK(Music_MuseumGuy)
;	ld [wAudioROMBank], a
;	ld [wAudioSavedROMBank], a
	ld a, MUSIC_MUSEUM_GUY
;	ld [wNewSoundID], a
	call PlayMusic
	ld a, [wSpriteIndex]
	swap a
	ld [wNPCMovementScriptSpriteOffset], a
	call StartSimulatingJoypadStates
	ld hl, wSimulatedJoypadStatesEnd
	ld de, RLEList_PewterMuseumPlayer
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	xor a
	ld [wWhichPewterGuy], a
	predef PewterGuys
	ld hl, wNPCMovementDirections2
	ld de, RLEList_PewterMuseumGuy
	call DecodeRLEList
	ld hl, wStatusFlags4
	res BIT_INIT_SCRIPTED_MOVEMENT, [hl]
	ld a, $1
	ld [wNPCMovementScriptFunctionNum], a
	ret

RLEList_PewterMuseumPlayer:
	db NO_INPUT, 1
	db PAD_UP, 3
	db PAD_LEFT, 13
	db PAD_UP, 6
	db -1 ; end

RLEList_PewterMuseumGuy:
	db NPC_MOVEMENT_UP, 6
	db NPC_MOVEMENT_LEFT, 13
	db NPC_MOVEMENT_UP, 3
	db NPC_MOVEMENT_LEFT, 1
	db -1 ; end

PewterMovementScript_Done:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	ld hl, wStatusFlags5
	res BIT_SCRIPTED_MOVEMENT_STATE, [hl]
	ld hl, wStatusFlags4
	res BIT_INIT_SCRIPTED_MOVEMENT, [hl]
	jp EndNPCMovementScript

PewterGymGuyMovementScriptPointerTable::
	dw PewterMovementScript_WalkToGym
	dw PewterMovementScript_Done

PewterMovementScript_WalkToGym:
;	ld a, 0 ; BANK(Music_MuseumGuy)
;	ld [wAudioROMBank], a
;	ld [wAudioSavedROMBank], a
	ld a, MUSIC_MUSEUM_GUY
;	ld [wNewSoundID], a
	call PlayMusic
	ld a, [wSpriteIndex]
	swap a
	ld [wNPCMovementScriptSpriteOffset], a
	xor a
	ld [wSpritePlayerStateData2MovementByte1], a
	ld hl, wSimulatedJoypadStatesEnd
	ld de, RLEList_PewterGymPlayer
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	ld a, 1
	ld [wWhichPewterGuy], a
	predef PewterGuys
	ld hl, wNPCMovementDirections2
	ld de, RLEList_PewterGymGuy
	call DecodeRLEList
	ld hl, wStatusFlags4
	res BIT_INIT_SCRIPTED_MOVEMENT, [hl]
	ld hl, wStatusFlags5
	set BIT_SCRIPTED_MOVEMENT_STATE, [hl]
	ld a, $1
	ld [wNPCMovementScriptFunctionNum], a
	ret

RLEList_PewterGymPlayer:
	db NO_INPUT, 1
	db PAD_RIGHT, 2
	db PAD_DOWN, 5
	db PAD_LEFT, 11
	db PAD_UP, 5
	db PAD_LEFT, 15
	db -1 ; end

RLEList_PewterGymGuy:
	db NPC_MOVEMENT_DOWN, 2
	db NPC_MOVEMENT_LEFT, 15
	db NPC_MOVEMENT_UP, 5
	db NPC_MOVEMENT_LEFT, 11
	db NPC_MOVEMENT_DOWN, 5
	db NPC_MOVEMENT_RIGHT, 3
	db -1 ; end

SetEnemyTrainerToStayAndFaceAnyDirection::
	ld a, [wCurMap]
	cp POKEMON_TOWER_7F
	ret z ; the Rockets on Pokemon Tower 7F leave after battling, so don't set them
	ld hl, RivalIDs
	ld a, [wEngagedTrainerClass]
	ld b, a
.loop
	ld a, [hli]
	cp -1
	jr z, .notRival
	cp b
	ret z ; the rival leaves after battling, so don't set him
	jr .loop
.notRival
	ld a, [wSpriteIndex]
	ldh [hSpriteIndex], a
	jp SetSpriteMovementBytesToFF

RivalIDs:
	db OPP_RIVAL1
	db OPP_RIVAL2
	db OPP_RIVAL3
	db -1 ; end
