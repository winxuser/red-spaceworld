; stores hl in [wTrainerHeaderPtr]
StoreTrainerHeaderPointer::
	ld a, h
	ld [wTrainerHeaderPtr], a
	ld a, l
	ld [wTrainerHeaderPtr + 1], a
	ret

; executes current map script from the function pointer array provided in de.
ExecuteCurMapScriptInTable::
	push af
	push de
	call StoreTrainerHeaderPointer
	pop hl
	pop af
	push hl
	ld hl, wStatusFlags7
	bit BIT_USE_CUR_MAP_SCRIPT, [hl]
	res BIT_USE_CUR_MAP_SCRIPT, [hl]
	jr z, .useProvidedIndex
	ld a, [wCurMapScript]
.useProvidedIndex
	pop hl
	ld [wCurMapScript], a
	call CallFunctionInTable
	ld a, [wCurMapScript]
	ret

LoadGymLeaderAndCityName::
	push de
	ld de, wGymCityName
	ld bc, GYM_CITY_LENGTH
	rst _CopyData ; load city name
	pop hl
	ld de, wGymLeaderName
	ld bc, NAME_LENGTH
	jp CopyData   ; load gym leader name

ReadTrainerHeaderInfo::
	push de
	push af
	ld d, 0
	ld e, a
	ld hl, wTrainerHeaderPtr
	ld a, [hli]
	ld l, [hl]
	ld h, a
	add hl, de
	pop af
	and a
	jr nz, .nonZeroOffset
	ld a, [hl]
	ld [wTrainerHeaderFlagBit], a
	jr .done

.nonZeroOffset
	cp $a
	jr nz, .readPointer
	ld a, [hli]
	ld d, [hl]
	ld e, a
	jr .done

.readPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a

.done
	pop de
	ret

TrainerFlagAction::
	predef_jump FlagActionPredef

TalkToTrainer::
	call StoreTrainerHeaderPointer
	xor a
	call ReadTrainerHeaderInfo     ; read flag's bit
	ld a, $2
	call ReadTrainerHeaderInfo     ; read flag's byte ptr
	ld a, [wTrainerHeaderFlagBit]
	ld c, a
	ld b, FLAG_TEST
	call TrainerFlagAction      ; read trainer's flag
	ld a, c
	and a
	jr z, .trainerNotYetFought
	ld a, $6
	call ReadTrainerHeaderInfo     ; print after battle text
	jp PrintText

.trainerNotYetFought
	ld a, $4
	call ReadTrainerHeaderInfo     ; print before battle text
	rst _PrintText
	ld a, $a
	call ReadTrainerHeaderInfo
	push de
	ld a, $8
	call ReadTrainerHeaderInfo     ; read end battle text
	pop de
	call SaveEndBattleTextPointers
	ld hl, wStatusFlags7
	set BIT_USE_CUR_MAP_SCRIPT, [hl]
	ld hl, wMiscFlags
	bit BIT_SEEN_BY_TRAINER, [hl]
	ret nz
; if the player talked to the trainer of his own volition
	call EngageMapTrainer
	ld hl, wCurMapScript
	inc [hl]
	jp StartTrainerBattle

; checks if any trainers are seeing the player and wanting to fight
CheckFightingMapTrainers::
IF DEF(_DEBUG)
	call DebugPressedOrHeldB
	jr nz, .trainerNotEngaging
ENDC
	call CheckForEngagingTrainers
	ld a, [wSpriteIndex]
	cp $ff
	jr nz, .trainerEngaging
IF DEF(_DEBUG)
.trainerNotEngaging
ENDC
	xor a
	ld [wSpriteIndex], a
	ld [wTrainerHeaderFlagBit], a
	ret

.trainerEngaging
	ld hl, wStatusFlags7
	set BIT_TRAINER_BATTLE, [hl]
	ld [wEmotionBubbleSpriteIndex], a
	xor a ; EXCLAMATION_BUBBLE
	ld [wWhichEmotionBubble], a
	predef EmotionBubble
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	xor a
	ldh [hJoyHeld], a
	call TrainerWalkUpToPlayer_Bank0
	ld hl, wCurMapScript
	inc [hl]
	ret

; display before battle text after enemy trainer walked up to player
DisplayEnemyTrainerTextAndStartBattle::
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	ld [wJoyIgnore], a
	ld a, [wSpriteIndex]
	ldh [hSpriteIndex], a
	call DisplayTextID
	; fall through

StartTrainerBattle::
	xor a
	ld [wJoyIgnore], a
	call InitBattleEnemyParameters
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, wStatusFlags4
	set BIT_UNKNOWN_4_1, [hl]
	ld hl, wCurMapScript
	inc [hl]
	ret

EndTrainerBattle::
	ld hl, wCurrentMapScriptFlags
	set BIT_CUR_MAP_LOADED_1, [hl]
	set BIT_CUR_MAP_LOADED_2, [hl]
	ld hl, wStatusFlags3
	res BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, wMiscFlags
	res BIT_SEEN_BY_TRAINER, [hl]
	ld a, [wIsInBattle]
	cp $ff
	jr z, EndTrainerBattleWhiteout
	ld a, $2
	call ReadTrainerHeaderInfo
	ld a, [wTrainerHeaderFlagBit]
	ld c, a
	ld b, FLAG_SET
	call TrainerFlagAction   ; flag trainer as fought
	ld a, [wWasTrainerBattle]
	and a
	jr nz, .skipRemoveSprite
	ld a, [wCurMap]
	cp POKEMON_TOWER_7F
	jr z, .skipRemoveSprite
	ld hl, wToggleableObjectList
	ld de, 2
	ld a, [wSpriteIndex]
	call IsInArray
	inc hl
	ld a, [hl]
	ld [wToggleableObjectIndex], a
	predef HideObject

.skipRemoveSprite
	xor a
	ld [wWasTrainerBattle], a
	ld hl, wStatusFlags5
	bit BIT_UNKNOWN_5_4, [hl]
	res BIT_UNKNOWN_5_4, [hl]
	ret nz

EndTrainerBattleWhiteout::
	xor a
	ld [wIsTrainerBattle], a
	ld [wWasTrainerBattle], a
	ld [wJoyIgnore], a
	ldh [hJoyHeld], a
	ldh [hJoyPressed], a
	ldh [hJoyReleased], a
	ld [wCurMapScript], a
	ret

TrainerWalkUpToPlayer_Bank0::
	farjp TrainerWalkUpToPlayer

InitBattleEnemyParameters::
	ld a, [wEngagedTrainerClass]
	ld [wCurOpponent], a
	ld [wEnemyMonOrTrainerClass], a
	ld a, [wIsTrainerBattle]
	and a
	ld a, [wEngagedTrainerSet]
	jr z, .noTrainer
	ld [wTrainerNo], a
	ret
.noTrainer
	ld [wCurEnemyLevel], a
	ret

GetSpritePosition1::
	ld hl, _GetSpritePosition1
	jr SpritePositionBankswitch

GetSpritePosition2::
	ld hl, _GetSpritePosition2
	jr SpritePositionBankswitch

SetSpritePosition1::
	ld hl, _SetSpritePosition1
	jr SpritePositionBankswitch

SetSpritePosition2::
	ld hl, _SetSpritePosition2
SpritePositionBankswitch::
	ld b, BANK("Trainer Sight")
	jp Bankswitch

CheckForEngagingTrainers::
	xor a
	call ReadTrainerHeaderInfo       ; read trainer flag's bit (unused)
	ld d, h                          ; store trainer header address in de
	ld e, l

.trainerLoop
	call StoreTrainerHeaderPointer   ; set trainer header pointer to current trainer
	ld a, [de]
	ld [wSpriteIndex], a             ; store trainer flag's bit
	ld [wTrainerHeaderFlagBit], a
	cp -1
	ret z
	ld a, $2
	call ReadTrainerHeaderInfo       ; read trainer flag's byte ptr
	ld b, FLAG_TEST
	ld a, [wTrainerHeaderFlagBit]
	ld c, a
	call TrainerFlagAction           ; read trainer flag
	ld a, c
	and a
	jr nz, .continue
	push hl
	push de
	push hl
	xor a
	call ReadTrainerHeaderInfo       ; get trainer header pointer
	inc hl
	ld a, [hl]                       ; read trainer engage distance
	pop hl
	ld [wTrainerEngageDistance], a
	ld a, [wSpriteIndex]
	swap a
	ld [wTrainerSpriteOffset], a
	predef TrainerEngage
	pop de
	pop hl
	ld a, [wTrainerSpriteOffset]
	and a
	ret nz ; break if trainer is engaging

.continue
	ld hl, $c
	add hl, de
	ld d, h
	ld e, l
	jr .trainerLoop

SaveEndBattleTextPointers::
	ldh a, [hLoadedROMBank]
	ld [wEndBattleTextRomBank], a
	ld a, h
	ld [wEndBattleWinTextPointer], a
	ld a, l
	ld [wEndBattleWinTextPointer + 1], a
	ld a, d
	ld [wEndBattleLoseTextPointer], a
	ld a, e
	ld [wEndBattleLoseTextPointer + 1], a
	ret

EngageMapTrainer::
	ld hl, wMapSpriteExtraData
	ld d, 0
	ld a, [wSpriteIndex]
	dec a
	add a
	ld e, a
	add hl, de
	ld a, [hli]    ; load trainer class
	ld [wEngagedTrainerClass], a
	ld a, [hl]     ; load trainer mon set
	bit 7, a
	jr nz, .pokemon
	ld [wEngagedTrainerSet], a
	ld a, 1
	ld [wIsTrainerBattle], a
	jp PlayTrainerMusic

.pokemon
	and $7f
	ld [wEngagedTrainerSet], a
	xor a
	ld [wIsTrainerBattle], a
	jp PlayTrainerMusic

PrintEndBattleText::
	push hl
	ld hl, wStatusFlags3
	bit BIT_PRINT_END_BATTLE_TEXT, [hl]
	res BIT_PRINT_END_BATTLE_TEXT, [hl]
	pop hl
	ret z
	ldh a, [hLoadedROMBank]
	push af
	ld a, [wEndBattleTextRomBank]
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	push hl
	farcall SaveTrainerName
	ld hl, TrainerEndBattleText
	rst _PrintText
	pop hl
	pop af
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	farcall SetEnemyTrainerToStayAndFaceAnyDirection
	jp WaitForSoundToFinish

GetSavedEndBattleTextPointer::
	ld a, [wBattleResult]
	and a
	jr nz, .lostBattle
	ld a, [wEndBattleWinTextPointer]
	ld h, a
	ld a, [wEndBattleWinTextPointer + 1]
	ld l, a
	ret

.lostBattle
	ld a, [wEndBattleLoseTextPointer]
	ld h, a
	ld a, [wEndBattleLoseTextPointer + 1]
	ld l, a
	ret

TrainerEndBattleText::
	text_far _TrainerNameText
	text_asm
	call GetSavedEndBattleTextPointer
	call TextCommandProcessor
	rst TextScriptEnd

CheckIfAlreadyEngaged::
	ld a, [wMiscFlags]
	bit BIT_SEEN_BY_TRAINER, a
	ret nz
	call EngageMapTrainer
	xor a
	ret

PlayTrainerMusic::
	ld a, [wEngagedTrainerClass]
	cp OPP_RIVAL1
	ret z
	cp OPP_RIVAL2
	ret z
	cp OPP_RIVAL3
	ret z
	ld a, [wGymLeaderNo]
	and a
	ret nz
	xor a
	ld [wMusicFade], a
	ld a, SFX_STOP_ALL_MUSIC
	rst _PlaySound
	ld a, [wEngagedTrainerClass]
	ld b, a
	ld hl, EvilTrainerList

.evilTrainerListLoop
	ld a, [hli]
	cp $ff
	jr z, .noEvilTrainer
	cp b
	jr nz, .evilTrainerListLoop
	ld a, MUSIC_MEET_EVIL_TRAINER
	jr .PlaySound

.noEvilTrainer
	ld hl, FemaleTrainerList

.femaleTrainerListLoop
	ld a, [hli]
	cp $ff
	jr z, .maleTrainer
	cp b
	jr nz, .femaleTrainerListLoop
	ld a, MUSIC_MEET_FEMALE_TRAINER
	jr .PlaySound

.maleTrainer
	ld a, MUSIC_MEET_MALE_TRAINER

.PlaySound
	jp PlayMusic

INCLUDE "data/trainers/encounter_types.asm"
