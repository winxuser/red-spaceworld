; creates a set of moves that may be used and returns its address in hl
; unused slots are filled with 0, all used slots may be chosen with equal probability
AIEnemyTrainerChooseMoves:
	ld a, $a
	ld hl, wBuffer ; init temporary move selection array. Only the moves with the lowest numbers are chosen in the end
	ld [hli], a   ; move 1
	ld [hli], a   ; move 2
	ld [hli], a   ; move 3
	ld [hl], a    ; move 4
	ld a, [wEnemyDisabledMove] ; forbid disabled move (if any)
	swap a
	and $f
	jr z, .noMoveDisabled
	ld hl, wBuffer
	dec a
	ld c, a
	ld b, $0
	add hl, bc    ; advance pointer to forbidden move
	ld [hl], $50  ; forbid (highly discourage) disabled move
.noMoveDisabled
	ld hl, TrainerClassMoveChoiceModifications
	ld a, [wTrainerClass]
	ld b, a
.loopTrainerClasses
	dec b
	jr z, .readTrainerClassData
.loopTrainerClassData
	ld a, [hli]
	and a
	jr nz, .loopTrainerClassData
	jr .loopTrainerClasses
.readTrainerClassData
	ld a, [hl]
	and a
	jp z, .useOriginalMoveSet
	push hl
.nextMoveChoiceModification
	pop hl
	ld a, [hli]
	and a
	jr z, .loopFindMinimumEntries
	push hl
	ld hl, AIMoveChoiceModificationFunctionPointers
	dec a
	add a
	ld c, a
	ld b, 0
	add hl, bc    ; skip to pointer
	ld a, [hli]   ; read pointer into hl
	ld h, [hl]
	ld l, a
	ld de, .nextMoveChoiceModification  ; set return address
	push de
	jp hl         ; execute modification function
.loopFindMinimumEntries ; all entries will be decremented sequentially until one of them is zero
	ld hl, wBuffer  ; temp move selection array
	ld de, wEnemyMonMoves  ; enemy moves
	ld c, NUM_MOVES
.loopDecrementEntries
	ld a, [de]
	inc de
	and a
	jr z, .loopFindMinimumEntries
	dec [hl]
	jr z, .minimumEntriesFound
	inc hl
	dec c
	jr z, .loopFindMinimumEntries
	jr .loopDecrementEntries
.minimumEntriesFound
	ld a, c
.loopUndoPartialIteration ; undo last (partial) loop iteration
	inc [hl]
	dec hl
	inc a
	cp NUM_MOVES + 1
	jr nz, .loopUndoPartialIteration
	ld hl, wBuffer  ; temp move selection array
	ld de, wEnemyMonMoves  ; enemy moves
	ld c, NUM_MOVES
.filterMinimalEntries ; all minimal entries now have value 1. All other slots will be disabled (move set to 0)
	ld a, [de]
	and a
	jr nz, .moveExisting
	ld [hl], a
.moveExisting
	ld a, [hl]
	dec a
	jr z, .slotWithMinimalValue
	xor a
	ld [hli], a     ; disable move slot
	jr .next
.slotWithMinimalValue
	ld a, [de]
	ld [hli], a     ; enable move slot
.next
	inc de
	dec c
	jr nz, .filterMinimalEntries
	ld hl, wBuffer    ; use created temporary array as move set
	ret
.useOriginalMoveSet
	ld hl, wEnemyMonMoves    ; use original move set
	ret

AIMoveChoiceModificationFunctionPointers:
	dw AIMoveChoiceModification1
	dw AIMoveChoiceModification2
	dw AIMoveChoiceModification3
	dw AIMoveChoiceModification4
	dw AIMoveChoiceModification5
	dw AIMoveChoiceModification6
    dw AIMoveChoiceModification7

; discourages moves that cause no damage but only a status ailment if player's mon already has one
AIMoveChoiceModification1:
	ld a, [wBattleMonStatus]
	and a
	ret z ; return if no status ailment on player's mon
	ld hl, wBuffer - 1 ; temp move selection array (-1 byte offset)
	ld de, wEnemyMonMoves ; enemy moves
	ld b, NUM_MOVES + 1
.nextMove
	dec b
	ret z ; processed all 4 moves
	inc hl
	ld a, [de]
	and a
	ret z ; no more moves in move set
	inc de
	call ReadMove
	ld a, [wEnemyMovePower]
	and a
	jr nz, .nextMove
	ld a, [wEnemyMoveEffect]
	push hl
	push de
	push bc
	ld hl, StatusAilmentMoveEffects
	ld de, 1
	call IsInArray
	pop bc
	pop de
	pop hl
	jr nc, .nextMove
	ld a, [hl]
	add $5 ; heavily discourage move
	ld [hl], a
	jr .nextMove

StatusAilmentMoveEffects:
	db EFFECT_01 ; unused sleep effect
	db SLEEP_EFFECT
	db POISON_EFFECT
	db PARALYZE_EFFECT
	db -1 ; end

; slightly encourage moves with specific effects.
; in particular, stat-modifying moves and other move effects
; that fall in-between
AIMoveChoiceModification2:
	ld a, [wAILayer2Encouragement]
	cp $1
	ret nz
	ld hl, wBuffer - 1 ; temp move selection array (-1 byte offset)
	ld de, wEnemyMonMoves ; enemy moves
	ld b, NUM_MOVES + 1
.nextMove
	dec b
	ret z ; processed all 4 moves
	inc hl
	ld a, [de]
	and a
	ret z ; no more moves in move set
	inc de
	call ReadMove
	ld a, [wEnemyMoveEffect]
	cp ATTACK_UP1_EFFECT
	jr c, .nextMove
	cp BIDE_EFFECT
	jr c, .preferMove
	cp ATTACK_UP2_EFFECT
	jr c, .nextMove
	cp POISON_EFFECT
	jr c, .preferMove
	jr .nextMove
.preferMove
	dec [hl] ; slightly encourage this move
	jr .nextMove

; encourages moves that are effective against the player's mon (even if non-damaging).
; discourage damaging moves that are ineffective or not very effective against the player's mon,
; unless there's no damaging move that deals at least neutral damage
; - Heavily discourages immune moves (multiplier = 0)
; - Discourages resisted / ineffective moves (multiplier < 1.0)
; - Encourages super-effective moves (multiplier > 1.0)
AIMoveChoiceModification3:
	ld hl, wBuffer - 1
	ld de, wEnemyMonMoves ; enemy moves
	ld b, NUM_MOVES + 1
.nextMove
	dec b
	ret z ; processed all 4 moves
	inc hl
	ld a, [de]
	and a
	ret z ; no more moves in move set
	inc de
	call ReadMove
	; Ignore status moves (power 0) so status moves aren't penalized by type match
	ld a, [wEnemyMovePower]
	and a
	jr z, .nextMove
	push hl
	push bc
	push de
	callfar AIGetTypeEffectiveness
	pop de
	pop bc
	pop hl
	ld a, [wTypeEffectiveness]
	cp 10 ; neutral damage (1.0x = $10 / 16)
	jr z, .nextMove ; neutral move, no modification needed
	jr c, .lessEffective
	dec [hl] ; encourage move (lower value in wBuffer = higher priority)
	cp 40 ; 2.0x effectiveness
	jr c, .nextMove
	dec [hl] ; heavily encourage 4x super-effective moves (e.g. Rock vs Charizard)
	jr .nextMove
.lessEffective
	and a ; is effectiveness 0 (immune)?
	jr z, .immuneMove
	inc [hl] ; slightly discourage resisted move (0.5x or 0.25x)
	jr .nextMove
.immuneMove
	ld a, [hl]
	add $20 ; heavily penalize immune moves (e.g., Thunderbolt vs Ground)
	ld [hl], a
	jr .nextMove

; Encourages recovery moves only when enemy HP is below 50%.
; Encourages high-critical-hit ratio moves (from HighCriticalMoves table).
AIMoveChoiceModification4:
	ld hl, wBuffer - 1 ; temp move selection array (-1 byte offset)
	ld de, wEnemyMonMoves ; enemy moves
	ld b, NUM_MOVES + 1
.nextMove
	dec b
	ret z ; processed all 4 moves
	inc hl
	ld a, [de]
	and a
	ret z ; no more moves in move set
	inc de
	call ReadMove
	ld a, [wEnemyMoveEffect]
	cp HEAL_EFFECT
	jr z, .checkRecoveryHP
	jr .checkHighCrit
.checkRecoveryHP
	; It's a recovery move. Check if enemy HP is below 50% (fraction value 2).
	push hl
	push bc
	push de
	ld a, 2 ; 1/2 HP threshold (50%)
	call AICheckIfHPBelowFraction
	pop de
	pop bc
	pop hl
	jr c, .preferRecovery ; HP is < 50%, encourage healing!
	; HP is >= 50%, heavily discourage wasting a turn healing
	ld a, [hl]
	add $15
	ld [hl], a
	jr .nextMove
.preferRecovery
	dec [hl] ; slightly encourage recovery when hurt
	jr .nextMove
.checkHighCrit
    ; DE points to the next move, so step back
    ; to retrieve the current move ID.
    dec de
    ld a, [de]
    inc de

    push hl
    push de
    push bc

    ld hl, HighCriticalMoves
    ld de, 1
    call IsInArray

    pop bc
    pop de
    pop hl

    jr nc, .nextMove

    ; Slightly encourage high-critical-hit moves.
    dec [hl]
    jr .nextMove
	pop bc
	pop de
	pop hl
	jr nc, .nextMove ; not in table, move on
	dec [hl] ; slightly encourage high-crit moves
	jr .nextMove

; AI Layer 5 - Smart Stat Modification AI
;
; Discourages stat-changing moves when:
; - The user's stat is already at maximum (+6)
; - The target's stat is already at minimum (-6)
;
; Supports all six stats and both 1-stage and 2-stage effects.

AIMoveChoiceModification5:
    ld hl, wBuffer - 1
    ld de, wEnemyMonMoves
    ld b, NUM_MOVES + 1

.nextMove
    dec b
    ret z

    inc hl

    ld a, [de]
    and a
    ret z

    inc de

    call ReadMove

    ld a, [wEnemyMoveEffect]

    push hl
    push bc
    push de

    call .CheckStatLimit

    pop de
    pop bc
    pop hl

    jr nc, .nextMove

    ; Move cannot change the stat any further.
    ; Heavily discourage it.
    ld a, [hl]
    add 5
    ld [hl], a

    jr .nextMove

.CheckStatLimit

    ; One-stage stat increases ($0A-$0F).
    cp ATTACK_UP1_EFFECT
    jr c, .notStatMove

    cp EVASION_UP1_EFFECT + 1
    jr c, .upOne

    ; One-stage stat decreases ($12-$17).
    cp ATTACK_DOWN1_EFFECT
    jr c, .notStatMove

    cp EVASION_DOWN1_EFFECT + 1
    jr c, .downOne

    ; Two-stage stat increases ($32-$37).
    cp ATTACK_UP2_EFFECT
    jr c, .notStatMove

    cp EVASION_UP2_EFFECT + 1
    jr c, .upTwo

    ; Two-stage stat decreases ($3A-$3F).
    cp ATTACK_DOWN2_EFFECT
    jr c, .notStatMove

    cp EVASION_DOWN2_EFFECT + 1
    jr c, .downTwo

.notStatMove
    and a
    ret

.upOne
    sub ATTACK_UP1_EFFECT
    jr .checkEnemyStat

.upTwo
    sub ATTACK_UP2_EFFECT

.checkEnemyStat
    ld c, a
    ld b, 0

    ld hl, wEnemyMonStatMods
    add hl, bc

    ld a, [hl]
    cp 13
    jr z, .atLimit

    and a
    ret

.downOne
    sub ATTACK_DOWN1_EFFECT
    jr .checkPlayerStat

.downTwo
    sub ATTACK_DOWN2_EFFECT

.checkPlayerStat
    ld c, a
    ld b, 0

    ld hl, wPlayerMonStatMods
    add hl, bc

    ld a, [hl]
    cp 1
    jr z, .atLimit

    and a
    ret


.atLimit
    scf
    ret

; AI Layer 6 - Smart Status and Defensive Move AI
;
; Discourages non-damaging moves when their effect
; is already active or cannot be applied again.

AIMoveChoiceModification6:
    ld hl, wBuffer - 1
    ld de, wEnemyMonMoves
    ld b, NUM_MOVES + 1

.nextMove
    dec b
    ret z

    inc hl

    ld a, [de]
    and a
    ret z

    inc de
    call ReadMove

    push hl
    push de
    push bc

    call .CheckRedundantStatusMove

    pop bc
    pop de
    pop hl

    jr nc, .nextMove

    ; Heavily discourage a redundant move.
    ld a, [hl]
    add 5
    ld [hl], a

    jr .nextMove

.CheckRedundantStatusMove

    ; Ignore damaging moves, including attacks with
    ; secondary status effects.
    ld a, [wEnemyMovePower]
    and a
    jp nz, .notRedundant

    ld a, [wEnemyMoveEffect]

    ; Major status conditions
    cp SLEEP_EFFECT
    jr z, .checkMajorStatus

    cp POISON_EFFECT
    jr z, .checkMajorStatus

    cp PARALYZE_EFFECT
    jr z, .checkMajorStatus

    ; Confusion
    cp CONFUSION_EFFECT
    jr z, .checkConfusion

    ; Leech Seed
    cp LEECH_SEED_EFFECT
    jr z, .checkLeechSeed

    ; Substitute
    cp SUBSTITUTE_EFFECT
    jr z, .checkSubstitute

    ; Reflect
    cp REFLECT_EFFECT
    jr z, .checkReflect

    ; Light Screen
    cp LIGHT_SCREEN_EFFECT
    jr z, .checkLightScreen

    jp .notRedundant

.checkMajorStatus
    ld a, [wBattleMonStatus]
    and a
    jr nz, .redundant
    jr .notRedundant

.checkConfusion
    ld a, [wPlayerBattleStatus1]
    bit CONFUSED, a
    jr nz, .redundant
    jr .notRedundant

.checkLeechSeed
    ld a, [wPlayerBattleStatus2]
    bit SEEDED, a
    jr nz, .redundant
    jr .notRedundant

.checkSubstitute
    ld a, [wEnemyBattleStatus2]
    bit HAS_SUBSTITUTE_UP, a
    jr nz, .redundant
    jr .notRedundant

.checkReflect
    ld a, [wEnemyBattleStatus3]
    bit HAS_REFLECT_UP, a
    jr nz, .redundant
    jr .notRedundant

.checkLightScreen
    ld a, [wEnemyBattleStatus3]
    bit HAS_LIGHT_SCREEN_UP, a
    jr nz, .redundant

.notRedundant
    and a
    ret

.redundant
    scf
    ret

; Layer 7 - Attack Strength Awareness
;
; Encourages powerful damaging attacks and STAB.
; Leaves fixed-damage and special-effect attacks alone.
AIMoveChoiceModification7:
    ld hl, wBuffer - 1
    ld de, wEnemyMonMoves
    ld b, NUM_MOVES + 1

.nextMove
    dec b
    ret z

    inc hl

    ld a, [de]
    and a
    ret z

    inc de
    call ReadMove

    push hl
    push bc
    push de

    call .ScoreAttack

    pop de
    pop bc
    pop hl

    jr .nextMove

.ScoreAttack
    ; Ignore non-damaging moves.
    ld a, [wEnemyMovePower]
    and a
    ret z

    ; Fixed-damage and unusual damage mechanics
    ; need separate evaluation later.
    ld a, [wEnemyMoveEffect]

    cp SPECIAL_DAMAGE_EFFECT
    ret z

    cp SUPER_FANG_EFFECT
    ret z

    cp OHKO_EFFECT
    ret z

    cp TWO_TO_FIVE_ATTACKS_EFFECT
    ret z

    cp EFFECT_1E
    ret z

    cp ATTACK_TWICE_EFFECT
    ret z

    ld a, [wEnemyMovePower]

    cp 100
    jr nc, .veryStrong

    cp 70
    jr nc, .strong

    cp 40
    jr c, .weak

    jr .checkSTAB

.veryStrong
    ; Strongly prefer attacks with 100+ base power.
    dec [hl]
    dec [hl]
    jr .checkSTAB

.strong
    ; Slightly prefer attacks with 70-99 base power.
    dec [hl]
    jr .checkSTAB

.weak
    ; Slightly discourage attacks below 40 power.
    inc [hl]

.checkSTAB
    ; Consider the offensive and defensive stats.
    call .ScoreStatMatchup

    ; Consider move accuracy.
    call .ScoreAccuracy

    ; Check same-type attack bonus.
    ld a, [wEnemyMoveType]
    ld b, a

    ld a, [wEnemyMonType]
    cp b
    jr z, .preferSTAB

    ld a, [wEnemyMonType + 1]
    cp b
    ret nz

.preferSTAB
    ; Prefer attacks matching the user's type.
    dec [hl]
    ret

.ScoreAccuracy
    ld a, [wEnemyMoveAccuracy]

    ; 90% accuracy or better: no penalty.
    cp 230
    ret nc

    ; 75% to 89%: small penalty.
    cp 191
    jr nc, .smallPenalty

    ; Below 75%: stronger penalty.
    inc [hl]
    inc [hl]
    ret

.smallPenalty
    inc [hl]
    ret

.ScoreStatMatchup
    push hl

    ld a, [wEnemyMoveType]
    cp SPECIAL
    jr nc, .specialStats

    ; Physical attack
    ld hl, wEnemyMonAttack
    ld de, wBattleMonDefense
    jr .compareStats

.specialStats
    ; Special attack
    ld hl, wEnemyMonSpecial
    ld de, wBattleMonSpecial

.compareStats
    ; Compare high bytes first.
    ld a, [de]
    ld b, a
    ld a, [hli]
    cp b
    jr c, .defenseHigher
    jr nz, .attackHigher

    ; High bytes equal: compare low bytes.
    inc de
    ld a, [de]
    ld b, a
    ld a, [hl]
    cp b
    jr c, .defenseHigher
    jr z, .equalStats

.attackHigher
    pop hl
    dec [hl]
    ret

.defenseHigher
    pop hl
    inc [hl]
    ret

.equalStats
    pop hl
    ret

ReadMove:
	push hl
	push de
	push bc
	dec a
	ld hl, Moves
	ld bc, MOVE_LENGTH
	call AddNTimes
	ld de, wEnemyMoveNum
	rst _CopyData
	pop bc
	pop de
	pop hl
	ret

INCLUDE "data/trainers/move_choices.asm"

INCLUDE "data/trainers/pic_pointers_money.asm"

INCLUDE "data/trainers/names.asm"

INCLUDE "engine/battle/misc.asm"

INCLUDE "engine/battle/read_trainer_party.asm"

INCLUDE "data/trainers/special_moves.asm"

INCLUDE "data/trainers/parties.asm"

TrainerAI:
	and a
	ld a, [wIsInBattle]
	dec a
	ret z ; if not a trainer, we're done here
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	ret z ; if in a link battle, we're done as well
	ld a, [wTrainerClass] ; what trainer class is this?
	dec a
	ld c, a
	ld b, 0
	ld hl, TrainerAIPointers
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, [wAICount]
	and a
	ret z ; if no AI uses left, we're done here
	inc hl
	inc a
	jr nz, .getpointer
	dec hl
	ld a, [hli]
	ld [wAICount], a
.getpointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call Random
	jp hl

INCLUDE "data/trainers/ai_pointers.asm"

JugglerAI:
	cp 25 percent + 1
	jp c, AISwitchIfEnoughMons
	ret

BlackbeltAI:
	cp 13 percent - 1
	jp c, AIUseDireHit
	ret

GiovanniAI:
	cp 25 percent + 1
	jp c, AIUseGuardSpec
	ret

CooltrainerMAI:
	cp 25 percent + 1
	jp c, AIUseXSpecial
	ld a, 5
	call AICheckIfHPBelowFraction
	jp c, AISwitchIfEnoughMons
	ret

CooltrainerFAI:
	; The intended 25% chance to consider switching will not apply.
	; Uncomment the line below to fix this.
	cp 25 percent + 1
	; ret nc
	jp c, AIUseXAccuracy
	ld a, 5
	call AICheckIfHPBelowFraction
	jp c, AISwitchIfEnoughMons
	ret

BrockAI:
; if his active monster has a status condition, use a full heal
	ld a, [wEnemyMonStatus]
	and a
	jp nz, AIUseFullHeal
	ret

MistyAI:
	cp 25 percent + 1
	jp c, AIUseXDefend
	ret

LtSurgeAI:
	cp 25 percent + 1
	jp c, AIUseXSpeed
	ret

ErikaAI:
	cp 50 percent + 1
	jr nc, .erikareturn
	ld a, 10
	call AICheckIfHPBelowFraction
	jp c, AIUseSuperPotion
.erikareturn
	ret

KogaAI:
	cp 25 percent + 1
	jp c, AIUseXAttack
	ret

BlaineAI:
	cp 25 percent + 1
	jr nc, .blainereturn
	ld a, 10
	call AICheckIfHPBelowFraction
	jp c, AIUseHyperPotion
.blainereturn
	ret

SabrinaAI:
	cp 25 percent + 1
	jr nc, .sabrinareturn
	ld a, 10
	call AICheckIfHPBelowFraction
	jp c, AIUseHyperPotion
.sabrinareturn
	ret

Rival2AI:
	cp 13 percent - 1
	jr nc, .rival2return
	ld a, 5
	call AICheckIfHPBelowFraction
	jp c, AIUsePotion
.rival2return
	ret

Rival3AI:
	cp 13 percent - 1
	jr nc, .rival3return
	ld a, 5
	call AICheckIfHPBelowFraction
	jp c, AIUseFullRestore
.rival3return
	ret

LoreleiAI:
	cp 50 percent + 1
	jr nc, .loreleireturn
	ld a, 5
	call AICheckIfHPBelowFraction
	jp c, AIUseSuperPotion
.loreleireturn
	ret

BrunoAI:
	cp 25 percent + 1
	jp c, AIUseXDefend
	ret

AgathaAI:
	cp 8 percent
	jp c, AISwitchIfEnoughMons
	cp 50 percent + 1
	jr nc, .agathareturn
	ld a, 4
	call AICheckIfHPBelowFraction
	jp c, AIUseSuperPotion
.agathareturn
	ret

LanceAI:
	cp 50 percent + 1
	jr nc, .lancereturn
	ld a, 5
	call AICheckIfHPBelowFraction
	jp c, AIUseHyperPotion
.lancereturn
	ret

GenericAI:
	and a ; clear carry
	ret

; end of individual trainer AI routines

DecrementAICount:
	ld hl, wAICount
	dec [hl]
	scf
	ret

AIPlayRestoringSFX:
	ld a, SFX_HEAL_AILMENT
	jp PlaySoundWaitForCurrent

AIUseFullRestore:
	call AICureStatus
	ld a, FULL_RESTORE
	ld [wAIItem], a
	ld de, wHPBarOldHP
	ld hl, wEnemyMonHP + 1
	ld a, [hld]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	inc de
	ld hl, wEnemyMonMaxHP + 1
	ld a, [hld]
	ld [de], a
	inc de
	ld [wHPBarMaxHP], a
	ld [wEnemyMonHP + 1], a
	ld a, [hl]
	ld [de], a
	ld [wHPBarMaxHP+1], a
	ld [wEnemyMonHP], a
	jr AIPrintItemUseAndUpdateHPBar

AIUsePotion:
; enemy trainer heals his monster with a potion
	ld a, POTION
	ld b, 20
	jr AIRecoverHP

AIUseSuperPotion:
; enemy trainer heals his monster with a super potion
	ld a, SUPER_POTION
	ld b, 50
	jr AIRecoverHP

AIUseHyperPotion:
; enemy trainer heals his monster with a hyper potion
	ld a, HYPER_POTION
	ld b, 200
	; fallthrough

AIRecoverHP:
; heal b HP and print "trainer used $(a) on pokemon!"
	ld [wAIItem], a
	ld hl, wEnemyMonHP + 1
	ld a, [hl]
	ld [wHPBarOldHP], a
	add b
	ld [hld], a
	ld [wHPBarNewHP], a
	ld a, [hl]
	ld [wHPBarOldHP+1], a
	ld [wHPBarNewHP+1], a
	jr nc, .next
	inc a
	ld [hl], a
	ld [wHPBarNewHP+1], a
.next
	inc hl
	ld a, [hld]
	ld b, a
	ld de, wEnemyMonMaxHP + 1
	ld a, [de]
	dec de
	ld [wHPBarMaxHP], a
	sub b
	ld a, [hli]
	ld b, a
	ld a, [de]
	ld [wHPBarMaxHP+1], a
	sbc b
	jr nc, AIPrintItemUseAndUpdateHPBar
	inc de
	ld a, [de]
	dec de
	ld [hld], a
	ld [wHPBarNewHP], a
	ld a, [de]
	ld [hl], a
	ld [wHPBarNewHP+1], a
	; fallthrough

AIPrintItemUseAndUpdateHPBar:
	call AIPrintItemUse_
	hlcoord 2, 2
	xor a
	ld [wHPBarType], a
	predef UpdateHPBar2
	jp DecrementAICount

AISwitchIfEnoughMons:
; enemy trainer switches if there are 2 or more unfainted mons in party
	ld a, [wEnemyPartyCount]
	ld c, a
	ld hl, wEnemyMon1HP

	ld d, 0 ; keep count of unfainted monsters

	; count how many monsters haven't fainted yet
.loop
	ld a, [hli]
	ld b, a
	ld a, [hld]
	or b
	jr z, .Fainted ; has monster fainted?
	inc d
.Fainted
	push bc
	ld bc, PARTYMON_STRUCT_LENGTH
	add hl, bc
	pop bc
	dec c
	jr nz, .loop

	ld a, d ; how many available monsters are there?
	cp 2    ; don't bother if only 1
	jp nc, SwitchEnemyMon
	and a
	ret

SwitchEnemyMon:

; prepare to withdraw the active monster: copy HP, party pos, and status to roster

	ld a, [wEnemyMonPartyPos]
	ld hl, wEnemyMon1HP
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld d, h
	ld e, l
	ld hl, wEnemyMonHP
	ld bc, MON_STATUS + 1 - MON_HP ; also copies party pos in-between HP and status
	rst _CopyData

	ld hl, AIBattleWithdrawText
	rst _PrintText

	; This wFirstMonsNotOutYet variable is abused to prevent the player from
	; switching in a new mon in response to this switch.
	ld a, 1
	ld [wFirstMonsNotOutYet], a
	callfar EnemySendOut
	xor a
	ld [wFirstMonsNotOutYet], a

	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	ret z
	scf
	ret

AIBattleWithdrawText:
	text_far _AIBattleWithdrawText
	text_end

AIUseFullHeal:
	call AIPlayRestoringSFX
	call AICureStatus
	ld a, FULL_HEAL
	jp AIPrintItemUse

AICureStatus:
; cures the status of enemy's active pokemon
	ld a, [wEnemyMonPartyPos]
	ld hl, wEnemyMon1Status
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	xor a
	ld [hl], a ; clear status in enemy team roster
	ld [wEnemyMonStatus], a ; clear status of active enemy
	ld hl, wEnemyBattleStatus3
	res BADLY_POISONED, [hl]
	ret

AIUseXAccuracy: ; unreferenced
	call AIPlayRestoringSFX
	ld hl, wEnemyBattleStatus2
	set USING_X_ACCURACY, [hl]
	ld a, X_ACCURACY
	jp AIPrintItemUse

AIUseGuardSpec:
	call AIPlayRestoringSFX
	ld hl, wEnemyBattleStatus2
	set PROTECTED_BY_MIST, [hl]
	ld a, GUARD_SPEC
	jp AIPrintItemUse

AIUseDireHit: ; unreferenced
	call AIPlayRestoringSFX
	ld hl, wEnemyBattleStatus2
	set GETTING_PUMPED, [hl]
	ld a, DIRE_HIT
	jp AIPrintItemUse

AICheckIfHPBelowFraction:
; return carry if enemy trainer's current HP is below 1 / a of the maximum
	ldh [hDivisor], a
	ld hl, wEnemyMonMaxHP
	ld a, [hli]
	ldh [hDividend], a
	ld a, [hl]
	ldh [hDividend + 1], a
	ld b, 2
	call Divide
	ldh a, [hQuotient + 3]
	ld c, a
	ldh a, [hQuotient + 2]
	ld b, a
	ld hl, wEnemyMonHP + 1
	ld a, [hld]
	ld e, a
	ld a, [hl]
	ld d, a
	ld a, d
	sub b
	ret nz
	ld a, e
	sub c
	ret

AIUseXAttack:
	ld b, ATTACK_UP1_EFFECT
	ld a, X_ATTACK
	jr AIIncreaseStat

AIUseXDefend:
	ld b, DEFENSE_UP1_EFFECT
	ld a, X_DEFEND
	jr AIIncreaseStat

AIUseXSpeed:
	ld b, SPEED_UP1_EFFECT
	ld a, X_SPEED
	jr AIIncreaseStat

AIUseXSpecial:
	ld b, SPECIAL_UP1_EFFECT
	ld a, X_SPECIAL
	; fallthrough

AIIncreaseStat:
	ld [wAIItem], a
	push bc
	call AIPrintItemUse_
	pop bc
	ld hl, wEnemyMoveEffect
	ld a, [hld]
	push af
	ld a, [hl]
	push af
	push hl
	ld a, XSTATITEM_DUPLICATE_ANIM
	ld [wAltAnimationID], a
	ld [hli], a
	ld [hl], b
	callfar StatModifierUpEffect
	pop hl
	pop af
	ld [hli], a
	pop af
	ld [hl], a
	jp DecrementAICount

AIPrintItemUse:
	ld [wAIItem], a
	call AIPrintItemUse_
	jp DecrementAICount

AIPrintItemUse_:
; print "x used [wAIItem] on z!"
	ld a, [wAIItem]
	ld [wNamedObjectIndex], a
	call GetItemName
	ld hl, AIBattleUseItemText
	jp PrintText

AIBattleUseItemText:
	text_far _AIBattleUseItemText
	text_end
