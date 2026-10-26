; try to initiate a wild pokemon encounter
; returns success in Z
TryDoWildEncounter:
	ld a, [wNPCMovementScriptPointerTableNum]
	and a
	ret nz
	ld a, [wMovementFlags]
	and a ; is player exiting a door, jumping over a ledge, or fishing?
	ret nz
	callfar IsPlayerStandingOnDoorTileOrWarpTile
	jr nc, .checkOutside
.CantEncounter
	ld a, $1
	and a
	ret

.checkOutside
	callfar IsPlayerJustOutsideMap
	jr z, .CantEncounter

	ld hl, wRepelRemainingSteps
	ld a, [hl]
	and a
	jr z, .checkTile
	dec [hl]
	jr z, .lastRepelStep

.checkTile
; determine if wild pokemon can appear in the half-block we're standing in
; is the bottom right tile (9,9) of the half-block we're standing in a grass/water tile?
	hlcoord 9, 9
	ld c, [hl]
	ld a, [wGrassTile]
	cp c
	ld a, [wGrassRate]
	jr z, .CanEncounterRate
	ld a, $14 ; water tile ID
	cp c
	ld a, [wWaterRate]
	jr z, .CanEncounterRate

; check indoor map / forest exceptions
	ld a, [wCurMap]
	cp FIRST_INDOOR_MAP
	jr c, .CantEncounter
	ld a, [wCurMapTileset]
	cp FOREST ; Viridian Forest/Safari Zone
	jr z, .CantEncounter
	ld a, [wGrassRate]

.CanEncounterRate
; compare encounter chance with a random number
	ld b, a
	call Random
	cp b
	jr nc, .CantEncounter

	call Random
	ld b, a
	ld hl, WildMonEncounterSlotChances
.determineEncounterSlot
	ld a, [hli]
	cp b
	jr nc, .gotEncounterSlot
	inc hl
	jr .determineEncounterSlot

.gotEncounterSlot
; determine which wild pokemon (grass or water) can appear
	ld c, [hl]
	ld hl, wGrassMons
	lda_coord 8, 9
	cp $14 ; is the bottom left tile (8,9) a water tile?
	jr nz, .gotWildEncounterType
	ld hl, wWaterMons

.gotWildEncounterType
	ld b, 0
	add hl, bc
	ld a, [hli]
	ld [wCurEnemyLevel], a
	ld a, [hl]
	ld [wCurPartySpecies], a
	ld [wEnemyMonSpecies2], a

	ld a, [wRepelRemainingSteps]
	and a
	jr z, .willEncounter
	ld a, [wPartyMon1Level]
	ld b, a
	ld a, [wCurEnemyLevel]
	cp b
	jr c, .CantEncounter ; repel prevents encounters if leading mon level is higher

.willEncounter
	xor a
	ld [wIsTrainerBattle], a
	ret

.lastRepelStep
	ld a, TEXT_REPEL_WORE_OFF
	ldh [hTextID], a
	call EnableAutoTextBoxDrawing
	call DisplayTextID
	jp .CantEncounter

INCLUDE "data/wild/probabilities.asm"
