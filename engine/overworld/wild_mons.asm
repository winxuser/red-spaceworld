LoadWildData::
    ; Select the wild encounter table for this map group.
    ld a, [wCurMapGroup]
    cp MAPGROUP_REGION_2
    jr z, .region2

    ; Nihon encounter table.
    ld hl, WildDataPointers
    jr .gotTable

.region2
    ; Region 2 encounter table.
    ld hl, Region2WildDataPointers

.gotTable
    ; Get the current map number.
    ld a, [wCurMap]
    ld c, a
    ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a       ; hl now points to wild data for current map
	ld a, [hli]
	ld [wGrassRate], a
	and a
	jr z, .NoGrassData ; if no grass data, skip to surfing data
	push hl
	ld de, wGrassMons ; otherwise, load grass data
	ld bc, WILDDATA_LENGTH - 1 ; dereknote: changed from $14 to $18 to accomodate 2 more wild encounter slots per map
	rst _CopyData
	pop hl
	ld bc, WILDDATA_LENGTH - 1 ; dereknote: changed from $14 to $18 to accomodate 2 more wild encounter slots per map
	add hl, bc
.NoGrassData
	ld a, [hli]
	ld [wWaterRate], a
	and a
	ret z        ; if no water data, we're done
	ld de, wWaterMons  ; otherwise, load surfing data
	ld bc, WILDDATA_LENGTH - 1 ; dereknote: changed from $14 to $18 to accomodate 2 more wild encounter slots per map
	jp CopyData

INCLUDE "data/wild/grass_water.asm"
