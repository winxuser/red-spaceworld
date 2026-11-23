; Cross-region map warp handling.
; Called after WarpFound2 has selected the destination map.
EnterWarpWithMapGroup::
    ; Preserve the original door-state handling.
    ld hl, wMovementFlags
    set BIT_STANDING_ON_DOOR, [hl]

    ; LAST_MAP already restores wLastMapGroup.
    ldh a, [hWarpDestinationMap]

    cp LAST_MAP
    jr z, .enterMap

    ; Identify the source group, map and warp.
    ld a, [wCurMapGroup]
    ld b, a

    ld a, [wWarpedFromWhichMap]
    ld c, a

    ld a, [wWarpedFromWhichWarp]
    ld d, a

    ld hl, CrossRegionWarpTable

.loop
    ld a, [hli]
    cp $ff
    jr z, .enterMap

    ; Source map group
    cp b
    jr nz, .skipThree

    ; Source map ID
    ld a, [hli]
    cp c
    jr nz, .skipTwo

    ; Source warp ID (zero-based)
    ld a, [hli]
    cp d
    jr nz, .skipOne

    ; Matching cross-region warp.
    ld a, [hl]
    ld [wCurMapGroup], a
    jr .enterMap

.skipThree
    inc hl
.skipTwo
    inc hl
.skipOne
    inc hl
    jr .loop

.enterMap
    call IgnoreInputForHalfSecond
    jp EnterMap


; Source group, source map, warp index, destination group.

CrossRegionWarpTable:
    ; Entries generated automatically by def_warps_to.

